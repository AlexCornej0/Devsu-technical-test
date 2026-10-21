output "environments" {
  description = "GitHub Environments managed"
  value       = sort(keys(github_repository_environment.this))
}

output "repository_variables" {
  description = "Repository variables"
  value       = local.repo_variables
}