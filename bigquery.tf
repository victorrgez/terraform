resource "google_bigquery_dataset" "mldataset" {
  dataset_id                  = "mldataset"
  description                 = "Contains some classic datasets commonly used for basic Machine Learning"
  location                    = local.region
  labels = {
    created_by = "terraform"
  }
}

resource "google_bigquery_table" "iris"{
   dataset_id = google_bigquery_dataset.mldataset.dataset_id
   table_id = "iris"
   deletion_protection = true
   schema = file("bqschemas/${google_bigquery_dataset.mldataset.dataset_id}/iris.json")
   labels = {
    created_by = "terraform"
   }
}

resource "google_bigquery_table" "titanic" {
  dataset_id = google_bigquery_dataset.mldataset.dataset_id
  table_id   = "titanic"
  deletion_protection = true
  schema = file("bqschemas/${google_bigquery_dataset.mldataset.dataset_id}/titanic.json")
  labels = {
    created_by = "terraform"
  }
}

