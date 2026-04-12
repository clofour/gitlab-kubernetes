resource "digitalocean_database_cluster" "postgres" {
    name = "${var.cluster_name}-postgres"
    engine = "pg"
    version = 18
    size = "db-s-1vcpu-1gb"
    region = var.region
    node_count = 1
    private_network_uuid = digitalocean_vpc.main.id
}

resource "digitalocean_database_db" "gitlab" {
    cluster_id = digitalocean_database_cluster.postgres.id
    name = "gitlab"
}

resource "digitalocean_database_user" "gitlab" {
    cluster_id = digitalocean_database_cluster.postgres.id
    name = "gitlab"
}

resource "digitalocean_database_firewall" "postgres" {
    cluster_id = digitalocean_database_cluster.postgres.id
    rule {
        type = "k8s"
        value = digitalocean_kubernetes_cluster.main.id
    }
}