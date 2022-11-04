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

  # target_pools = [google_compute_target_pool.appserver.id]
  target_size  = 2
  named_port {
    name = "app"
    port = 5000
  }
  /*
    auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
    }
  */
}
