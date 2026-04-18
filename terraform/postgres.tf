resource "digitalocean_database_cluster" "postgres" {
    name = "${var.cluster_name}-postgres"
    engine = "pg"
    version = 17
    size = "db-s-1vcpu-1gb"
    region = var.region
    node_count = 1
    private_network_uuid = digitalocean_vpc.main.id
}

resource "digitalocean_database_postgresql_config" "postgres" {
    cluster_id = digitalocean_database_cluster.postgres.id
    max_locks_per_transaction = 256
}

resource "digitalocean_database_db" "gitlab" {
    cluster_id = digitalocean_database_cluster.postgres.id
    name = "gitlab"
}

resource "digitalocean_database_user" "gitlab" {
    cluster_id = digitalocean_database_cluster.postgres.id
    name = "gitlab"
}

resource "digitalocean_database_connection_pool" "main" {
    cluster_id = digitalocean_database_cluster.postgres.id
    name = "gitlab"
    mode = "transaction"
    size = 10
    db_name = digitalocean_database_cluster.postgres.database
}

resource "digitalocean_database_firewall" "postgres" {
    cluster_id = digitalocean_database_cluster.postgres.id
    rule {
        type = "k8s"
        value = digitalocean_kubernetes_cluster.main.id
    }
}