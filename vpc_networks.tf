resource "google_compute_network" "terraform-network-with-subnets" {
  name = "terraform-network-with-subnets"
  description = "terraform-created vpc network with subnets in every region"
  routing_mode = "REGIONAL"
} 

resource "google_compute_network" "terraform-network-without-subnets" {
  name = "terraform-network-without-subnets"
  description = "terraform-created vpc network initialised without subnets"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false
  count = 0
}