resource "google_container_cluster" "zenotta-mining-cluster" {

  name     = "zenotta-mining-cluster"
  location = var.location

  network = google_compute_network.zenotta-mining-network.id
  #subnetwork = google_compute_subnetwork.zenotta-mining-network.id

  node_config {

    preemptible  = true
    #machine_type = "a2-highgpu-1g"
    machine_type = "g2-standard-16"

    guest_accelerator {
      #type  = "nvidia-tesla-a100"
      type = "nvidia-tensor-l4"
      count = 1
      gpu_sharing_config {
        gpu_sharing_strategy       = "timeshare"
        max_shared_clients_per_gpu = 8
      }
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    #service_account = google_service_account.zenotta-mining-service-account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

  }

}
