variable "do_token" {
    type = string
    sensitive = true
}

variable "do_dns_token" {
    type = string
    sensitive = true
}

variable "cloudflare_account_id" {
    type = string
    sensitive = true
}

variable "cloudflare_api_token" {
    type = string
    sensitive = true
}

variable "cloudflare_r2_endpoint" {
    type = string
    sensitive = true
}

variable "cloudflare_r2_access_key_id" {
    type = string
    sensitive = true
}

variable "cloudflare_r2_secret_access_key" {
    type = string
    sensitive = true
}

variable "sendgrid_api_key" {
    type = string
    sensitive = true
}


variable "region" {
    type = string
    default = "ams3"
}

variable "r2_jurisdiction" {
    type = string
    default = "eu"
}

variable "cluster_name" {
    type = string
    default = "gitlab"
}

variable "k8s_version" {
    type = string
    default = "1.35.1"
}

variable "node_size" {
    type = string
    default = "s-4vcpu-8gb"
}

variable "node_count" {
    type = number
    default = 3
}

variable "email" {
    type = string
    validation {
      condition = trimspace(var.email) != ""
      error_message = "email must not be empty."
    }
}

variable "domain_name" {
    type = string
}

variable "gitlab_host" {
    type = string
    default = "gitlab"
}

variable "registry_host" {
    type = string
    default = "registry"
}

variable "pages_host" {
    type = string
    default = "pages"
}

variable "grafana_host" {
    type = string
    default = "grafana"
}