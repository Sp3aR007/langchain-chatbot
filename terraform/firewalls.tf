

resource "google_compute_firewall" "firewall_rule" {
  name    = "allow-gradio"
  network = google_compute_network.vpc_network.name
  source_ranges = [ "0.0.0.0/0"]
  depends_on = [ google_compute_network.vpc_network ]
  allow {
    protocol = "tcp"
    ports    = ["7860"]
  }

  target_tags = ["gradio"]
}
resource "google_compute_firewall" "firewall_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name
  source_ranges = [ "0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-server"]
}

resource "google_compute_firewall" "firewall_https" {
  name    = "allow-https"
  network = google_compute_network.vpc_network.name
  source_ranges = [ "0.0.0.0/0"]
  depends_on = [ google_compute_network.vpc_network ]
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["https-server"]
}

resource "google_compute_firewall" "firewall_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name
  source_ranges = [ "0.0.0.0/0"]
  depends_on = [ google_compute_network.vpc_network ]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-access"]
}