resource google_service_account "terraform-sa" {
    account_id = "terraform-sa"
    display_name = "Terraform SA"
    description = <<EOF
    Terraform-created Service Account. Does not have any roles assigned
    since the Playground environment does not let us grant additional permissions
    EOF
    depends_on = [google_project_service.iam-api]
}