/*
Creation of two VPC networks whose VPC subnets are created
with two loops strategies
*/

resource "google_compute_network" "terraform-network-for-each" {
  name = "terraform-network-foreach"
  description = "terraform-created vpc network with subnets created with for-each loop"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "for-each-subnets"{
  for_each       = toset(var.allowed_regions)
  /*
  `each.value` is each of the names (regions) inside our variable
  how to get index for each region? ---> index(var.allowed_regions, each.value)
  we need this index to iterate through another list variable
  */
  name          = "subnet-for-each-${each.value}"
  ip_cidr_range = var.vpc_internal_ip_ranges.primary[index(var.allowed_regions, each.value)]
  region        = each.value
  network       = google_compute_network.terraform-network-for-each.id
  secondary_ip_range {
    range_name    = "secondary-range-for-each${each.value}"
    ip_cidr_range = var.vpc_internal_ip_ranges.secondary[index(var.allowed_regions, each.value)]
  }
  private_ip_google_access = true
}



resource "google_compute_network" "terraform-network-array-lookup" {
  name = "terraform-network-array-lookup"
  description = "terraform-created vpc network with subnets created with array lookup"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "array-lookup-subnets"{
  count = length(var.allowed_regions)
  /*
  count = length(variable) will create behind the scenes a for loop
  `count.index` --> will give us the index for iterating both over our variable
  and also over a different list variable
  */

  name          = "subnet-lookup-${var.allowed_regions[count.index]}"
  ip_cidr_range = var.vpc_internal_ip_ranges.primary[count.index]
  region        = var.allowed_regions[count.index]
  network       = google_compute_network.terraform-network-array-lookup.id
  secondary_ip_range {
    range_name    = "secondary-range-lookup-${var.allowed_regions[count.index]}"
    ip_cidr_range = var.vpc_internal_ip_ranges.secondary[count.index]
  }
  private_ip_google_access = true
}
