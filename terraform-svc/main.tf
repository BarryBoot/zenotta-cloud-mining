data "google_client_config" "default" {}

data "google_container_cluster" "default" {
  name       = local.cluster_name
  location   = var.location
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

module "zenotta-nodes" {
  source     = "./nodes"
}

module "zenotta-miners" {
  depends_on = [module.zenotta-nodes]
  source     = "./miners"
  count      = length(local.zenottaMiners)
  nodeIndex  = count.index
  miners     = local.zenottaMiners[count.index]
  region     = var.region
  projectId  = var.projectId
}