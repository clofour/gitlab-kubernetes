resource "kubernetes_namespace_v1" "ingress_nginx" {
    metadata {
      name = "ingress-nginx"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "kubernetes_namespace_v1" "cert_manager" {
    metadata {
      name = "cert-manager"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "kubernetes_namespace_v1" "gitlab" {
    metadata {
      name = "gitlab"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "random_password" "gitlab_root" {
    length = 64
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
        password = digitalocean_database_user.gitlab.password
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
            endpoint = "https://${var.region}.digitaloceanspaces.com"
            aws_access_key_id = var.spaces_access_id
            aws_secret_access_key = var.spaces_secret_key
            path_style = true
        })
    }

    type = "Opaque"
}

resource "kubernetes_secret_v1" "gitlab_s3_registry" {
    metadata {
        name = "gitlab-s3-registry-secret"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        connection = yamlencode({
           accesskey = var.spaces_access_id
           secretkey = var.spaces_secret_key
           region = var.region
           regionendpoint = "https://${var.region}.digitaloceanspaces.com"
           bucket = digitalocean_spaces_bucket.gitlab["registry"].name
        })
    }

    type = "Opaque"
}

resource "kubernetes_secret_v1" "gitlab_s3_backup" {
    metadata {
        name = "gitlab-s3-backup-secret"
        namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    }

    data = {
        connection = yamlencode({
            provider = "AWS"
            region = var.region
            endpoint = "https://${var.region}.digitaloceanspaces.com"
            aws_access_key_id = var.spaces_access_id
            aws_secret_access_key = var.spaces_secret_key
            path_style = true
        })
    }

    type = "Opaque"
}

resource "time_sleep" "wait_for_lb" {
    depends_on = [ helm.release.ingress_nginx ]
    create_duration = "120s"
}

data "kubernetes_service_v1" "ingress_nginx" {
    metadata {
        name = "ingress-nginx-controller"
        namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
    }

    depends_on = [ time_sleep.wait_for_lb ]
}