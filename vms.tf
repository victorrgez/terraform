resource "google_compute_instance" "terraform-vm" {
  name         = "terraform-vm"
  machine_type = local.default_machine_type
  zone         = local.zone

  tags = ["ingress5000", "ingress8000"]
  allow_stopping_for_update = true
  desired_status = "RUNNING"

  deletion_protection = true
  /*
  In order to delete this machine, it is needed to first set `deletion_protection` to false and `terraform apply`,
  followed by count=0 and `terraform apply`. It is a two-step process.
  The second step can be replaced by `terraform destroy -target google_compute_instance.terraform-vm` as well
  */

  labels = {
    created_by = "terraform"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20221018"
      size = "50"
      type = local.default_disk_type
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
    network = google_compute_network.terraform-network-array-lookup.name
    subnetwork = google_compute_subnetwork.array-lookup-subnets[0].name
    # Subnet in europe-west1

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