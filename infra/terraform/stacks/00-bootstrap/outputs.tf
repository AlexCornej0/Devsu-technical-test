output "state_bucket" {
  description = "Bucket that stores the state of every stack."
  value       = google_storage_bucket.tfstate.name
}

output "seed_project_id" {
  description = "Seed project ID."
  value       = google_project.seed.project_id
}