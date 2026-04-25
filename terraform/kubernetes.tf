# resource "kubernetes_namespace_v1" "external_dns" {
#     metadata {
#       name = "external-dns"
#     }

#     depends_on = [ digitalocean_kubernetes_cluster.main ]
# }

resource "kubernetes_namespace_v1" "cert_manager" {
    metadata {
      name = "cert-manager"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "kubernetes_namespace_v1" "envoy_gateway_system" {
    metadata {
      name = "envoy-gateway-system"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "kubernetes_namespace_v1" "ingress_nginx" {
    metadata {
      name = "ingress-nginx"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "kubernetes_namespace_v1" "gitlab" {
    metadata {
      name = "gitlab"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "kubernetes_namespace_v1" "monitoring" {
    metadata {
      name = "monitoring"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "random_password" "gitlab_root" {
    length = 64
}

resource "kubernetes_secret_v1" "do_dns_secret" {
    metadata {
        name = "do-dns-secret"
        namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name
    }

    data = {
        password = var.do_dns_token
    }

    type = "Opaque"
}

resource "kubernetes_secret_v1" "gitlab_initial_root_password" {
    metadata {
        name = "gitlab-initial-root-password"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        password = random_password.gitlab_root.result
    }

    type = "Opaque"
}

resource "kubernetes_secret_v1" "gitlab_postgres" {
    metadata {
        name = "gitlab-postgres-secret"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        password = digitalocean_database_cluster.postgres.password
    }

    type = "Opaque"
}

resource "kubernetes_secret_v1" "gitlab_redis" {
    metadata {
        name = "gitlab-redis-secret"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        password = digitalocean_database_cluster.valkey.password
    }

    type = "Opaque"
}

resource "kubernetes_secret_v1" "gitlab_s3_main" {
    metadata {
        name = "gitlab-s3-main-secret"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        connection = yamlencode({
            provider = "AWS"
            region = var.region
            endpoint = var.cloudflare_r2_endpoint
            aws_access_key_id = var.cloudflare_account_id
            aws_secret_access_key = var.cloudflare_api_token
            path_style = true
        })
    }

    type = "Opaque"
}

# resource "kubernetes_secret_v1" "gitlab_s3_registry" {
#     metadata {
#         name = "gitlab-s3-registry-secret"
#         namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
#     }

#     data = {
#         connection = yamlencode({
#            accesskey = var.spaces_access_id
#            secretkey = var.spaces_secret_key
#            region = var.region
#            regionendpoint = ${{ secrets.R2_ACCESS_KEY_ID }}
#            bucket = digitalocean_spaces_bucket.gitlab["registry"].name
#         })
#     }

#     type = "Opaque"
# }

resource "kubernetes_secret_v1" "gitlab_s3_backup" {
    metadata {
        name = "gitlab-s3-backup-secret"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        connection = yamlencode({
            provider = "AWS"
            region = var.region
            endpoint = var.cloudflare_r2_endpoint
            aws_access_key_id = var.cloudflare_account_id
            aws_secret_access_key = var.cloudflare_api_token
            path_style = true
        })
    }

    type = "Opaque"
}

resource "kubernetes_secret_v1" "gitlab_sendgrid_secret" {
    metadata {
        name = "gitlab-sendgrid-secret"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        password = var.sendgrid_api_key
    }

    type = "Opaque"
}

resource "time_sleep" "wait_for_gateway" {
    depends_on = [ helm_release.envoy_gateway ]
    create_duration = "120s"
}

data "kubernetes_service_v1" "envoy_gateway" {
    metadata {
        name = "gateway"
        namespace = kubernetes_namespace_v1.envoy_gateway_system.metadata[0].name
    }

    depends_on = [ time_sleep.wait_for_gateway ]
}