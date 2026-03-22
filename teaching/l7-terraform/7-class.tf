resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "instance-20241101-091322" {
  boot_disk {
    auto_delete = true
    device_name = "instance-20241101-091322"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20241009"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"
  name         = "instance-20241101-091322"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/s5terraform/regions/${var.region}/subnetworks/default"
  }

  tags = ["http-server", "https-server"]
  zone = var.zone
}
