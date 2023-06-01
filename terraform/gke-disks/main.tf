terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.65.2"
    }
  }
}

resource "google_compute_region_disk" "default" {
  count      = 8
  name  = "zenotta-miner-disk-${var.nodeIndex}-${count.index}"
  type  = "pd-hdd"
  region  = var.region
  replica_zones = var.replica_zones
  
  labels = {
    owner = "${var.miners[count.index].owner}"
  }
  
  size = 2

}