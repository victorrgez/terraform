/*
Uploads a local file to GCS and reads its content.
Afterwards, it displays the content of the file and
outputs it to the root module.
*/

resource google_storage_bucket_object "data-source" {
  name   = "data_source.txt"
  source = "data/data_source.txt"
  bucket = var.bucket_name
}

data "google_storage_bucket_object_content" "data-source" {
  name   = "data_source.txt"
  bucket = var.bucket_name
  depends_on = [google_storage_bucket_object.data-source]
}

data "google_compute_instance_group" "mig-calculator" {
    name = google_compute_instance_group_manager.mig-calculator.name
    zone = var.zone
}

data "google_compute_instance" "mig-calculator-instances" {
    for_each = toset(data.google_compute_instance_group.mig-calculator.instances)
    self_link = each.value
    zone = var.zone
}

/*
output "mig-ips" {
  value = {for i in data.google_compute_instance.mig-calculator-instances:  i.name => i.network_interface[0].access_config[0].nat_ip}
}

output "vm-ip" {
  value = {"${google_compute_instance.terraform-vm.name}" = "${google_compute_instance.terraform-vm.network_interface[0].access_config[0].nat_ip}"}
}
*/

output "data-source" {
  value = data.google_storage_bucket_object_content.data-source.content
}

/*
If we had a terraform-vm resource with count >1, we can output a list of the values for all instances in this way:

output "ips" {  # As a List
    value = [for i in google_compute_instance.terraform-vm : i.network_interface[0].access_config[0].nat_ip]
}

output "ips" {  # As a Map
    value = {for i in google_compute_instance.terraform-vm : i.name => i.network_interface[0].access_config[0].nat_ip}
}

*/