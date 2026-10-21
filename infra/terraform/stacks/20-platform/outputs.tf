output "project_id" {
  description = "Platform project ID"
  value       = local.project_id
}

output "region" {
  description = "Region"
  value       = var.region
}

output "zone" {
  description = "Cluster zone"
  value       = module.gke.location
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.cluster_name
}

output "ingress_ip" {
  description = "Static IP of the ingress controller"
  value       = module.network.ingress_ip
}

output "environments" {
  description = "Environment names"
  value       = sort(keys(var.environments))
}

output "app_hosts" {
  description = "Public host per environment"
  value       = { for env, e in var.environments : env => "${e.host_prefix}.${module.network.ingress_ip}.nip.io" }
}

output "wif_provider" {
  description = "workload_identity_provider for google-github-actions/auth"
  value       = module.github_wif.provider_name
}

output "deployer_sa_emails" {
  description = "Deployer service account per environment"
  value       = module.github_wif.deployer_emails
}