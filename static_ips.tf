resource "google_compute_address" "terraform-static-ip"{
    name = "terraform-static-ip"
    address_type = "EXTERNAL"
    region = locals.region
    network_tier = "STANDARD"
}