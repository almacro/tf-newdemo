terraform {
  backend "gcs" {
  }
}

#IAM
# intake-writer role
data "google_iam_policy" "intake_writer" {
  binding {
    role    = "roles/iam.serviceAccountUser"
    members = []
  }
}
resource "google_service_account" "data_uploader" {
  account_id   = "offload-data-uploader"
  display_name = "A service account that permits a Data Uploader to write to the Intake bucket."
}
resource "google_service_account_iam_policy" "data_uploader" {
  service_account_id = google_service_account.data_uploader.name
  policy_data        = data.google_iam_policy.intake_writer.policy_data
}

# intake-reader role
data "google_iam_policy" "intake_reader" {
  binding {
    role    = "roles/iam.serviceAccountUser"
    members = []
  }
}
resource "google_service_account" "data_consumer" {
  account_id   = "offload-data-consumer"
  display_name = "A service account that permits a Data Consumer to read from the Intake bucket."
}
resource "google_service_account_iam_policy" "data_consumer" {
  service_account_id = google_service_account.data_consumer.name
  policy_data        = data.google_iam_policy.intake_reader.policy_data
}

# outtake-writer role
data "google_iam_policy" "outtake_writer" {
  binding {
    role    = "roles/iam.serviceAccountUser"
    members = []
  }
}
resource "google_service_account" "data_producer" {
  account_id   = "offload-data-producer"
  display_name = "A service account that permits a Data Producer to write to the Outtake bucket."
}
resource "google_service_account_iam_policy" "data_producer" {
  service_account_id = google_service_account.data_producer.name
  policy_data        = data.google_iam_policy.outtake_writer.policy_data
}

# outtake-reader role
data "google_iam_policy" "outtake_reader" {
  binding {
    role    = "roles/iam.serviceAccountUser"
    members = []
  }
}
resource "google_service_account" "data_downloader" {
  account_id   = "offload-data-downloader"
  display_name = "A service account that permits a Data Downloader to read from the Outtake bucket."
}
resource "google_service_account_iam_policy" "data_downloader" {
  service_account_id = google_service_account.data_producer.name
  policy_data        = data.google_iam_policy.outtake_reader.policy_data
}

# system-audit role
data "google_iam_policy" "admin" {
  binding {
    role    = "roles/iam.serviceAccountUser"
    members = []
  }
}
resource "google_service_account" "auditor" {
  account_id   = "offload-admin"
  display_name = "A service account that manages the system."
}
resource "google_service_account_iam_policy" "admin" {
  service_account_id = google_service_account.auditor.name
  policy_data        = data.google_iam_policy.admin.policy_data
}


#STORAGE
# intake bucket
resource "google_storage_bucket" "intake" {
  name     = "offload-in"
  location = upper(var.region)

}
# outtake bucket
resource "google_storage_bucket" "outtake" {
  name     = "offload-out"
  location = upper(var.region)
}

#COMPUTE
# processing vm

#NETWORK
# need subnet?
