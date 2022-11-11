/*
In order to deploy a Load Balancer with an instance group we need the following resources:

-Instance template with either a start-up script or with a container optimised boot image plus an image in Artifact Registry --> Available in vms.tf

-Health checks --> Both regional and global. We will need a healthcheck in the same region as the backend service, however; if we have a regional
                   load balancer and mig, we still need a global health check so that the MIG's autohealing works properly

-Instance Group Manager --> Defines the MIG. If using COS, we need to pass the image information directly here instead of in the
                            instance template. If not using autoscaler, need to provide the target number of VMs as well. Need to specify NAMED PORT!

-Autoscaler --> Minimum and maximum number of replicas and autoscaling policies for the MIG

-Backend service --> Configure the MIG to be a backend for LoadBalancers in a specific region/globally and which kind of protocol it will use

-URL-map --> Same load balancer with same IP can send different routes to different backend services (and/or to different hosts)

-HTTP-proxy --> Functionality bounded to an URL-MAP. Handles the conneciiton part.
                Terminates a connection from LB and opens a new one to the backend service.
                Several LB can use the same proxy to use a specific URL map.
                It is important to have a proxy-only subnet in your network

-Static-IP --> Important to always have the same IP in your Load Balancer so that you can configure a Domain in order for your customers (or internal service) to
               be able to access your Load Balancer reliably through the Domain Name.

-Forwarding Rule --> The Load Balancer itself. Uses a protocol, IP, target(http proxy for example) and is based in a region. Connects everything described above.

Additional details:

·There are many types of Load Balancers and the use case needs to be studied thoroughly (TCP, SSL, Internal, etc)
·Cloud Armor can be attached as a WAF (Web Application Firewall)
·Named port from MING (port_name in backend service) is the port that LB will use to comunicate with MIG, wheras we will use port-range to access LB
*/

resource google_compute_health_check "global-http-health-check-5000" {
  /* Autohealing requires that we create a global health check for the MIG
  even if it is a regional resource */
  name = "${terraform.workspace}-global-http-health-check-5000"
  
  timeout_sec        = 5
  check_interval_sec = 60

  http_health_check {
    port = "5000"
    request_path = "/"
  }
}

resource google_compute_region_health_check "http-health-check-5000" {
  name = "${terraform.workspace}-http-health-check-5000"
  
  timeout_sec        = 5
  check_interval_sec = 60

  http_health_check {
    port = "5000"
    request_path = "/"
  }
}

resource google_compute_instance_group_manager "mig-calculator" {
  name = "${terraform.workspace}-mig-calculator"
  provider = google-beta

  base_instance_name = "${terraform.workspace}-mig-calculator"
  zone               = local.zone

  version {
    instance_template  = google_compute_instance_template.mig-template.id
  }
  
  all_instances_config {
    metadata = {
    gce-container-declaration =<<EOT
      spec:
        containers:
          - image: ${local.docker_image}
            name: calculator
            securityContext:
              privileged: false
            stdin: false
            tty: false
            restartPolicy: Always
      EOT
    }
  
    labels = {
      created_by = "terraform"
      mig = "mig-calculator"
    }
  }

  # target_size  = 2 --> Only used without an autoscaler
  named_port {
    name = "calculatorapp"
    port = 5000
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.global-http-health-check-5000.id
    initial_delay_sec = 300
  }
  
}

resource google_compute_autoscaler "mig-autoscaler" {
  name = "${terraform.workspace}-mig-autoscaler"
  zone = local.zone
  target = google_compute_instance_group_manager.mig-calculator.id
  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60
    cpu_utilization {
      target = 0.6
    }
  }
}

resource google_compute_region_backend_service "backend-calculator" {
  name          = "${terraform.workspace}-backend-calculator"
  health_checks = [google_compute_region_health_check.http-health-check-5000.id]
  region = local.region
  enable_cdn    = false
  port_name = "calculatorapp"
  protocol = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  backend {
    group = google_compute_instance_group_manager.mig-calculator.instance_group
    description = "Managed Instance Group with Docker Image"
    balancing_mode = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1
  }
}

resource google_compute_region_url_map "loadbalancer-urlmap" {
  name        = "${terraform.workspace}-loadbalancer-urlmap"

  default_service = google_compute_region_backend_service.backend-calculator.id

  host_rule {
    hosts = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.backend-calculator.id

    path_rule {  # Not needed. We can use it for specifying different backend depending on the path
      paths   = ["/*"]
      service = google_compute_region_backend_service.backend-calculator.id
    }
  }

}

resource google_compute_region_target_http_proxy "loadbalancer-calculator" {
  name            = "${terraform.workspace}-loadbalancer-calculator"
  url_map         = google_compute_region_url_map.loadbalancer-urlmap.id
  description     = "Listens on port 80 and load balances against port 5000 of the Managed Instance Group"
}

resource google_compute_forwarding_rule "frontend-load-balancer" {
  name                  = "${terraform.workspace}-frontend-load-balancer"
  # provider              = google-beta
  region                = local.region
  ip_protocol           = "TCP"
  ip_address            = google_compute_address.load-balancer-static-ip.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.loadbalancer-calculator.id
  # Only for internal LB but, if we do not specify network, it tries to look for default network:
  network               = var.network
  network_tier          = "STANDARD"
  depends_on            = [var.proxy_only_subnet] # Dummy variable to propagate dependencies
}

/*
------------------------------------------------------------------------
This is how we can deploy a Load Balancer with GCS (we need to give
public access to the bucket too):
------------------------------------------------------------------------


resource google_compute_backend_bucket "gcs-lb-backend" {
  name        = "gcs-lb-backend"
  description = "Contains ml datasets"
  bucket_name = google_storage_bucket.terraform-trial-europe-west1-1.name
  enable_cdn  = false
}

resource google_compute_url_map "gcs-lb-urlmap" {
  name        = "gcs-lb-urlmap"

  default_service = google_compute_backend_bucket.gcs-lb-backend.id

  host_rule {
    hosts = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.gcs-lb-backend.id
  }

}

resource google_compute_target_http_proxy "gcs-lb-http-proxy" {
  name            = "gcs-lb-http-proxy"
  url_map         = google_compute_url_map.gcs-lb-urlmap.id
  description     = "Serves GCS bucket with ML datasets"
}

resource google_compute_global_forwarding_rule "gcs-lb-frontend" {
  name                  = "gcs-lb-frontend"
  # provider              = google-beta
  ip_protocol           = "TCP"
  ip_address            = google_compute_global_address.gcs-lb-static-ip.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.gcs-lb-http-proxy.id
  # Only for internal LB but, if we do not specify network, it tries to look for default network:
  #network               = google_compute_network.terraform-network-for-each.name
  #depends_on            = [google_compute_subnetwork.for-each-proxy-only-subnet]
}
*/