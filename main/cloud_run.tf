/*
Cannot set public access through Terraform since I do not have permissions for setting
IAM policies in the A Cloud Guru Playgrounds. It would be done this way:

resource "google_cloud_run_service" "calculator" {
  name     = "cloudrun-calculator"
  location = local.region

  template {
    metadata {
        labels = {
            created_by = "terraform"
        }
    }
    spec {
      containers {
        image = local.docker_image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.cloud-run-api]
}

resource "google_cloud_run_service_iam_binding" "cloud-run-public-access" {
  location = local.region
  service  = google_cloud_run_service.calculator.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}
*/

/*
If we were to use the public Module
(remember to check source code for providers'versions' requirements!):

module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.2.0"

  # Required variables
  service_name           = "hello-app"
  project_id             = local.project_id
  location               = local.region
  image                  = "local.docker_image"
}

output "service-url" {
    value = module.cloud_run.service_url
}
*/