resource "google_project_service" "cloudresourcemanager-api" {
  service = "cloudresourcemanager.googleapis.com"
  /*
  Needed for reading metadata about resources
  */
  timeouts {
    create = "1m"
    update = "1m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
}

resource "google_project_service" "serviceusage-api" {
  service = "serviceusage.googleapis.com"
  /*
  Needed for being able to check which APIs are enabled. It depends on itself,
  so we need to activate it manually as, otherwise, it will not be activated by
  terraform.
  APIs do not fail if they already exist unlike other types of resources
  */
  timeouts {
    create = "1m"
    update = "1m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
  depends_on = [google_project_service.cloudresourcemanager-api]
}

resource "google_project_service" "iam-api" {
  service = "iam.googleapis.com"
  # Needed for being able to create Service Accounts
  timeouts {
    create = "1m"
    update = "1m"
  }
  disable_on_destroy = true
  disable_dependent_services = true
  depends_on = [google_project_service.cloudresourcemanager-api, google_project_service.serviceusage-api]
}