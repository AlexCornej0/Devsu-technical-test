output "projects" {
  description = "Project ID by key."
  value       = { for key, p in module.project : key => p.project_id }
}

output "folders" {
  description = "Folder resource name (folders/<id>) by key."
  value       = { for key, f in google_folder.this : key => f.name }
}