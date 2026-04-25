locals {
    buckets = toset([
        "artifacts", "lfs", "uploads", "packages",
        "registry", "pages", "backups", "tmp", "ci-secure-files",
        "dependency-proxy", "terraform-state"
    ])
}

resource "random_id" "suffix" {
    byte_length = 3
}

resource "cloudflare_r2_bucket" "gitlab" {
    for_each = local.buckets
    account_id = var.cloudflare_account_id
    name = "${var.cluster_name}-${each.key}-${random_id.suffix.hex}"
    jurisdiction = var.r2_jurisdiction
    lifecycle {
      prevent_destroy = true
    }
}