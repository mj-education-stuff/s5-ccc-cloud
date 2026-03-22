# CLOUD RUN START
# Define a Cloud Run Service that will host the frontend application
# gcloud builds submit --tag europe-north1-docker.pkg.dev/s5terraform/l7-terraform/frontend:latest
resource "google_cloud_run_service" "three-data_frontend_service" {
  project  = var.project_id                # added
  name     = "three-data-frontend-service" # Sets the name for the Cloud Run service.
  location = var.region                    # Defines the region for the Cloud Run service.

  # Configures the service's deployment template
  template {
    spec {
      containers {
        # Specifies the container image location in Artifact Registry
        image = "${var.artifact_registry_location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.lesson7_repo.repository_id}/frontend:latest"

        # Sets environment variables for connecting the Cloud Run service to the SQL instance
        env {
          name  = "INSTANCE_UNIX_SOCKET"
          value = "/cloudsql/${var.project_id}:${var.region}:${google_sql_database_instance.lesson7.name}"
        }
      }

      # Specifies the service account to use for Cloud SQL access
      service_account_name = google_service_account.lesson7_cloud_run.email
    }
  }

  # Configures routing to always send traffic to the latest deployed version
  traffic {
    percent         = 100  # Sends all traffic to the latest revision.
    latest_revision = true # Ensures the latest deployed revision is always used.
  }
}

# Grant Unauthenticated Users Access to the Cloud Run Service
resource "google_cloud_run_service_iam_member" "lesson7_frontend_unauthenticated_invoker" {
  project  = var.project_id                                            # Specifies the project for the IAM policy.
  location = var.region                                                # Defines the region for the policy.
  service  = google_cloud_run_service.three-data_frontend_service.name # Links to the Cloud Run service.
  role     = "roles/run.invoker"                                       # Assigns the "run.invoker" role, enabling public access.
  member   = "allUsers"                                                # Makes the service accessible to unauthenticated users (public).
}
# CLOUD RUN END
