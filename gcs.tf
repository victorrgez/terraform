resource "google_storage_bucket" "terraform-trial-europe-west-1" {
  name          = "terraform-trial-europe-west-1"
  location      = "europe-west1"
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
  labels = {
    created_by = "terraform"
  }
}

resource "google_storage_bucket" "terraform-trial-europe-west-2" {
  name          = "terraform-trial-europe-west-2"
  location      = "europe-west1"
  force_destroy = false
  storage_class = "COLDLINE"
  uniform_bucket_level_access = false
  labels = {
    created_by = "terraform"
  }
}