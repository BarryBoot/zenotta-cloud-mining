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
} 

provider "kubernetes" {
  host                   = data.google_container_cluster.credentials.endpoint
  token                  = data.google_client_config.client.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.zenotta-mining-cluster.master_auth.0.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gcloud"
    args        = ["container", "get-credentials", google_container_cluster.zenotta-mining-cluster.name, "--region", var.region, "--project", var.projectId]
  }
} 

data "kubernetes_nodes" "miner-nodes" {
  metadata {
    labels = {
      "cloud.google.com/gke-accelerator" = "nvidia-l4"
    }
  }
}

output "miner-node-names" {
  value = [for node in data.kubernetes_nodes.miner-nodes.nodes : node.metadata.0.name]
}

resource "helm_release" "zenotta-node-release" {
  
  provider   = helm.zenotta-cluster
  name       = "zenotta-node-release"
  chart      = "./helm/node-chart"
  depends_on = [google_container_cluster.zenotta-mining-cluster]

  # for_each = toset([for node in data.kubernetes_nodes.miner-nodes.nodes : node.metadata.0.name])
  # set {
  #   name  = "node.name"
  #   value = each.key
  # }

}

module "zenotta-miners" {
  source = "./miners"
  count = length(data.kubernetes_nodes.miner-nodes.nodes)
  nodeIndex = count.index
  nodeName = data.kubernetes_nodes.miner-nodes.nodes[count.index].metadata.0.name
  miners = var.miners[count.index]
}


# output "node_pools" {
#   value = data.google_container_cluster.credentials.node_pool
# }

# output "instance_group_urls" {
#   value = google_container_cluster.zenotta-mining-cluster.node_pool[0].instance_group_urls
# }

# data "kubernetes_nodes" "zenotta-miner-nodes" {}

# output "zenotta-miner-node-ids" {
#   value = [for node in data.kubernetes_nodes.zenotta-miner-nodes.nodes : node.spec.0.provider_id]
# }