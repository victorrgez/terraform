resource "google_compute_network" "terraform-network-with-subnets" {
  name = "terraform-network-with-subnets"
  description = "terraform-created vpc network with subnets in every region"
  routing_mode = "REGIONAL"
} 

resource "google_compute_network" "terraform-network-without-subnets" {
  name = "terraform-network-without-subnets"
  description = "terraform-created vpc network initialised without subnets"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "for-each-subnets"{
  for_each       = toset(var.allowed_regions)
  # how to get index for each region? ---> index(var.allowed_regions, each.value)
  # we need this index to iterate through another list variable

  name          = "subnet-${each.value}"
  ip_cidr_range = var.vpc_internal_ip_ranges.primary[index(var.allowed_regions, each.value)]
  region        = each.value
  network       = google_compute_network.terraform-network-without-subnets.id
  secondary_ip_range {
    range_name    = "secondary-range-${each.value}"
    ip_cidr_range = var.vpc_internal_ip_ranges.secondary[index(var.allowed_regions, each.value)]
  }
  private_ip_google_access = true
}
