

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
  metadata_startup_script = file("data/scripts/start-up.sh")
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