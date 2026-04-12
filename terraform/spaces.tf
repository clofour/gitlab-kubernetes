locals {
    buckets = toset([
        "artifacts", "lfs", "uploads", "packages",
        "registry", "backups", "tmp", "ci-secure-files",
        "dependency-proxy", "terraform-state", "pages"
    ])
}

resource "random_id" "suffix" {
    byte_length = 3
}

resource "digitalocean_spaces_bucket" "gitlab" {
    for_each = local.buckets
    name = "${var.cluster_name}-${each.key}-${random_id.suffix.hex}"
    region = var.region
    acl = "private"
}