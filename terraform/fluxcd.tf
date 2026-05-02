resource "kubernetes_config_map_v1" "runtime_values" {
    metadata {
        name = "runtime-values"
        namespace = "flux-system"
    }

    data = {
        domain = var.domain_name
        gitlab_host = var.gitlab_host
        registry_host = var.registry_host
        pages_host = var.pages_host
        grafana_host = var.grafana_host
        email = var.email
        cluster_name = var.cluster_name
        
        postgres_host = digitalocean_database_connection_pool.main.private_host
        postgres_port = digitalocean_database_connection_pool.main.port
        postgres_database = digitalocean_database_db.gitlab.name
        postgres_username = digitalocean_database_cluster.postgres.user
        redis_host = digitalocean_database_cluster.valkey.private_host
        redis_port = digitalocean_database_cluster.valkey.port
        buckets_artifacts = cloudflare_r2_bucket.gitlab["artifacts"].name
        buckets_uploads = cloudflare_r2_bucket.gitlab["uploads"].name
        buckets_packages = cloudflare_r2_bucket.gitlab["packages"].name
        buckets_lfs = cloudflare_r2_bucket.gitlab["lfs"].name
        buckets_registry = cloudflare_r2_bucket.gitlab["registry"].name
        buckets_pages = cloudflare_r2_bucket.gitlab["pages"].name
        buckets_ci_secure_files = cloudflare_r2_bucket.gitlab["ci-secure-files"].name
    }

    depends_on = [ kubernetes_namespace_v1.flux_system ]
}

resource "flux_bootstrap_git" "flux_cd" {
    path = "flux"
}