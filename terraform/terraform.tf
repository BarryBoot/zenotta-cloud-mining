terraform {
  cloud {
    organization = "zenotta-mining"

    workspaces {
      name = "zenotta-cloud-mining"
    }
  }
}
