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
