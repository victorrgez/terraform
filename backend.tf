#This bucket needs to be created before running `terraform init`

terraform {
  backend "gcs" {
    bucket = "terraform-victorrgez"
    prefix = "terraform-trial1"
  }
}
