# Ingress controller behind a regional load balancer with the reserved static IP
resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = var.traefik_chart_version
  namespace  = kubernetes_namespace_v1.this["traefik"].metadata[0].name
  timeout    = 600

  values = [yamlencode({
    service = {
      spec = {
        loadBalancerIP = local.platform.ingress_ip
      }
    }
  })]
}