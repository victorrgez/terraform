#This bucket needs to be created before running `terraform init`

terraform {

  backend "gcs" {
    bucket = locals.backend_bucket
    prefix = "terraform-trial1"

  }

}
