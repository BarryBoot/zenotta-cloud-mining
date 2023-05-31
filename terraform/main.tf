# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
# data "google_client_config" "default" {
#   depends_on = [module.gke-cluster]
# }

# # Defer reading the cluster data until the GKE cluster exists.
# data "google_container_cluster" "default" {
#   name       = var.cluster_name
#   depends_on = [module.gke-cluster]
# }

# provider "kubernetes" {
#   host  = "https://${data.google_container_cluster.default.endpoint}"
#   token = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(
#     data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
#   )
# }

# provider "helm" {
#   kubernetes {
#     host  = "https://${data.google_container_cluster.default.endpoint}"
#     token = data.google_client_config.default.access_token
#     cluster_ca_certificate = base64decode(
#       data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
#     )
#   }
# }

module "gke-network" {
  source = "./gke-network"
  region = var.region
}

# module "gke-cluster" {
#   depends_on     = [module.gke-network]
#   source         = "./gke-cluster"
#   cluster_name   = var.cluster_name
#   network_id     = module.gke-network.network_id
#   subnetwork_id  = module.gke-network.subnetwork_id
#   region         = var.region
#   location       = var.location
#   node_locations = var.node_locations
# }

# resource "helm_release" "zenotta-node-release" {
#   depends_on = [module.gke-cluster]
#   name       = "zenotta-node-release"
#   chart      = "../helm/node-chart"
# }

# data "kubernetes_nodes" "miner-nodes" {
#   metadata {
#     labels = {
#       "cloud.google.com/gke-accelerator" = "nvidia-l4"
#     }
#   }
# }

# module "zenotta-miners" {
#   depends_on   = [module.gke-cluster]
#   source = "./miners"
#   count = length(data.kubernetes_nodes.miner-nodes.nodes)
#   nodeIndex = count.index
#   nodeName = data.kubernetes_nodes.miner-nodes.nodes[count.index].metadata.0.name
#   miners = var.zenottaMiners[count.index]
# }

# output "miner-node-names" {
#   value = [for node in data.kubernetes_nodes.miner-nodes.nodes : node.metadata.0.name]
# }

# output "miner-nodes" {
#  value = data.kubernetes_nodes.miner-nodes.nodes
# }
