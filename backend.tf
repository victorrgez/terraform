#This bucket needs to be created before running `terraform init`

terraform {

  backend "gcs" {
    bucket = "terraform-victorrgez1"
    prefix = "terraform-trial1"

  }

}
