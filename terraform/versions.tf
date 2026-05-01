terraform {
    required_version = "~> v1.14.7"

    required_providers {
      digitalocean = {
        source = "digitalocean/digitalocean"
        version = "~> 2.81.0"
      }
      cloudflare = {
        source = "cloudflare/cloudflare"
        version = "~> 5.19.0"
      }
      kubernetes = {
        source = "hashicorp/kubernetes"
        version = "~> 3.0.1"
      }
      flux = {
        source = "fluxcd/flux"
        version = "~> 1.8.6"
      }
      random = {
        source = "hashicorp/random"
        version = "~> 3.8.1"
      }
      helm = {
        source = "hashicorp/helm"
        version = "~> 3.1.1"
      }
    }
}