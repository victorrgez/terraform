resource "google_artifact_registry_repository" "docker-repository" {
  location      = local.region
  repository_id = "docker-repository"
  description   = "Hosting Dockerhub images"
  format        = "DOCKER"
  depends_on = [google_project_service.artifact-registry-api]
}
