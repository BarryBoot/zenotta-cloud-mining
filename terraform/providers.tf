terraform {
  required_version = ">= 1.4.6"

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

  # localhost registry with password protection
  # registry {
  #   url      = "oci://localhost:5000"
  #   username = "username"
  #   password = "password"
  # }

  # # private registry
  # registry {
  #   url      = "oci://private.registry"
  #   username = "username"
  #   password = "password"
  # }
}
