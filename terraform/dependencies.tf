terraform {
    required_version = "~> v1.14.7"

    required_providers {
      digitalocean = {
        source = "digitalocean/digitalocean"
        version = "~> 2.81.0"
      }
      random = {
        source = "hashicorp/random"
        version = "~> 3.8.1"
      }
    }
}