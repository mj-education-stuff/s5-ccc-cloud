# DB START
# Define a Google Cloud SQL Database Instance
resource "google_sql_database_instance" "lesson7" {
  project             = var.project_id     # Specifies the project where the Cloud SQL instance will be created.
  name                = "test-db-instance" # Sets the name of the SQL instance.
  database_version    = "MYSQL_8_0"        # Defines the database engine and version; here, MySQL 8.0.
  region              = var.region         # Sets the region to host the instance, based on a variable.
  deletion_protection = false              # Allows deletion of the instance without extra steps (useful for dev/test environments).

  settings {
    tier              = "db-n1-standard-1" # Defines the machine type: 1 vCPU, 3.75 GB RAM.
    disk_size         = 10                 # Sets the storage capacity to 10 GB.
    disk_type         = "PD_HDD"           # Chooses a cheaper HDD (Hard Disk Drive) storage option.
    disk_autoresize   = true               # Enables automatic disk resizing to prevent storage issues.
    availability_type = "ZONAL"            # Configures instance for zonal availability (single zone).

    backup_configuration {
      enabled = false # Disables automated daily backups (useful for dev/test environments).
    }
  }

  root_password = "test-password" # Sets the root password for the database instance (use secure values in production).
}

# Define a Database within the SQL Instance
resource "google_sql_database" "lesson7" {
  name     = "test-db"                                 # Sets the database name within the instance.
  instance = google_sql_database_instance.lesson7.name # Links to the Cloud SQL instance created above.
}

# Define a Database User
resource "google_sql_user" "lesson7" {
  project  = var.project_id                            # Specifies the project for user creation.
  name     = "test-user"                               # Sets a username for the database.
  instance = google_sql_database_instance.lesson7.name # Associates the user with the created Cloud SQL instance.
  password = "test-password"                           # Sets the user's password (use secure values in production).
}
# DB END


# ARTIFACT REGISTRY START
# Define an Artifact Registry repository to store container image.
resource "google_artifact_registry_repository" "lesson7_repo" {
  project       = var.project_id                 # Specifies the project where the registry will be created.
  location      = var.artifact_registry_location # Sets the location of the repository, defined by a variable.
  repository_id = "l7-terraform"                 # Sets the repository ID for storing container images.
  description   = "Repository for images"        # Provides a description for the repository.
  format        = "DOCKER"                       # Specifies the format, Docker, as it will hold Docker images.
}
# ARTIFACT REGISTRY END