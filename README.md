# Terraform
Learning Terraform with A Cloud Guru sandboxes in GCP. Some limitations apply since we do not have full admin access inside the project.
For instance, we cannot provide roles to Service Accounts. Those blocks were tested with `terraform validate` and then commented out.

We need to manually activate Service Usage and Cloud Resource Manager APIs as Terraform will have unexpected behaviour with them otherwise,
since they both need to be active for Terraform to know if they are active or not.

To Do:

- [ ] How to create/choose workspace
- [ ] What is exactly terraform module
- [ ] Difference between variables and locals --> Variables cannot use functions. Variables global-scoped. Locals only within module.
- [ ] Created BigQuery Dataset/Tables

Done:
- [X] Enable APIs
- [X] Create Service Account
- [X] See more options for outputs.tf
- [X] Create firewall rules to allow HTTP, 5000, 8000, etc
- [X] Move boot disk from VM to persistent_disks.tf
- [X] What happens when two merge two map(string) variables with the same name in both?
- [X] Create subnets manually
- [X] How to use loops
- [X] How to use conditionals
- [X] Use variable as list (for example subnet ips) and decide which one you want to assign
- [X] ....