# SERVICE ACCOUNT START
# Define a Cloud Run Service Account for Cloud SQL Permissions
resource "google_service_account" "lesson7_cloud_run" {
  project      = var.project_id                                   # added
  account_id   = "cloud-run-sql"                                  # Sets a unique ID for the service account.
  display_name = "Cloud Run Service Account for Cloud SQL Access" # Provides a display name for easy identification.
}

# Grant Cloud SQL Client Role to the Service Account
resource "google_project_iam_member" "lesson7_sql_client_role" {
  project = var.project_id                                                     # Specifies the project for the role assignment.
  role    = "roles/cloudsql.client"                                            # Assigns the "cloudsql.client" role to allow SQL client access.
  member  = "serviceAccount:${google_service_account.lesson7_cloud_run.email}" # Links to the service account's email.
}
# SERVICE ACCOUNT END