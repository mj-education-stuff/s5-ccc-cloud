# VPC START
# Define a global internal IP address for VPC peering purposes.
resource "google_compute_global_address" "lesson7_google_managed_services_default" {
  project       = var.project_id                            # Specifies the project ID where the resource will be created.
  name          = "lesson7-google-managed-services-default" # A unique name for the IP address resource.
  purpose       = "VPC_PEERING"                             # Specifies that this IP address is intended for VPC peering.
  address_type  = "INTERNAL"                                # Defines the address as internal-only, not accessible from outside Google Cloud.
  prefix_length = 16                                        # The prefix length determines the IP range (e.g., 16 allows for 65,536 IPs).
  network       = "default"                                 # The VPC network to assign the global address range.
}

# Set up VPC peering connection for Google-managed services (such as Cloud SQL or Memorystore) within the same VPC.
resource "google_service_networking_connection" "vpc_peering" {
  network                 = "default"                                                                         # The name of the VPC network where peering will occur.
  service                 = "servicenetworking.googleapis.com"                                                # The Google service for VPC peering with Google-managed services.
  reserved_peering_ranges = ["${google_compute_global_address.lesson7_google_managed_services_default.name}"] # Use the global IP address range created above for the peering connection.
}
# VPC END



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
    availability_type = "ZONAL"            # Single zone availability / Configures instance for zonal availability (single zone).

    backup_configuration {
      enabled = false # Disables automated daily backups (useful for dev/test environments).
    }

    ip_configuration {
      ipv4_enabled    = true                                                # Disable public IP assignment (equivalent to --no-assign-ip)
      private_network = "projects/${var.project_id}/global/networks/default" # Attach instance to the default VPC network
      ssl_mode        = "ENCRYPTED_ONLY"                                    # Enforce SSL connections
    }
  }

  root_password = "test-password" # Sets the root password for the database instance (use secure values in production).
}

# Enable SSL enforcement on the Cloud SQL instance
# resource "google_sql_ssl_enforced_config" "quickstart_instance_ssl" {
#   instance    = google_sql_database_instance.lesson7.name # Reference the SQL instance created above
#   require_ssl = true                                      # Enable SSL enforcement for connections
# }

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
