terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.65.2"
    }
  }
}

resource "google_compute_network" "zenotta-mining-network" {
  name                    = "zenotta-mining-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "zenotta-mining-subnetwork" {
  name          = "zenotta-mining-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.zenotta-mining-network.id

  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = "10.3.0.0/16"
  }

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "10.4.0.0/16"
  }

}

resource "google_compute_router" "zenotta-mining-router" {
  name = "zenotta-minnig-router"
  region = var.region
  network = google_compute_network.zenotta-mining-network.id
}

resource "google_compute_address" "zenotta-minnig-nat-manual-ip" {
  name = "zenotta-minnig-nat-manual-ip"
  region = var.region
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_router_nat" "router-nat" {
  name = "zenotta-mining-router-nat"
  router = google_compute_router.zenotta-mining-router.name
  region = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = google_compute_address.zenotta-minnig-nat-manual-ip.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.zenotta-mining-subnetwork.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
