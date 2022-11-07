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

resource "google_compute_global_address" "gcs-lb-static-ip"{
    name = "gcs-lb-static-ip"
    address_type = "EXTERNAL"
}
