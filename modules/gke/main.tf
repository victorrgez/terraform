resource "google_container_cluster" "gke-cluster" {
  name     = "${terraform.workspace}-${var.cluster-name}"
  location = var.zone
  network = var.network
  subnetwork = var.subnetwork

  /*
  We can't create a cluster with no node pool defined, but we want to only use
  separately managed node pools since Terraform does not interact correctly
  with deafult node pool (we don't want to recreate cluster when we change
  something in the node pools).
  So we create the smallest possible default
  node pool and immediately delete it:
  */

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${terraform.workspace}-${var.cluster-name}-nodepool"
  location   = var.zone
  cluster    = google_container_cluster.gke-cluster.name
  node_count = var.node-count

  node_config {
    preemptible  = true
    machine_type = var.machine-type
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      created_by = "terraform"
    }
  }
}