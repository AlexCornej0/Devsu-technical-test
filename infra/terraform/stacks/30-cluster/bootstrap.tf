resource "helm_release" "bootstrap" {
  for_each = toset(local.platform.environments)

  name      = "bootstrap"
  chart     = "${path.root}/../../../../k8s/bootstrap"
  namespace = kubernetes_namespace_v1.this[each.key].metadata[0].name

  values = [yamlencode({
    deployer = local.platform.deployer_sa_emails[each.key]
  })]

  wait = false
}