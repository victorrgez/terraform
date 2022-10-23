output "attached_disk"{
    value = google_compute_disk.terraform-additional-persistent-disk.name
}

output "backend_bucket" {
    value = locals.backend_bucket # Resource not created by Terraform
}

output "bucket" {
    value = google_storage_bucket.terraform-trial-europe-west-1.name
}

output "extra_bucket"{
    value = google_storage_bucket.terraform-trial-europe-west-2.name
}

output "ip" {
    value = google_compute_address.terraform-static-ip.address
}

output "project_id" {
    value = locals.project_id
}

output "region" {
    value = locals.region
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
    value = locals.zone
}