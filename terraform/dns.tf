resource "digitalocean_domain" "main" {
    name = var.domain_name
}

resource "digitalocean_record" "gitlab" {
    domain = digitalocean_domain.main.name
    type = "A"
    name = "gitlab"
    value = data.kubernetes_service.ingress_nginx.status[0].load_balancer[0].ingress[0].ip
    ttl = 300
}