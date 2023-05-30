terraform {
  cloud {
    organization = "io-digital"

    workspaces {
      name = "zenotta-cloud-mining"
    }
  }
}
# terraform {
#   cloud {
#     organization = "zenotta-mining"

#     workspaces {
#       name = "zenotta-cloud-mining"
#     }
#   }
# }