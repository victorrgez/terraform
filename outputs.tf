output "allowed_regions" {
    value = var.allowed_regions
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

output "vm_name" {
    value = google_compute_instance.terraform-vm.name
}

output "vpc_in_use" {
    value = google_compute_network.terraform-network-with-subnets.name
}

output "workspace" {
    value = terraform.workspace
}

output "zone" {
    value = local.zone
    description = "all resources will be created in this zone"
}