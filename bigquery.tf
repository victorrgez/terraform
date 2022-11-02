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
   deletion_protection = local.deletion_protection
   schema = file("data/bqschemas/${google_bigquery_dataset.mldataset.dataset_id}/iris.json")
   labels = {
    created_by = "terraform"
   }
}

resource "google_bigquery_table" "titanic" {
  dataset_id = google_bigquery_dataset.mldataset.dataset_id
  table_id   = "titanic"
  deletion_protection = local.deletion_protection
  schema = file("data/bqschemas/${google_bigquery_dataset.mldataset.dataset_id}/titanic.json")
  labels = {
    created_by = "terraform"
  }
}

/*
The objects loaded into BigQuery have been submitted to GCS from local on gcs.tf
Terraform is supposed to be used for providing infrastructure, not for dynamic loading data.
Nonetheless, this has been added for the sake of better understanding Terraform and can also
be understood as some basic resources that are provided to the development team
*/

resource "google_bigquery_job" "loadirisdata" {
  job_id = "loadirisdata"
  location = local.region
  depends_on = [google_storage_bucket_object.irisdata]

  load {
    source_uris = [
      "gs://${google_storage_bucket.terraform-trial-europe-west1-1.name}/iris.csv",
    ]

    destination_table {
      project_id = local.project_id
      dataset_id = google_bigquery_dataset.mldataset.dataset_id
      table_id   = google_bigquery_table.iris.table_id
    }

    skip_leading_rows = 1
    create_disposition = "CREATE_NEVER"
    write_disposition = "WRITE_APPEND"
    autodetect = true
    max_bad_records = 0
  }

  labels = {
    created_by ="terraform"
  }

}

resource "google_bigquery_job" "loadtitanicdata" {
  job_id = "loadtitanicdata2"
  location = local.region
  depends_on = [google_storage_bucket_object.titanicdata]
  load {
    source_uris = [
      "gs://${google_storage_bucket.terraform-trial-europe-west1-1.name}/titanic.csv",
    ]

    destination_table {
      project_id = local.project_id
      dataset_id = google_bigquery_dataset.mldataset.dataset_id
      table_id   = google_bigquery_table.titanic.table_id
    }

    skip_leading_rows = 1
    create_disposition = "CREATE_NEVER"
    write_disposition = "WRITE_APPEND"
    autodetect = true
    max_bad_records = 0

  }

  labels = {
    created_by ="terraform"
  }

}
