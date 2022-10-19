provider "google" {
  version = "3.5.0"

  credentials = file("terraform-key.json")

  project = "<PROJECT_ID>"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
} 