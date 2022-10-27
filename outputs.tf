output "allowed_regions" {
    value = local.allowed_regions
}

output "attached_disk" {
    value = google_compute_disk.terraform-additional-persistent-disk.name
}

output "bucket" {
    value = google_storage_bucket.terraform-trial-europe-west1-1.name
    description = "STANDARD bucket. No costs for accessing objects"
}

output "extra_bucket" {
    value = google_storage_bucket.terraform-trial-europe-west1-2.name
    description = "COLDLINE bucket. Lower costs for storing objects"
}

output "ip" {
    value = google_compute_address.terraform-static-ip.address
}

output "project_id" {
    value = local.project_id
    description = "the project_id will vary in each sandbox"
}

output "region" {
    value = local.region
    description = "all resources will be created in this region"
}

output "vm_with_protection_enabled" {
    value = google_compute_instance.terraform-vm.name
    /* We need to manually delete this precondition before being able to disable
    the deletion_protection */
    precondition {
        condition = google_compute_instance.terraform-vm.deletion_protection
        error_message = "The VM is unprotected"
    }
}

output "workspace" {
    value = terraform.workspace
}

output "zone" {
    value = local.zone
    description = "all resources will be created in this zone"
}