resource "google_compute_disk" "boot-disk-vm" {
    name = "${terraform.workspace}-boot-disk-vm"
    type = local.default_vars.default_disk_type
    zone = local.zone
    size = 50
    image = local.default_vars.default_ubuntu_image
    labels = {
        created_by = "terraform"
    }
}

resource "google_compute_disk" "terraform-additional-persistent-disk" {
    name = "${terraform.workspace}-terraform-additional-persistent-disk"
    zone = local.zone
    type = local.default_vars.default_disk_type
    size = local.default_vars.default_disk_size
    image = local.default_vars.default_ubuntu_image
    labels = {
        created_by = "terraform"
    }
}
