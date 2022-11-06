resource google_compute_health_check "global-http-health-check-5000" {
  /* Autohealing requires that we create a global health check for the MIG
  even if it is a regional resource */
  name = "global-http-health-check-5000"
  
  timeout_sec        = 5
  check_interval_sec = 60

  http_health_check {
    port = "5000"
    request_path = "/"
  }
}

resource google_compute_region_health_check "http-health-check-5000" {
  name = "http-health-check-5000"
  
  timeout_sec        = 5
  check_interval_sec = 60

  http_health_check {
    port = "5000"
    request_path = "/"
  }
}

resource "google_compute_instance_group_manager" "mig-calculator" {
  name = "mig-calculator"
  provider = google-beta

  base_instance_name = "mig-calculator"
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
  name = "mig-autoscaler"
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
  name          = "backend-calculator"
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

resource "google_compute_region_url_map" "loadbalancer-urlmap" {
  name        = "loadbalancer-urlmap"

  default_service = google_compute_region_backend_service.backend-calculator.id

  host_rule {
    hosts = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.backend-calculator.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_region_backend_service.backend-calculator.id
    }
  }

}

resource "google_compute_region_target_http_proxy" "loadbalancer-calculator" {
  name            = "loadbalancer-calculator"
  url_map         = google_compute_region_url_map.loadbalancer-urlmap.id
  description     = "Listens on port 80 and load balances against port 5000 of the Managed Instance Group"
}

resource "google_compute_forwarding_rule" "frontend-load-balancer" {
  name                  = "frontend-load-balancer"
  # provider              = google-beta
  region                = local.region
  ip_protocol           = "TCP"
  ip_address            = google_compute_address.load-balancer-static-ip.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.loadbalancer-calculator.id
  # Only for internal LB but, if we do not specify network, it tries to look for default network:
  network               = google_compute_network.terraform-network-for-each.name
  network_tier          = "STANDARD"
}