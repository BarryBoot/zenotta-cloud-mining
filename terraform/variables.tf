variable "GOOGLE_CREDENTIALS" {
  type = string
}

variable "project" {
  type    = string
  default = "zenotta-mining"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "location" {
  type    = string
  default = "us-central1"
}