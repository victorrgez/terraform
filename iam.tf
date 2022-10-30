resource google_service_account "terraform-sa" {
    account_id = "terraform-sa"
    display_name = "Terraform SA"
    description = <<EOF
    Terraform-created Service Account. Does not have any roles assigned
    since the Playground environment does not let us grant additional permissions
    EOF
    depends_on = [google_project_service.iam-api]
}

/*
google_project_iam_policy --> Updates all the roles granted in the project at once. Dangerous to use as you may end up not being able to access the project
google_project_iam_binding --> Gives a specific rol to a list of members
google_project_iam_member --> Gives a specific rol to a specific member
*/

/* We do not have access to provide IAM roles on the playground, but we would do the following in a real case scenario:

resource "google_project_iam_binding" "iam-bigquery-job-user" {
  project = local.project_id
  role    = "roles/bigquery.jobUser"

  members = [
    "serviceAccount:${google_service_account.terraform-sa.account_id}@${local.project_id}.iam.gserviceaccount.com",
  ]

  condition {
    expression = "request.time.getHours('Europe/Madrid') >= 8 && request.time.getHours('Europe/Madrid') <= 19"
    title = "BigQuery Job User during working hours"
    description = "Gives BigQuery user rol to Terraform SA during working hours"
  }
}
*/