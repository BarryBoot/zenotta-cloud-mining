data "google_client_config" "client" {}

data "google_container_cluster" "credentials" {
  name       = google_container_cluster.zenotta-mining-cluster.name
  location   = var.location
  project    = var.projectId
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

provider "helm" {
  alias = "zenotta-cluster"
  # experiments {
  #   manifest = true
  # }
  kubernetes {
    host                   = data.google_container_cluster.credentials.endpoint
    token                  = data.google_client_config.client.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.zenotta-mining-cluster.master_auth.0.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gcloud"
      args        = ["container", "get-credentials", google_container_cluster.zenotta-mining-cluster.name, "--region", var.region, "--project", var.projectId]
    }
  }
}
# gcloud container clusters get-credentials zenotta-mining-cluster --region us-central1 --project zenotta-mining-387514

resource "helm_release" "nvidia-drivers-release" {
  provider   = helm.zenotta-cluster
  name       = "nvidia-drivers-release"
  chart      = "./helm/nvidia-chart"
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

resource "helm_release" "zenotta-miner-release" {
  provider   = helm.zenotta-cluster
  name       = "zenotta-miner-release"
  chart      = "./helm/miner-chart"
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}
