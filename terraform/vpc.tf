resource "google_compute_network" "zenotta-mining-network" {
  project                 = var.projectId
  name                    = "zenotta-mining-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "zenotta-mining-subnetwork" {
  project       = var.projectId
  name          = "zenotta-mining-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.zenotta-mining-network.id

  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "192.168.64.0/22"
  }

}
