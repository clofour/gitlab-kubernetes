resource "helm_release" "ingress_nginx" {
    name = "ingress-nginx"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart = "ingress-nginx"
    version = "4.15.1"

    values = [
        file("${path.module}/../helm/ingress-nginx/values.yaml")
    ]
}

resource "helm_release" "cert_manager" {
    name = "cert-manager"
    namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name
    repository = "oci://quay.io/jetstack/charts"
    chart = "cert-manager"
    version = "1.20.2"

    values = [
        file("${path.module}/../helm/cert-manager/values.yaml")
    ]
}

resource "helm_release" "gitlab" {
    name = "gitlab"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    repository = "https://charts.gitlab.io/"
    chart = "gitlab"
    version = "9.10.3"

    values = [
        templatefile("${path.module}/../helm/gitlab/values.yaml", {
            domain = var.domain_name
            gitlab_host = var.gitlab_host
            registry_host = var.registry_host
            postgres_host = digitalocean_database_cluster.postgres.private_host
            postgres_port = digitalocean_database_cluster.postgres.port
            postgres_database = digitalocean_database_db.gitlab.name
            postgres_username = digitalocean_database_user.gitlab.name
            redis_host = digitalocean_database_cluster.valkey.private_host
            redis_port = digitalocean_database_cluster.valkey.port
            buckets = {for key, bucket in digitalocean_spaces_bucket.gitlab : key => bucket.name}
        })
    ]

    depends_on = [
        kubernetes_secret_v1.gitlab_initial_root_password,
        kubernetes_secret_v1.gitlab_postgres,
        kubernetes_secret_v1.gitlab_redis,
        kubernetes_secret_v1.gitlab_s3_main,
        digitalocean_database_db.gitlab
    ]
}