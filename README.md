# Terraform
Learning Terraform with A Cloud Guru sandboxes in GCP

To Do:

- [ ] How to create/choose workspace
- [ ] What is exactly terraform module
- [ ] Difference between variables and locals --> Variables cannot use functions. Variables global-scoped. Locals only within module.
- [ ] Created BigQuery Dataset/Tables
- [ ] Do we need to enable manually cloud resource manager?
- [ ] We cannot give roles to the SA we just created right?

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