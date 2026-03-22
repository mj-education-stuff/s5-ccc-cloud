# [START storage_remote_terraform_backend_template]
# [START storage_bucket_tf_with_versioning_pap_uap_no_destroy]

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  project  = var.project_id
  name     = "terraform-remote-backend-${random_id.default.hex}"
  location = "EU"

  force_destroy               = true # should be false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = false # should be true
  }
}
# [END storage_bucket_tf_with_versioning_pap_uap_no_destroy]

# [START storage_remote_backend_local_file]
resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/7-a-backend.tf"

  # You can store the template in a file and use the templatefile function for
  # more modularity, if you prefer, instead of storing the template inline as
  # we do here.
  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.default.name}"
    }
  }
  EOT
}
# [END storage_remote_backend_local_file]
# [END storage_remote_terraform_backend_template]
