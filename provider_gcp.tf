provider "google" {

  credentials = file("terraform-key.json")

  project = locals.project_id
  region  = locals.region
  zone    = locals.zone
}