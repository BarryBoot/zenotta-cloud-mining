# resource "google_project" "io-anvil" {
#   name                = var.project
#   project_id          = var.projectId
#   auto_create_network = false
#   billing_account     = var.billingAccount
# }

# data "google_iam_policy" "zenotta-mining-iam-policy" {
#   binding {
#     role = "roles/iam.serviceAccountUser"

#     members = [
#       google_service_account.zenotta-mining-service-account.email
#     ]
#   }
# }

# resource "google_service_account" "zenotta-mining-service-account" {
#   account_id   = "zenotta-mining-service-account"
#   display_name = "zenotta-mining-service-account"
# }

# resource "google_service_account" "zenotta-node-service-account" {
#   project  = var.projectId
#   account_id   = "zenotta-node-service-account"
#   display_name = "zenotta-node-service-account"
# }