# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {
  depends_on = [module.gke-cluster]
}

# Defer reading the cluster data until the GKE cluster exists.
data "google_container_cluster" "default" {
  name       = local.cluster_name
  location = var.location
  depends_on = [module.gke-cluster]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.default.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.default.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
    )
  }
}

module "gke-network" {
  source = "./gke-network"
  region = var.region
}

module "gke-cluster" {
  depends_on         = [module.gke-network]
  source             = "./gke-cluster"
  cluster_name       = local.cluster_name
  cluster_node_count = var.cluster_node_count
  network_id         = module.gke-network.network_id
  subnetwork_id      = module.gke-network.subnetwork_id
  region             = var.region
  location           = var.location
  node_locations     = var.node_locations
}

# data "kubernetes_nodes" "default" {
#   metadata {
#     labels = {
#       "cloud.google.com/gke-accelerator" = "nvidia-l4"
#     }
#   }
# }

# output "node-names" {
#   value = [for node in data.kubernetes_nodes.deault.nodes : node.metadata.0.name]
# }

# output "nodes" {
#  value = data.kubernetes_nodes.default.nodes
# }

# module "zenotta-nodes" {
#   depends_on = [module.gke-cluster]
#   source = "./nodes"
# }

# module "zenotta-miners" {
#   depends_on = [module.gke-cluster, module.zenotta-nodes]
#   source     = "./miners"
#   count      = length(var.zenottaMiners)
#   nodeIndex  = count.index
#   miners     = var.zenottaMiners[count.index]
# }