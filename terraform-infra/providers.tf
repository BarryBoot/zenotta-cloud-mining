terraform {

  required_version = "1.5"
  
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.69.1"
    }

  }

  cloud {
    organization = "io-digital"
    workspaces {
      name = "zenotta-cloud-mining-infra"
    }
  }
}

provider "google" {
  project = var.projectId
  region  = var.region
  zone    = var.zone
}
