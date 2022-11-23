#This bucket needs to be created before running `terraform init`

terraform {
  # ~> means approximately greater than (the last digit can change)
  required_version = "~>1.3.3"
  backend "gcs" {
    bucket = "terraform-victorrgez1"
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
    local = {
      source = "hashicorp/local"
      version = "=2.2.3"
    }
  }

}

/*
If we need to access the contents of the state from a different terraform project,
we can do the following inside the other project:

data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "<BUCKET>"
    prefix = "<PREFIX>"
  }
}

Now we can access outputs from `data.terraform_remote_state.vpc.outputs.`
*/