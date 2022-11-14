module "compute_engine" {
    source = "./compute_engine"
    default_vars = local.default_vars
    available_regions = var.available_regions
    vpc_internal_ip_ranges = var.vpc_internal_ip_ranges
    project_id = local.project_id
    region = local.region
    zone = local.zone
    deletion_protection = local.deletion_protection
    network = google_compute_network.terraform-network-for-each.name
    subnetwork = google_compute_subnetwork.for-each-subnets[local.region].name
    bucket_name = google_storage_bucket.terraform-trial-europe-west1-1.name

    /*
    "We don't care about the value of the following variables,
    but we need these resources to be created.
    Used to propagate dependencies between parent and child modules"
    */

    proxy_only_subnet = google_compute_subnetwork.for-each-proxy-only-subnet.creation_timestamp
    docker_repository = google_artifact_registry_repository.docker-repository.create_time
}