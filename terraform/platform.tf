resource "google_project" "zenotta-mining" {
  name       = "Zenotta Mining"
  project_id = "zenotta-mining"
  auto_create_network = false
}

data "google_iam_policy" "zenotta-mining-iam-policy" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      "serviceAccount:{barry.botha@gmail.com}",
    ]
  }
}

resource "google_service_account" "zenotta-mining-service-account" {
  account_id   = "zenotta-mining-service-account"
  display_name = "Zenotta Mining Service Account"
}

resource "google_service_account_iam_policy" "admin-account-iam" {
  service_account_id = google_service_account.zenotta-mining-service-account.name
  policy_data        = data.google_iam_policy.zenotta-mining-iam-policy.policy_data
}