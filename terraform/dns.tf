locals {
    lb_ip = try(data.kubernetes_service_v1.ingress_nginx.status[0].load_balancer[0].ingress[0].ip, null)
}

data "digitalocean_domain" "main" {
    name = var.domain_name
}

resource "digitalocean_record" "gitlab" {
    count = 1

    domain = digitalocean_domain.main.name
    type = "A"
    name = var.gitlab_host
    value = local.lb_ip
    ttl = 300
}