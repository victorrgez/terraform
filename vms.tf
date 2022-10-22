resource "google_compute_instance" "terraform-vm" {
  name         = "terraform-vm"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"

  tags = ["ingress5000", "ingress8000"]
  allow_stopping_for_update = true

  desired_status = "RUNNING"

  labels = {
    created_by = "terraform"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20221018"
      size = "50"
      type = "pd-standard"
      labels = {
        created_by = "terraform"
      }
    }
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
    network = google_compute_network.terraform-network-with-subnets.name

    access_config {
      // Ephemeral public IP
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