resource "google_compute_address" "terraform-static-ip"{
    name = "${terraform.workspace}-terraform-static-ip"
    address_type = "EXTERNAL"
    region = local.region
    network_tier = "STANDARD"
}

resource "google_compute_address" "load-balancer-static-ip"{
    name = "${terraform.workspace}-load-balancer-static-ip"
    address_type = "EXTERNAL"
    region = local.region
    network_tier = "STANDARD"
}

/*
resource "google_compute_global_address" "gcs-lb-static-ip"{
    name = "${terraform.workspace}-gcs-lb-static-ip"
    address_type = "EXTERNAL"
}
*/