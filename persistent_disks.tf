resource "google_compute_disk" "boot-disk-vm" {
    name = "boot-disk-vm"
    type = local.default_disk_type
    zone = local.zone
    size = 50
    image = local.default_ubuntu_image
    labels = {
        created_by = "terraform"
    }
}

resource "google_compute_disk" "terraform-additional-persistent-disk" {
    name = "terraform-additional-persistent-disk"
    zone = local.zone
    type = local.default_disk_type
    size = local.default_disk_syze
    image = local.default_ubuntu_image
    labels = {
        created_by = "terraform"
    }
}