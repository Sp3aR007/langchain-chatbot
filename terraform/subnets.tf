resource "google_compute_subnetwork" "subnet" {
  name          = "chatbot-subnet"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  depends_on = [ google_compute_network.vpc_network ]
}

