terraform {
  required_version = ">= 1.4.6"
}

provider "google" {
  project = var.projectId
  region  = var.region
  zone    = var.zone
}
