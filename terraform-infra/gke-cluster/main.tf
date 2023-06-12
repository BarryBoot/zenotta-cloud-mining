terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.65.2"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
}

resource "google_service_account" "zenotta-node-service-account" {
 account_id   = "zenotta-node-service-account"
 display_name = "zenotta-node-service-account"
}

resource "google_container_cluster" "default" {

  name           = var.cluster_name
  location       = var.location
  node_locations = var.node_locations

  network    = var.network_id
  subnetwork = var.subnetwork_id
  enable_shielded_nodes = true

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"
  
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }

  monitoring_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "CONTROLLER_MANAGER",
      "SCHEDULER"
    ]
    managed_prometheus {
      enabled = true
    }
  }

  addons_config{
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

}

resource "google_container_node_pool" "default" {
  name       = "zenotta-mining-node-pool-lfour"
  cluster    = google_container_cluster.default.id
  node_count = var.cluster_node_count

  network_config {
    enable_private_nodes = true
  }

  node_config {

    preemptible = false

    #machine_type = "a2-highgpu-1g"
    machine_type = "g2-standard-16"
    disk_size_gb = 100
    disk_type    = "pd-standard"

    gvnic {
      enabled = true
    }

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

resource "google_container_cluster" "testing-cluster" {

  name           = "testing-cluster"
  location       = var.location
  node_locations = var.node_locations

  enable_shielded_nodes = true

  remove_default_node_pool = true
  initial_node_count       = 1

  addons_config{
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

}

resource "google_container_node_pool" "testing-nodepool" {
  name       = "testing-nodepool"
  cluster    = google_container_cluster.testing-cluster.id
  node_count = 1

  network_config {
    enable_private_nodes = true
  }

  node_config {

    preemptible = false

    #machine_type = "a2-highgpu-1g"
    machine_type = "g2-standard-16"
    disk_size_gb = 100
    disk_type    = "pd-standard"

    gvnic {
      enabled = true
    }

    guest_accelerator {
      #type  = "nvidia-tesla-a100"
      type  = "nvidia-l4"
      count = 1
      gpu_sharing_config {
        gpu_sharing_strategy       = "TIME_SHARING"
        max_shared_clients_per_gpu = 16
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