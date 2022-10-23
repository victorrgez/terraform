resource "google_compute_disk" "terraform-additional-persistent-disk" {
    name = "terraform-additional-persistent-disk"
    zone = locals.zone
    type = locals.default_disk_type
    size = locals.default_disk_syze
    image = "ubuntu-1804-bionic-v20221018"
    labels = {
        created_by = "terraform"
    }
}