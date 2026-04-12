terraform {
    required_version = "~> v1.14.7"

    required_providers {
      digitalocean = {
        source = "digitalocean/digitalocean"
        version = "~> 2.81.0"
      }
      kubernetes = {
        source = "hashicorp/kubernetes"
        version = "~> 3.0.1"
      }
      helm = {
        source = "hashicorp/helm"
        version = "~> 3.1.1"
      }
      random = {
        source = "hashicorp/random"
        version = "~> 3.8.1"
      }
    }
}