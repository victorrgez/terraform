# Terraform
Learning Terraform with A Cloud Guru sandboxes in GCP. Some limitations apply since we do not have full admin access inside the project.
For instance, we cannot provide roles to Service Accounts. Those blocks were tested with `terraform validate` and then commented out.


To Do:
- [ ] Add Proxy only subnet
- [ ] Comment migs_and_loadbalancers.tf
- [ ] Understand more in depth all the component of migs_and_loadbalancers. Url map, proxy, etc..
- [ ] Firewall on Mig allow only from LB
- [ ] Deploy image on CloudRun
- [ ] Create LoadBalancer for GCS
- [ ] How to create/choose workspace
- [ ] What is exactly terraform module
- [ ] Difference between variables and locals --> Variables cannot use functions. Variables global-scoped. Locals only within module.
- [ ] Data sources

Done:

- [X] Enable APIs
- [X] Create VM
- [X] Created GCS buckets
- [X] Add shared Terraform state in GCS
- [X] Create Service Account
- [X] See more options for outputs.tf
- [X] Create firewall rules to allow HTTP, 5000, 8000, etc
- [X] Start-up script
- [X] Move boot disk from VM to persistent_disks.tf
- [X] What happens when two merge two map(string) variables with the same name in both?
- [X] Create subnets as a script
- [X] How to use loops
- [X] How to use conditionals
- [X] Use variable as list (for example subnet ips) and decide which one you want to assign
- [X] Create BigQuery Dataset/Tables
- [X] Import CSV data into GCS with Terraform
- [X] Create load jobs to BigQuery and make sure they don't repeat each time
- [X] Copy image from Dockerhub to Container Registry inside start-up script
- [X] Check how to fix startup script to run Docker image
- [X] Create VM with container-optimised OS
- [X] Create instance template and Managed Instance Group (group manager, autoscaler)
- [X] Set up HTTP Load Balancer and backend service
- [X] Add Frontend to Load Balancer?

- [X] ....

Limitations of the A Cloud Guru Playground and Terraform:

- We need to manually activate Service Usage and Cloud Resource Manager APIs as Terraform will have unexpected behaviour with them otherwise,
since they both need to be active for Terraform to know if they are active or not.

- It can take some time for Artifact Registry API to be initialised before the image can be pushed. Therefore, the initialization script of `google_compute_instance.terraform-vm` may fail.

- There is currently not a straightforward way of running VMs optimised for containers with Terraform as it can be done on UI, gcloud, etc (https://cloud.google.com/compute/docs/containers/deploying-containers). Therefore, we have created our own initialization script.