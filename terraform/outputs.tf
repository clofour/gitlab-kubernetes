output "kubeconfig" {
    value = digitalocean_kubernetes_cluster.main.kube_config[0].raw_config
    sensitive = true
}

output "gitlab_initial_root_password" {
    value = random_password.gitlab_root.result
    sensitive = true
}


output "postgres_host" {
    value = digitalocean_database_cluster.postgres.private_host
}

output "postgres_port" {
    value = digitalocean_database_cluster.postgres.port
}

output "postgres_user" {
    value = digitalocean_database_user.gitlab.name
}

output "postgres_password" {
    value = digitalocean_database_user.gitlab.password
    sensitive = true
}


output "valkey_host" {
    value = digitalocean_database_cluster.valkey.private_host
}

output "valkey_port" {
    value = digitalocean_database_cluster.valkey.port
}

output "valkey_password" {
    value = digitalocean_database_cluster.valkey.password
    sensitive = true
}


output "spaces_endpoint" {
    value = "${var.region}.digitaloceanspaces.com"
}

output "spaces_buckets" {
    value = { for k, b in cloudflare_r2_bucket.gitlab : k => b.name }
}