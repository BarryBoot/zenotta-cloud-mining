resource "google_compute_network" "zenotta-mining-network" {
  project                 = var.project
  name                    = "zenotta-mining-network"
  auto_create_subnetworks = true
}
