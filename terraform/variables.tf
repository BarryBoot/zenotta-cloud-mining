variable "GOOGLE_CREDENTIALS" {
  type = string
}

variable "project" {
  type    = string
  default = "io-anvil"
}

variable "projectId" {
  type    = string
  default = "io-anvil"
}

variable "billingAccount" {
  type    = string
  default = "006A3A-0E7CC9-29C872"
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

variable "cluster_name" {
  type = string
  default = "zenotta-mining-cluster"
}

variable "cluster_node_count"{
  type = number
  default = 2
}

variable "node_locations" {
    type = list
    default = ["us-central1-a", "us-central1-b"]
    # add "us-central1-b" if we want another zone - it also support L4
} 