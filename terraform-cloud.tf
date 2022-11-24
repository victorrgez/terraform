/*

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