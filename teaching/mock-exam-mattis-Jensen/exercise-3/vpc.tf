resource "google_compute_network" "vpc_network" {
  project                 =  var.project_id
  name                    = "exam-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}