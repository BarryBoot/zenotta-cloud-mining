terraform {
  required_version = ">= 1.4.6"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}

resource "helm_release" "zenotta-miner-release" {
  count      = length(var.miners)
  name       = "zenotta-miner-release-${var.nodeIndex}-${count.index}"
  chart      = "../helm/miner-chart"
  
  set {
    name  = "miner.fullnameOverride"
    value = "zenotta-miner-${var.nodeIndex}-${count.index}"
  }
  set {
    name = "miner.port" 
    value = "123${var.nodeIndex}${count.index}"
  }
  set {
    name = "miner.user_port"
    value = "236${var.nodeIndex}${count.index}"
  }
  set {
    name = "miner.api_key"
    value = "${var.miners[count.index].api_key}-${var.nodeIndex}${count.index}"
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
    name = "miner.disk_name"
    value = "projects/${var.projectId}/regions/${var.region}/disks/zenotta-miner-disk-${var.nodeIndex}-${count.index}"
  }
}