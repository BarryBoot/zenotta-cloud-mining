resource "google_compute_network" "zenotta-mining-network" {
  project                 = var.projectId
  name                    = "zenotta-mining-network"
  auto_create_subnetworks = true
}
