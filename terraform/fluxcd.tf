resource "flux_bootstrap_git" "flux_cd" {
    path = "flux"
}

resource "kubernetes_config_map_v1" "runtime_config" {
    metadata {
        name = "runtime-config"
        namespace = "flux-system"
    }

    data = {
        domain = var.domain_name
        gitlab_host = var.gitlab_host
        registry_host = var.registry_host
        pages_host = var.pages_host
        email = var.email
        cluster_name = var.cluster_name
        
        postgres_host = digitalocean_database_connection_pool.main.private_host
        postgres_port = digitalocean_database_connection_pool.main.port
        postgres_database = digitalocean_database_db.gitlab.name
        postgres_username = digitalocean_database_cluster.postgres.user
        redis_host = digitalocean_database_cluster.valkey.private_host
        redis_port = digitalocean_database_cluster.valkey.port
        buckets = {for key, bucket in cloudflare_r2_bucket.gitlab : key => bucket.name}
    }
}