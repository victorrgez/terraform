resource "google_compute_instance" "docker-optimised-vm-mongodb" {
  name         = "docker-optimised-vm-mongodb-${var.user}"
  machine_type = var.default_machine_type
  zone         = var.zone
  depends_on = [google_artifact_registry_repository.vms]

  tags = ["allow-icmp", "allow-mongodb"]
  allow_stopping_for_update = true
  desired_status = "RUNNING"
  deletion_protection = false

  labels = local.default_labels

  boot_disk {
    initialize_params {
      image = var.default_cos_image  # Container-Optimised OS
    }
  }

  network_interface {
    network = google_compute_network.different_vpc.name
    subnetwork = google_compute_subnetwork.different_vpc_subnet.name
    network_ip = "10.0.0.35"
    # Subnet in europe-west1
  }

  # We specify here the image to run on container-optimised OS:
  metadata = {
    gce-container-declaration =<<EOT
      spec:
        containers:
          - image: ${var.region}-docker.pkg.dev/${var.project_id}/${var.vms_repo}/mongodb:latest
            name: mongodb
            securityContext:
              privileged: false
            stdin: false
            tty: false
            restartPolicy: Always
            env:
              - name: MONGO_INITDB_ROOT_PASSWORD
                value: samplepassword
              - name: MONGO_INITDB_ROOT_USERNAME
                value: sampleuser
      EOT
  }
  
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email  = google_service_account.default.email -> If not specified, uses Compute Engine's default one
    scopes = ["cloud-platform"]
  }
  
}