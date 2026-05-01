resource "kubernetes_namespace_v1" "argo_cd" {
    metadata {
        name = "argo-cd"
    }

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}

resource "helm_release" "argo_cd" {
    name = "argo-cd"
    namespace = kubernetes_namespace_v1.argo_cd.metadata[0].name
    repository = "https://argoproj.github.io/argo-helm"
    chart = "argo-cd"
    version = "9.5.9"

    values = [
        file("${path.module}/../values.yaml")
    ]

    depends_on = [ digitalocean_kubernetes_cluster.main ]
}