/*

The aim is to be able to create a custom role from a txt file that has blank line-separated
permissions and whose file name is the name of the role to be created

If we do a wget with the role's file's link, we will avoid having an extra blank line at the end
that could be parsed as an empty role name

resource "google_project_service" "iam" {
  project = local.project_id
  service = "iam.googleapis.com"

  timeouts {
    create = "1m"
    update = "1m"
  }
}

# Creating role for a single file:

resource "google_project_iam_custom_role" "compute-audit" {
  role_id     = "computeAudit"
  title       = "Compute Auditor"
  description = "https://github.com/linuxacademy/content-advanced-terraform-with-gcp/blob/main/filesystem_lab/compute_audit.txt"
  permissions = split("\n",file("compute_audit.txt"))
  depends_on = [google_project_service.iam]
}

# Creating role for all txt files in the directory:

resource "google_project_iam_custom_role" "custom-roles" {
  for_each = fileset(path.module, "*.txt")
  role_id     = trimsuffix(each.value, ".txt")
  title       = replace(trimsuffix(each.value, ".txt"), "_", " ")
  description = "https://github.com/linuxacademy/content-advanced-terraform-with-gcp/blob/main/filesystem_lab/"
  permissions = split("\n",file(each.value))
  depends_on = [google_project_service.iam]
}

*/