/*
Cannot set public access through Terraform since I do not have permissions for setting
IAM policies in the Playgrounds. It would be done this way:

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