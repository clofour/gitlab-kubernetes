locals {
    lb_ip = try(data.kubernetes_service_v1.ingress_nginx.status[0].load_balancer[0].ingress[0].ip, null)
}

resource "digitalocean_domain" "main" {
    name = var.domain_name
}

resource "digitalocean_record" "gitlab" {
    count = local.lb_ip != null ? 1 : 0

    domain = digitalocean_domain.main.name
    type = "A"
    name = var.gitlab_host
    value = local.lb_ip
    ttl = 300
}