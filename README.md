# Terraform
Learning Terraform with A Cloud Guru sandboxes in GCP. Some limitations apply since we do not have full admin access inside the project.
For instance, we cannot provide roles to Service Accounts. Those blocks were tested with `terraform validate` and then commented out.


- [X] Difference between variables and locals --> Variables cannot use functions and can be overriden on the command line (if not, they will
keep their default value). Locals are like drafts for building up complex variables as a result (their source can be the variables)
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
- [X] Use variable of type list (for example subnet ips) and decide which one you want to assign
- [X] Create BigQuery Dataset/Tables
- [X] Import CSV data into GCS with Terraform
- [X] Create load jobs to BigQuery and make sure they don't repeat each time we run terraform apply
- [X] Copy image from Dockerhub to Container Registry inside start-up script of a VM
- [X] Check how to fix startup script to run Docker image
- [X] Create VM with container-optimised OS
- [X] Create instance template and Managed Instance Group (group manager, autoscaler)
- [X] Set up HTTP Load Balancer and backend service
- [X] Add Frontend to Load Balancer (Forwarding rule)
- [X] Add proxy-only subnet
- [X] Firewall config on MIG so that access is only allowwed through LB
- [X] Create LoadBalancer for GCS
- [X] Deploy image on CloudRun
- [X] Make GCS bucket public for LB to work --> Don't have enough permissions on Playground but know how to do it
- [X] Understand more in depth all the component of migs_and_loadbalancers. Url map, proxy, etc..
- [X] How to create/choose workspace
- [X] Add terraform workspace variable in the name of the resources
- [X] Define custom module and instantiate it in main.tf
- [X] Create a Data source in child module that outputs its content to root module which outputs its value to terminal
- [X] Learn how to pass different variables when running terraform on command line to dynamically specifiy some contraints on the infrastructure to be created (also need to remove the `default_vars` merging with Local variables for this specification to have an effect):

```tf apply -var default_vars='{"default_disk_type":"pd-ssd", "default_disk_size":79, "default_machine_type":"f1-micro"}' -var myvar="itworked"```

- [X] What is a workspace --> Isolated set of resources. Each of them is a duplication of the whole project with different lifecycle. Same codebase is used for all workspaces. Variables + Data Sources + Resources + Outputs
- [X] What is a Terraform module --> Like a Class in OoP. Bundle of resources with a series of settings that will not change and others that you can still tune them a bit. They only expose their outputs to their root module.
- [X] Add template file that outputs the IPs of the MIG's instances to a local file
- [X] Understand (Terraform Workspaces vs Terraform Modules vs Branches) in (Development vs Production) scenario
- [X] Create GKE cluster module
- [X] Deploy pod to GKE as a deployment
- [X] Create a service for the deployment
- [X] Understand a bit about Hashicorp Stack (there are specific providers for each of them in most cases) -->
    - HashiCorp Cloud Platform (managed Harshicorp services)
    - Terraform Cloud (remote state backend, workflow approval, costs estimation and downstream triggers)
    - Vault (Secret Management, Secret Engines (one-time tokens like Oauth), etc)
    - Consul (service discovery, centralised configuration as source of truth for services, service-base access control, remote state backend)
    - Nomad (application orchestration platform, even some cannot be containerised)
    - Packer (Image Management, available as data source)
    - Sentinel (org policies) 
- [X] ....

Limitations of the A Cloud Guru Playground and Terraform:

- Cannot give IAM permissions. This prevents us, for example, from creating a publicly accessible Load Balancer on GCS or a public Cloud Run service

- We need to manually activate Service Usage and Cloud Resource Manager APIs as Terraform will have unexpected behaviour with them otherwise,
since they both need to be active for Terraform to know if they are active or not.

- It can take some time for Artifact Registry API to be initialised before the image can be pushed. Therefore, the initialization script of `google_compute_instance.terraform-vm` may fail.

- There is currently not a straightforward way of running VMs optimised for containers with Terraform like it can be done on UI, gcloud, etc (https://cloud.google.com/compute/docs/containers/deploying-containers). Therefore, we have created our own initialization script.

- Cannot create a temporary Domain in order to associate it with the Load Balancer

- Cannot use Cloud Source Repositories to trigger Cloud Build

- A lot of code has been commented out in order not to reach any internal limit of resources in the Playground once we had checked that the code was working correctly.
