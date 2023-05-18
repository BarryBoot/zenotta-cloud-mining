resource "google_compute_network" "zenotta-mining-network" {
  name                    = "zenotta-mining-network"
  auto_create_subnetworks = false
}