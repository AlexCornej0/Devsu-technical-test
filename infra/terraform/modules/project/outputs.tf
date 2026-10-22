output "project_id" {
  description = "Project ID."
  value       = google_project.this.project_id
  depends_on  = [google_project_service.this]
}

output "number" {
  description = "Project number."
  value       = google_project.this.number
}