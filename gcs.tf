resource google_storage_bucket "terraform-trial-europe-west1-1" {
  name          = "terraform-trial-europe-west1-1"
  location      = local.region
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
  labels = {
    created_by = "terraform"
  }
}
/*
This way we can give access through the Load Balancer to the bucket (public access is needed)
However, we cannot do this in the playground as we cannot set policies. If ever using this code,
we should probably change from google_iam_policy to google_project_iam_binding in order not to override
existing permissions


data google_iam_policy "public-view-gcs" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
  binding {
    role = "roles/storage.objectAdmin"
    members = [
      "serviceAccount:18260941960-compute@developer.gserviceaccount.com",
    ]
  }
}

resource google_storage_bucket_iam_policy "gcs-policy" {
  bucket = google_storage_bucket.terraform-trial-europe-west1-1.name
  policy_data = data.google_iam_policy.public-view-gcs.policy_data
}
*/
resource google_storage_bucket "terraform-trial-europe-west1-2" {
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

resource google_storage_bucket_object "irisdata" {
  name   = "iris.csv"
  source = "data/bqdata/iris.csv"
  bucket = google_storage_bucket.terraform-trial-europe-west1-1.name
}

resource google_storage_bucket_object "titanicdata" {
  name   = "titanic.csv"
  source = "data/bqdata/titanic.csv"
  bucket = google_storage_bucket.terraform-trial-europe-west1-1.name
}