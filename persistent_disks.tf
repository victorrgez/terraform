resource "google_compute_disk" "terraform-additional-persistent-disk" {
    name = "terraform-additional-persistent-disk"
    zone = local.zone
    type = local.default_disk_type
    size = local.default_disk_syze
    image = "ubuntu-1804-bionic-v20221018"
    labels = {
        created_by = "terraform"
    }
}