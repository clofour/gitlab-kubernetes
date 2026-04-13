variable "do_token" {
    type = string
    sensitive = true
}

variable "spaces_access_id" {
    type = string
    sensitive = true
}

variable "spaces_secret_key" {
    type = string
    sensitive = true
}


variable "region" {
    type = string
    default = "ams3"
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
    default = "s-2vcpu-4gb"
}

variable "node_count" {
    type = number
    default = 2
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