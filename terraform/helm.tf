resource "helm_release" "external_dns" {
    name = "external-dns"
    namespace = kubernetes_namespace_v1.external_dns.metadata[0].name
    repository = "https://kubernetes-sigs.github.io/external-dns"
    chart = "external-dns"
    version = "1.20.0"

    values = [
        file("${path.module}/../helm/external-dns/values.yaml")
    ]

    depends_on = [
        kubernetes_namespace_v1.external_dns.metadata[0].name, 
        kubernetes_secret_v1.external_dns_do_secret 
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

resource "helm_release" "cluster_issuer" {
    name = "cluster-issuer"
    namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name
    chart = "${path.module}/../helm/cluster-issuer/chart"

    values = [
        templatefile("${path.module}/../helm/cluster-issuer/values.yaml", 
        {
            email = var.email
        })
    ]

    depends_on = [helm_release.cert_manager]
}

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

resource "helm_release" "gitlab" {
    name = "gitlab"
    namespace = kubernetes_namespace_v1.gitlab.metadata[0].name
    repository = "https://charts.gitlab.io/"
    chart = "gitlab"
    version = "9.10.3"

    timeout = 1800
    wait = true
    wait_for_jobs = true

    values = [
        templatefile("${path.module}/../helm/gitlab/values.yaml", {
            domain = var.domain_name
            gitlab_host = var.gitlab_host
            registry_host = var.registry_host
            postgres_host = digitalocean_database_connection_pool.main.private_host
            postgres_port = digitalocean_database_connection_pool.main.port
            postgres_database = digitalocean_database_db.gitlab.name
            postgres_username = digitalocean_database_cluster.postgres.user
            redis_host = digitalocean_database_cluster.valkey.private_host
            redis_port = digitalocean_database_cluster.valkey.port
            buckets = {for key, bucket in digitalocean_spaces_bucket.gitlab : key => bucket.name}
        })
    ]

    depends_on = [
        digitalocean_database_cluster.postgres,
        digitalocean_database_postgresql_config.postgres,
        digitalocean_database_db.gitlab,
        digitalocean_database_user.gitlab,
        digitalocean_database_connection_pool.main,
        digitalocean_database_cluster.valkey,
        helm_release.cert_manager,
        helm_release.cluster_issuer,
        helm_release.ingress_nginx,
        digitalocean_record.gitlab,
        kubernetes_secret_v1.gitlab_initial_root_password,
        kubernetes_secret_v1.gitlab_postgres,
        kubernetes_secret_v1.gitlab_redis,
        kubernetes_secret_v1.gitlab_s3_main
    ]
}