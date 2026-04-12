data "digitalocean_kubernetes_versions" "current" {
    version_prefix = var.k8s_version
}

resource "digitalocean_kubernetes_cluster" "main" {
    name = var.cluster_name
    region = var.region
    version = data.digitalocean_kubernetes_versions.current.latest_version
    vpc_uuid = digitalocean_vpc.main.id

    auto_upgrade = false
    surge_upgrade = true

    node_pool {
      name = "default"
      size = var.node_size
      node_count = var.node_count
      labels = { role = "general" }
    }
}