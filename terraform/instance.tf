resource "google_compute_instance" "vm_instance" {
  name         = "chatbot"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["gradio", "http-server", "https-server", "ssh-access"]

  boot_disk {
    initialize_params {
      image = var.image
      size = 15
    }
  }

metadata_startup_script = <<-EOF
#!/bin/bash 
sudo apt-get update -y 
sudo apt-get install -y docker.io docker-buildx
EOF
  depends_on = [ google_compute_network.vpc_network ]
  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      // Ephemeral public IP
    }
  }
}