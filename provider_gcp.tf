provider "google" {  # For most features (equivalent to `gcloud` command)

  credentials = file("terraform-key.json")

  project = local.project_id
  region  = local.region
  zone    = local.zone
}

provider "google-beta" {  # For beta features (equivalent to `gcloud beta` command)

  credentials = file("terraform-key.json")

  project = local.project_id
  region  = local.region
  zone    = local.zone
}