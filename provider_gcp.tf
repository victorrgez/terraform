provider "google" {

  credentials = file("terraform-key.json")

  project = "<PROJECT_ID>"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}