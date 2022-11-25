/*

Standard workflow:
`Access Vault --> Terraform Plan --> Sentinel check --> Terraform apply`

*/

/*

Terraform Cloud:

Steps:

1 - Create a Terraform Account for free and create an organization

2 - In your CLI, run `terraform login` to get an API token

3 - Add terraform block with information about organization and workspace:

terraform {
  cloud {
    organization = "<organizationName>"

    workspaces {
      name = "<workspaceName>"
    }
  }
}

4 - Set up the service account credentials in Terraform Cloud as an environment variable (`GOOGLE_CREDENTIALS`)

5 - `terraform init` followed by `terraform apply`.
    Apply runs directly on Terraform Cloud (remote state with other powerful capabilities)

6 - Continue working with Terraform as you would do normally.
    Logs are streamed into your CLI and approve can be executed from your CLI as well (we can also approve in Terraform Cloud).
    `tf validate` can be run on CLI without needing to send config to Terraform Cloud

Note:  There is not any issue with having two Terraform blocks in your configuration (once for cloud and another one for providers)

*/

/*

SENTINEL (Policy as Code) is used for org policies. It is code that defines restrictions around
Infrastructure as Code (example copied from ACG course):

# This policy uses the Sentinel tfplan/v2 import to require that
# all GCE instances have machine types from an allowed list

# Import common-functions/tfplan-functions/tfplan-functions.sentinel
# with alias "plan"
import "tfplan-functions" as plan

# Allowed GCE Instance Types
# Include "null" to allow missing or computed values
allowed_types = ["n1-standard-1", "n1-standard-2", "n1-standard-4"]

# Get all GCE instances
allGCEInstances = plan.find_resources("google_compute_instance")

# Filter to GCE instances with violations
# Warnings will be printed for all violations since the last parameter is true
violatingGCEInstances = plan.filter_attribute_not_in_list(allGCEInstances,
                        "machine_type", allowed_types, true)

# Count violations
violations = length(violatingGCEInstances["messages"])

# Main rule
main = rule {
  violations is 0
}
*/