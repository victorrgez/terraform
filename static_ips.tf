resource "google_compute_address" "terraform-static-ip"{
    name = "terraform-static-ip"
    address_type = "EXTERNAL"
    region = local.region
    network_tier = "STANDARD"
}

resource "google_compute_address" "load-balancer-static-ip"{
    name = "load-balancer-static-ip"
    address_type = "EXTERNAL"
    region = local.region
    network_tier = "STANDARD"
}
