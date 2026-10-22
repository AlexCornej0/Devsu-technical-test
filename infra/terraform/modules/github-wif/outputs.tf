output "provider_name" {
  description = "Full provider name, the workload_identity_provider input of google-github-actions/auth."
  value       = google_iam_workload_identity_pool_provider.this.name
}

output "deployer_emails" {
  description = "Deployer service account email per environment."
  value       = { for env, sa in google_service_account.deployer : env => sa.email }
}