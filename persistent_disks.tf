resource "google_compute_disk" "terraform-additional-persistent-disk" {
    name = "terraform-additional-persistent-disk"
    zone = "europe-west1-b"
    type = "pd-standard"
    size = "100"
    image = "ubuntu-1804-bionic-v20221018"
    labels = {
        created_by = "terraform"
    }
}