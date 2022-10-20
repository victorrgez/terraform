terraform {
  backend "gcs" {
    bucket = "terraform-backend-victorrgez"
    prefix = "terraform1"
  }
}
