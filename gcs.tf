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

/*
Upload local data to GCS so that it can be imported with a Load Job in bigquery.tf
*/

resource "google_storage_bucket_object" "irisdata" {
  name   = "iris.csv"
  source = "bqdata/iris.csv"
  bucket = google_storage_bucket.terraform-trial-europe-west1-1.name
}

resource "google_storage_bucket_object" "titanicdata" {
  name   = "titanic.csv"
  source = "bqdata/titanic.csv"
  bucket = google_storage_bucket.terraform-trial-europe-west1-1.name
}