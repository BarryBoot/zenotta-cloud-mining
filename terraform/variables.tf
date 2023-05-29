variable "GOOGLE_CREDENTIALS" {
  type = string
}

variable "project" {
  type    = string
  default = "zenotta-mining"
}

variable "projectId" {
  type    = string
  default = "zenotta-mining-387514"
}

variable "billingAccount" {
  type    = string
  default = "014B21-4E10C8-3EAEB6"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "location" {
  type    = string
  default = "us-central1"
}

variable "node_locations" {
    type = list
    default = ["us-central1-a", "us-central1-b"]
    # add "us-central1-b" if we want another zone - it also support L4
}

variable "nodes" {
  type = map
  default = {
    miner0 = 8,
    miner1 = 8
  }
}