/*
INDEX:
1. terraform-vm --> Pulls image from dockerhub and pushes it to Artifact Registry on the start-up script
2. docker-vm --> Pulls and deploys image from Artifact Registry on the start-up script. Commented out as this is now done with Managed Instance Group.
3. docker-optimised-vm --> Uses a Container-Optimised OS and deploys the image on port 5000. Commented out as this is now done with Managed Instance Group.
4. Instance template --> Used by the Manager Instance Group
*/

resource "google_compute_instance" "terraform-vm" {
  name         = "terraform-vm"
  machine_type = local.default_vars.default_machine_type
  zone         = local.zone
  # Needs the repository to be created for the start-up script to be run succesfully:
  depends_on = [google_artifact_registry_repository.docker-repository]

  tags = ["http-server", "https-server", "ingress5000", "ingress8000", "allow-ssh", "allow-icmp"]
  allow_stopping_for_update = true
  desired_status = "RUNNING"
  # The start-up script may fail if the Artifact Registry was enabled recently
  metadata_startup_script = file("data/scripts/pull_and_push.sh")
  deletion_protection = local.deletion_protection
  /*
  In order to delete this machine, it is needed to first set `deletion_protection` to false and `terraform apply`,
  followed by the actual deletion. It is a two-step process.
  The second step can be replaced by count=0 or `terraform destroy -target google_compute_instance.terraform-vm` as well
  */

  labels = {
    created_by = "terraform"
  }

  boot_disk {
    source = google_compute_disk.boot-disk-vm.name
  }
  /* Local SSD disk
  scratch_disk {
    interface = "SCSI"
    size = "10"
  }
  */

  attached_disk {
    mode = "READ_WRITE"
    source = google_compute_disk.terraform-additional-persistent-disk.name
  }

  network_interface {
    network = google_compute_network.terraform-network-for-each.name
    subnetwork = google_compute_subnetwork.for-each-subnets["europe-west1"].name
    # Subnet in europe-west1

    access_config {
      // Static public IP
      network_tier="STANDARD"
      nat_ip = google_compute_address.terraform-static-ip.address
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email  = google_service_account.default.email -> If not specified, uses Compute Engine's default one
    scopes = ["cloud-platform"]
  }
  
}

/*
resource "google_compute_instance" "docker-vm" {
  name         = "docker-vm"
  machine_type = local.default_vars.default_machine_type
  zone         = local.zone
  # Needs the image to have been pushed before by the other VM:
  depends_on = [google_artifact_registry_repository.docker-repository, google_compute_instance.terraform-vm]

  tags = ["http-server", "https-server", "ingress5000", "ingress8000", "allow-ssh", "allow-icmp"]
  allow_stopping_for_update = true
  desired_status = "RUNNING"
  metadata_startup_script = file("data/scripts/deploy.sh")
  deletion_protection = local.deletion_protection

  labels = {
    created_by = "terraform"
  }

  boot_disk {
    initialize_params {
      image = local.default_vars.default_ubuntu_image
    }
  }

  network_interface {
    network = google_compute_network.terraform-network-for-each.name
    subnetwork = google_compute_subnetwork.for-each-subnets["europe-west1"].name
    # Subnet in europe-west1

    access_config {
      // Ephemeral public IP
      network_tier="STANDARD"
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email  = google_service_account.default.email -> If not specified, uses Compute Engine's default one
    scopes = ["cloud-platform"]
  }
  
}

resource "google_compute_instance" "docker-optimised-vm" {
  name         = "docker-optimised-vm"
  machine_type = local.default_vars.default_machine_type
  zone         = local.zone
  # Needs the image to have been pushed before by the other VM:
  depends_on = [google_artifact_registry_repository.docker-repository, google_compute_instance.terraform-vm]

  tags = ["http-server", "https-server", "ingress5000", "ingress8000", "allow-ssh", "allow-icmp"]
  allow_stopping_for_update = true
  desired_status = "RUNNING"
  deletion_protection = local.deletion_protection

  labels = {
    created_by = "terraform"
  }

  boot_disk {
    initialize_params {
      image = local.default_vars.default_cos_image  # Container-Optimised OS
    }
  }

  network_interface {
    network = google_compute_network.terraform-network-for-each.name
    subnetwork = google_compute_subnetwork.for-each-subnets["europe-west1"].name
    # Subnet in europe-west1

    access_config {
      // Ephemeral public IP
      network_tier="STANDARD"
    }
  }

  # We specify here the image to run on container-optimised OS:
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

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email  = google_service_account.default.email -> If not specified, uses Compute Engine's default one
    scopes = ["cloud-platform"]
  }
  
}
*/

resource "google_compute_instance_template" "mig-template" {
  name        = "mig-template"
  description = "Exposes Artifact Registry image on port 5000. Used to create a Managed Instance Group"

  tags = ["http-server", "https-server", "ingress5000", "ingress8000", "allow-ssh", "allow-icmp"]

  labels = {
    created_by = "terraform"
  }

  instance_description = "description assigned to instances"
  machine_type         = local.default_vars.default_machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    boot = true
    auto_delete = true
    source_image  = local.default_vars.default_cos_image  # Container-Optimised OS
    labels = {
      created_by = "terraform"
    }
  }

  network_interface {
    network = google_compute_network.terraform-network-for-each.name
    subnetwork = google_compute_subnetwork.for-each-subnets["europe-west1"].name
    # Subnet in europe-west1

    access_config {
      // Ephemeral public IP
      network_tier="STANDARD"
    }
  }
  /*
  Even though we are setting metadata here, the gce-container-declaration seems to be
  ignored here. We will provide it in the Google Compute Instance Manager
  */
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

  service_account {
    scopes = ["cloud-platform"]
  }
}
