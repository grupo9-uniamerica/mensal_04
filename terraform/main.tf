provider "google" {
  credentials = file("chave.json")
  project     = "projeto-iac-461322"
  region      = "southamerica-east1"
  zone        = "southamerica-east1-a"
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

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}



