provider "google" {

  credentials = file("terraform-key.json")

  project = local.project_id
  region  = local.region
  zone    = local.zone
}