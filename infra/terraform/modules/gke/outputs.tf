output "cluster_name" {
  description = "Cluster name."
  value       = google_container_cluster.this.name
}

output "location" {
  description = "Cluster zone."
  value       = google_container_cluster.this.location
}

output "node_service_account" {
  description = "Email of the node service account."
  value       = google_service_account.nodes.email
}