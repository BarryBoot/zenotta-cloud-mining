terraform {

  required_version = ">= 1.4.6"
  
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.65.2"
    }

    sops = {
      source = "carlpett/sops"
      version = "0.7.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
      configuration_aliases = [ helm.zenotta-cluster ]
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }

  cloud {
    organization = "io-digital"
    workspaces {
      name = "zenotta-cloud-mining"
    }
  }
}

provider "google" {
  project = var.projectId
  region  = var.region
  zone    = var.zone
}
