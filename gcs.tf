/*
This bucket needs to be created before running `terraform init`
Remember to import it before you run `terraform plan`
with `terraform import google_storage_bucket.terraform-backend-victorrgez terraform-backend-victorrgez`
*/

resource "google_storage_bucket" "terraform-backend-victorrgez" {
  name          = "terraform-backend-victorrgez"
  location      = "europe-west1"
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
  labels = {
    created_by = "terraform"
  }
}