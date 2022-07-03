resource "google_compute_subnetwork" "network-with-private-ip-ranges" {
  name          = "new-subnet"
  ip_cidr_range = "192.168.0.0/16"
  region        = "asia-northeast3"
  network       = google_compute_network.custom-test.id
}

resource "google_compute_network" "custom-test" {
  name                    = "new-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_instance" "default" {
  name         = "vm-from-terraform"
  machine_type = "e2-micro"
  zone         = "asia-northeast3-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "new-vpc"
    subnetwork = "new-subnet"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

    metadata_startup_script = file("/root/gcp_set/script.txt")

    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http-terraform"
  network = "new-vpc"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
