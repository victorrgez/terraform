resource "google_project_service" "iam-api" {
  service = "iam.googleapis.com"
  # Needed for being able to create Service Accounts
  timeouts {
    create = "1m"
    update = "1m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
}

resource "google_project_service" "artifact-registry-api" {
  service = "artifactregistry.googleapis.com"
  # Needed for being able to store Docker images
  timeouts {
    create = "1m"
    update = "1m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
}

/*
resource "google_project_service" "cloud-build-api" {
  service = "cloudbuild.googleapis.com"
  # Needed for automating CICD by reacting to changes in Cloud Repositories
  timeouts {
    create = "1m"
    update = "1m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
}
*/

/*
resource "google_project_service" "cloud-run-api" {
  # Needed for deploying Cloud Run services
  service = "run.googleapis.com"
  timeouts {
    create = "1m"
    update = "1m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
}
*/