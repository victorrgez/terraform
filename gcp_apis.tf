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