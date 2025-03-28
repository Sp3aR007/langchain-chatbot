variable "project_id" {
  type    = string
  description = "The GCP project ID"
  default= "poised-diagram-446213-g8"
}
variable "region" {
  type    = string
  description = "GCP region to deploy the servers and vpc"
  default= "us-central1"
}
variable "zone" {
  type    = string
  default = "us-central1-a"
  description = "Zone for GCP"
}
variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
  description = "The CIDR range for the subnet"
}
variable "machine_type" {
  type    = string
  default = "c4-highmem-4"
  description = "The machine type for the compute instance"
}
variable "image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
  description = "The image used for the instance"
}