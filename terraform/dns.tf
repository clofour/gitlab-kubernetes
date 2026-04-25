locals {
    lb_ip = try(data.kubernetes_service_v1.envoy_gateway[0].status[0].load_balancer[0].ingress[0].ip, null)
    records = toset([
        var.gitlab_host, var.registry_host, "*.${var.pages_host}", var.grafana_host
    ])
}

resource "digitalocean_domain" "main" {
    name = var.domain_name
}

resource "digitalocean_record" "main" {
    for_each = local.records

    domain = digitalocean_domain.main.name
    type = "A"
    name = each.key
    value = local.lb_ip
    ttl = 300

    depends_on = [ time_sleep.wait_for_lb ]
}