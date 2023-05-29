data "google_client_config" "client" {}

data "google_container_cluster" "credentials" {
  name       = google_container_cluster.zenotta-mining-cluster.name
  location   = var.location
  project    = var.projectId
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

provider "helm" {
  alias = "zenotta-cluster"
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
  depends_on = [google_container_cluster.credentials]
}

# output "node_pools" {
#   value = data.google_container_cluster.credentials.node_pool
# }

# output "instance_group_urls" {
#   value = data.google_container_cluster.credentials.node_pool[0].instance_group_urls
# }

# data "kubernetes_nodes" "zenotta-miner-nodes" {}

# output "zenotta-miner-node-ids" {
#   value = [for node in data.kubernetes_nodes.zenotta-miner-nodes.nodes : node.spec.0.provider_id]
# }

resource "helm_release" "nvidia-drivers-release" {
  provider   = helm.zenotta-cluster
  name       = "nvidia-drivers-release"
  chart      = "./helm/nvidia-chart"
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

resource "helm_release" "pod-monitoring-release" {
  provider   = helm.zenotta-cluster
  name       = "pod-monitoring-release"
  chart      = "./helm/pod-monitoring-chart"
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

resource "helm_release" "zenotta-miner-release" {
  count = 8
  provider   = helm.zenotta-cluster
  name       = "zenotta-miner-release-${count.index}"
  chart      = "./helm/miner-chart"
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}
