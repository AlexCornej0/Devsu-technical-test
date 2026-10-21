output "ingress_ip" {
  description = "Static IP of Traefik."
  value       = local.platform.ingress_ip
}

output "namespaces" {
  description = "Namespaces created."
  value       = sort(keys(kubernetes_namespace_v1.this))
}