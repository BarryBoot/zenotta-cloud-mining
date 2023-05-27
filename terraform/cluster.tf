resource "google_container_cluster" "zenotta-mining-cluster" {

  name           = "zenotta-mining-cluster"
  location       = var.location
  node_locations = var.node_locations
  project        = var.projectId

  network = google_compute_network.zenotta-mining-network.id
  subnetwork = google_compute_subnetwork.zenotta-mining-subnetwork.id

  remove_default_node_pool = true
  initial_node_count = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }

}

resource "google_container_node_pool" "zenotta-mining-node-pool-L4" {
  name       = "zenotta-mining-node-pool-L4"
  project    = var.projectId
  cluster    = google_container_cluster.zenotta-mining-cluster.id
  node_count = 1
  
  node_config {

    # turn this to false for production
    # for now it saves money
    preemptible = true

    #machine_type = "a2-highgpu-1g"
    machine_type = "g2-standard-16"

    guest_accelerator {
      #type  = "nvidia-tesla-a100"
      type  = "nvidia-l4"
      count = 1
      gpu_sharing_config {
        gpu_sharing_strategy       = "TIME_SHARING"
        max_shared_clients_per_gpu = 8
      }
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.zenotta-node-service-account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

  }
}


