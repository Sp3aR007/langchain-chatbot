resource "google_compute_network" "vpc_network" {
  name = "chatbot"
  auto_create_subnetworks = false
}