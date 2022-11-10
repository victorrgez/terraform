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
  for_each       = toset(local.allowed_regions)
  /*
  `each.value` is each of the names (regions) inside our variable
  how to get index for each region? ---> index(local.allowed_regions, each.value)
  we need this index to iterate through another list variable
  */
  name          = "subnet-for-each-${each.value}"
  ip_cidr_range = var.vpc_internal_ip_ranges.primary[index(local.allowed_regions, each.value)]
  region        = each.value
  network       = google_compute_network.terraform-network-for-each.id
  secondary_ip_range {
    range_name    = "secondary-range-for-each${each.value}"
    ip_cidr_range = var.vpc_internal_ip_ranges.secondary[index(local.allowed_regions, each.value)]
  }
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "for-each-proxy-only-subnet"{
  # 
  name          = "for-each-proxy-only-subnet"
  description   = "Used by Load Balancers https://cloud.google.com/load-balancing/docs/proxy-only-subnets"
  ip_cidr_range = "10.10.0.0/16"
  region        = local.region
  network       = google_compute_network.terraform-network-for-each.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

/*
resource "google_compute_network" "terraform-network-array-lookup" {
  name = "terraform-network-array-lookup"
  description = "terraform-created vpc network with subnets created with array lookup"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "array-lookup-subnets"{
  count = length(local.allowed_regions)
  
  # count = length(variable) will create behind the scenes a for loop
  # `count.index` --> will give us the index for iterating both over our variable
  # and also over a different list variable
  

  name          = "subnet-lookup-${local.allowed_regions[count.index]}"
  ip_cidr_range = var.vpc_internal_ip_ranges.primary[count.index]
  region        = local.allowed_regions[count.index]
  network       = google_compute_network.terraform-network-array-lookup.id
  secondary_ip_range {
    range_name    = "secondary-range-lookup-${local.allowed_regions[count.index]}"
    ip_cidr_range = var.vpc_internal_ip_ranges.secondary[count.index]
  }
  private_ip_google_access = true
}
*/