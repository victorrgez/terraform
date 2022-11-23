variable "cluster_name" {
}

variable "endpoint"{
}

variable "ca_cert" {
}

variable "location" {
    default = "europe-west1-b"
}

variable "pod_name" {
    default = "artifact-registry-pod"
}

variable "image" {
}

data "google_client_config" "gcp_provider_config" {
    # Used for accessing the GCP provider's configuration
}

provider "kubernetes" {
  host = "https://${var.endpoint}"
  token = data.google_client_config.gcp_provider_config.access_token
  cluster_ca_certificate = base64decode(var.ca_cert)
}

resource "kubernetes_deployment_v1" "calculator-app" {
  metadata {
    name = "calculator-app"
    labels = {
      created_by = "terraform"
      image_type = "calculator"
    }
  }

  spec {
    /*
    It does not make sense to create a deployment so small but this is a Proof of Concept
    and there are not enough CPUs in such a small cluster
    */
    replicas = 1  

    selector {
      match_labels = {
        image_type = "calculator"
      }
    }

    # Pod configuration down below (similar to https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod)
    template {
      metadata {
        labels = {
          image_type = "calculator"
        }
      }

      spec {
        container {
          image = var.image
          name  = var.pod_name

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 5000
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "calculator-service" {
  metadata {
    name = "calculator-service"
  }
  spec {
    selector = {
      image_type = kubernetes_deployment_v1.calculator-app.metadata.0.labels.image_type
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}