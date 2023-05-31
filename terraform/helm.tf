data "google_client_config" "client" {
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

data "google_container_cluster" "credentials" {
  name       = google_container_cluster.zenotta-mining-cluster.name
  location   = var.location
  project    = var.projectId
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.credentials.endpoint}"
    token                  = data.google_client_config.client.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.zenotta-mining-cluster.master_auth.0.cluster_ca_certificate)
  }
} 

provider "kubernetes" {
  host                   =  "https://${data.google_container_cluster.credentials.endpoint}"
  token                  = data.google_client_config.client.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.zenotta-mining-cluster.master_auth.0.cluster_ca_certificate)
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

output "miner-nodes" {
 value = data.kubernetes_nodes.miner-nodes.nodes
}

resource "helm_release" "zenotta-node-release" {
  name       = "zenotta-node-release"
  chart      = "./helm/node-chart"
  depends_on = [google_container_cluster.zenotta-mining-cluster]
}

module "zenotta-miners" {
  source = "./miners"
  count = length(data.kubernetes_nodes.miner-nodes.nodes)
  nodeIndex = count.index
  nodeName = data.kubernetes_nodes.miner-nodes.nodes[count.index].metadata.0.name
  miners = var.zenottaMiners[count.index]
}
