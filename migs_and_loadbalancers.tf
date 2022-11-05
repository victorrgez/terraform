resource "google_compute_health_check" "tcp-health-check-5000" {
  name = "tcp-health-check-5000"

  timeout_sec        = 5
  check_interval_sec = 60

  tcp_health_check {
    port = "5000"
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
    health_check      = google_compute_health_check.tcp-health-check-5000.id
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


resource google_compute_backend_service "backend-calculator" {
  name          = "backend-calculator"
  health_checks = [google_compute_health_check.tcp-health-check-5000.id]
  enable_cdn    = false
  port_name = "calculatorapp"
  backend {
    group = google_compute_instance_group_manager.mig-calculator.instance_group
    description = "Managed Instance Group with Docker Image"
    balancing_mode = "UTILIZATION"
    max_utilization = 0.8
  }
}
