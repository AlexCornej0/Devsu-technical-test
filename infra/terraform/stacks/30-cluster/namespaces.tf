resource "kubernetes_namespace_v1" "this" {
  for_each = toset(concat(["traefik"], local.platform.environments))

  metadata {
    name = each.key
    labels = {
      "app.kubernetes.io/part-of" = "portfolio"
    }
  }
}