resource "kubernetes_namespace" "gitlab" {
    metadata {
      name = "gitlab"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "kubernetes_secret" "gitlab_postgres" {
    metadata {
        name = "gitlab-postgres-secret"
        namespace = kubernetes_namespace.gitlab.metadata[0].name
    }

    data = {
        password = digitalocean_database_user.gitlab.password
    }

    type = "Opaque"
}

resource "kubernetes_secret" "gitlab_redis" {
    metadata {
        name = "gitlab-redis-secret"
        namespace = kubernetes_namespace.gitlab.metadata[0].name
    }

    data = {
        password = digitalocean_database_user.gitlab.password
    }

    type = "Opaque"
}

resource "kubernetes_secret" "gitlab_s3_main" {
    metadata {
        name = "gitlab-s3-main-secret"
        namespace = kubernetes_namespace.gitlab.metadata[0].name
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

resource "kubernetes_secret" "gitlab_s3_registry" {
    metadata {
        name = "gitlab-s3-main-secret"
        namespace = kubernetes_namespace.gitlab.metadata[0].name
    }

    data = {
        connection = yamlencode({
           accesskey = var.spaces_access_id
           secretkey = var.spaces_secret_key
           region = var.region
           regionendpoint = "https://${var.region}.digitaloceanspaces.com"
           bucket = digitalocean_spaces_bucket.gitlab.registry.name
        })
    }

    type = "Opaque"
}

resource "kubernetes_secret" "gitlab_s3_backup" {
    metadata {
        name = "gitlab-s3-main-secret"
        namespace = kubernetes_namespace.gitlab.metadata[0].name
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