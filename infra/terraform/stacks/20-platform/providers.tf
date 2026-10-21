provider "google" {
  project = local.project_id
  region  = var.region
  zone    = var.zone

  billing_project       = local.project_id
  user_project_override = true
}