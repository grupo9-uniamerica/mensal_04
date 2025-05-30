terraform {
  backend "gcs" {
    bucket = "projeto-iac-tfstate-loungegario"   
    prefix = "terraform/state"
  }
}

provider "google" {
  credentials = file("chave.json")
  project     = "projeto-iac-461322"
  region      = "southamerica-east1"
  zone        = "southamerica-east1-a"
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "allow_frontend" {
  name    = "allow-frontend"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["frontend-server"]
}

resource "google_compute_firewall" "allow_backend" {
  name    = "allow-backend"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["backend-server"]
}

resource "google_compute_firewall" "allow_all" {
  name    = "allow-all"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-all"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-iac"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["allow-all"]

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
