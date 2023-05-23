provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

terraform {
  required_version = ">= 1.4.6"

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.0"
    }
  }
}
