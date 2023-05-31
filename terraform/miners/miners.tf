terraform {
  required_version = ">= 1.4.6"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.65.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}

resource "helm_release" "zenotta-miner-release" {
  count      = 8
  name       = "zenotta-miner-release-${count.index}"
  chart      = "./helm/miner-chart"
  
  set {
    name  = "miner.fullnameOverride"
    value = "zenotta-miner-${count.index}"
  }
  set {
    name = "miner.port" 
    value = "1234${count.index}"
  }
  set {
    name = "miner.user_port"
    value = "236${var.nodeIndex}${count.index}"
  }
  set {
    name = "miner.api_key"
    value = "${var.miners[count.index].api_key}"
  }
  set {
    name = "miner.owner"
    value = "${var.miners[count.index].owner}"
  }
  set {
    name = "miner.period"
    value = "${var.miners[count.index].period}"
  }
  set {
    name = "miner.node_name"
    value = "${var.nodeName}"
  }
}