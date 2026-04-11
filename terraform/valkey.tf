resource "digitalocean_database_cluster" "valkey" {
    name = "${var.cluster_name}-valkey"
    engine = "valkey"
    version = "8"
    size = "db-s-1vcpu-1gb"
    region = var.region
    node_count = 1
    private_network_uuid = digitalocean_vpc.main.id
    eviction_policy = "noeviction"
}

resource "digitalocean_database_firewall" "valkey" {
    cluster_id = digitalocean_database_cluster.valkey.id
    rule {
        type = "k8s"
        value = digitalocean_kubernetes_cluster.main.id
    }
}