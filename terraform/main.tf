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

variable "ssh_public_key" {
  description = "Chave pública SSH para o usuário ubuntu"
  type        = string
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

resource "google_compute_firewall" "allow_prometheus" {
  name    = "allow-prometheus"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["prometheus-server"]
}

resource "google_compute_firewall" "allow_grafana" {
  name    = "allow-grafana"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3001"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["grafana-server"]
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

  tags = ["allow-all", "prometheus-server", "grafana-server"]

   metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

output "public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

// Configuração do Cluster GKE
resource "google_container_cluster" "primary" {
  name     = "cluster-prod"
  location = "southamerica-east1-a" 

  remove_default_node_pool = true
  initial_node_count       = 1 

  network_policy {
    enabled = true
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "node-pool-prod-v2"
  cluster    = google_container_cluster.primary.name
  location   = "southamerica-east1-a"
  node_count = 4

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 30
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

// Outputs
output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubernetes_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}
