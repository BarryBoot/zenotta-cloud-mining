terraform {
  required_version = ">= 1.4.6"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}

resource "helm_release" "zenotta-node-release" {
  name       = "zenotta-node-release"
  chart      = "../helm/node-chart"
}