#This bucket needs to be created before running `terraform init`

terraform {
  # ~> means approximately greater than (the last digit can change)
  required_version = "~>1.3.3"
  backend "gcs" {
    bucket = "terraform-victorrgez"
    prefix = "terraform-trial1"

  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "=4.43.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "=4.43.0"
    }
  }

}
