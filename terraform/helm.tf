
data "google_client_config" "client" {}

data "google_container_cluster" "credentials" {
  name     = google_container_cluster.zenotta-mining-cluster.name
  location = var.location
  project  = var.projectId
}

provider "helm" {

  experiments {
    manifest = true
  }

  kubernetes {
    host                   = data.google_container_cluster.credentials.endpoint
    token                  = data.google_client_config.client.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.zenotta-mining-cluster.master_auth.0.cluster_ca_certificate)
  }
}

resource "helm_release" "nvidia-drivers" {
  name  = "nvidia-driver"
  chart = "./helm/nvidia-chart"
}
