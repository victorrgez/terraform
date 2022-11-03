#This bucket needs to be created before running `terraform init`

terraform {

  backend "gcs" {
    bucket = "terraform-victorrgez11"
    prefix = "terraform-trial1"

  }

}
