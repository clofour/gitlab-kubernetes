resource "digitalocean_vpc" "main" {
    name = "${var.cluster_name}-vpc"
    region = var.region
    ip_range = "10.20.0.0/16"
}