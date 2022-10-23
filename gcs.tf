resource "google_storage_bucket" "terraform-trial-europe-west1-1" {
  name          = "terraform-trial-europe-west1-1"
  location      = local.region
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
  labels = {
    created_by = "terraform"
  }
}

resource "google_storage_bucket" "terraform-trial-europe-west1-2" {
  name          = "terraform-trial-europe-west1-2"
  location      = local.region
  force_destroy = false
  storage_class = "COLDLINE"
  uniform_bucket_level_access = false
  labels = {
    created_by = "terraform"
  }
}