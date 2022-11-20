resource "google_compute_firewall" "http-server" {
  project     = local.project_id
  name        = "http-server"
  network     = google_compute_network.terraform-network-for-each.name
  description = "Allow HTTP"
  
  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
  /*
  deny{
    protocol
    ports
  }
  */

  direction   = "INGRESS"
  priority = 1000
  source_ranges = flatten([var.vpc_internal_ip_ranges.primary,
                           var.vpc_internal_ip_ranges.secondary])
  target_tags = ["http-server"]
}

resource "google_compute_firewall" "https-server" {
  project     = local.project_id
  name        = "https-server"
  network     = google_compute_network.terraform-network-for-each.name
  description = "Allow HTTPs"
  
  allow {
    protocol  = "tcp"
    ports     = ["443"]
  }

  direction   = "INGRESS"
  priority = 1000
  source_ranges = flatten([var.vpc_internal_ip_ranges.primary,
                           var.vpc_internal_ip_ranges.secondary])
  target_tags = ["https-server"]
}

resource "google_compute_firewall" "ingress5000" {
  project     = local.project_id
  name        = "ingress5000"
  network     = google_compute_network.terraform-network-for-each.name
  description = "Open flask's default port for everyone"
  
  allow {
    protocol  = "tcp"
    ports     = ["5000"]
  }

  direction   = "INGRESS"
  priority = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ingress5000"]
}

resource "google_compute_firewall" "lbonly-ingress5000" {
  # Source range is only Load Balancer
  project     = local.project_id
  name        = "lbonly-ingress5000"
  network     = google_compute_network.terraform-network-for-each.name
  description = "Open flask's default port for Load Balancer IP only"
  
  allow {
    protocol  = "tcp"
    ports     = ["5000"]
  }

  direction   = "INGRESS"
  priority = 1000
  /* Need to allow healthcheck ip ranges https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
  as well as the proxy-only subnet access.
  No need to include the static IP of the load balancer as the termination on the client is terminated
  "${google_compute_address.load-balancer-static-ip.address}/32" */
  source_ranges = flatten([var.health_check_ip_ranges, google_compute_subnetwork.for-each-proxy-only-subnet.ip_cidr_range])
  target_tags = ["lbonly-ingress5000"]
}

resource "google_compute_firewall" "ingress8000" {
  project     = local.project_id
  name        = "ingress8000"
  network     = google_compute_network.terraform-network-for-each.name
  description = "Open django's default port"
  
  allow {
    protocol  = "tcp"
    ports     = ["8000"]
  }

  direction   = "INGRESS"
  priority = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ingress8000"]
}

resource "google_compute_firewall" "allow-ssh" {
  project     = local.project_id
  name        = "allow-ssh"
  network     = google_compute_network.terraform-network-for-each.name
  description = "Allow sshing into the machine"
  
  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }

  direction   = "INGRESS"
  priority = 1000
  # 35.235.240.0/20 --> Used for IAP
  source_ranges = ["35.235.240.0/20", "0.0.0.0/0"]
  target_tags = ["allow-ssh"]
}

resource "google_compute_firewall" "allow-icmp" {
  project     = local.project_id
  name        = "allow-icmp"
  network     = google_compute_network.terraform-network-for-each.name
  description = "Allow pinging the machines"
  
  allow {
    protocol  = "icmp"
  }

  direction   = "INGRESS"
  priority = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-icmp"]
}
