resource "google_compute_address" "terraform-static-ip"{
    name = "terraform-static-ip"
    address_type = "EXTERNAL"
    region = "europe-west1"
    network_tier = "STANDARD"
}