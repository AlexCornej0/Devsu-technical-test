variable "org_id" {
  description = "Organization ID (gcloud organizations list)"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID (gcloud billing accounts list)"
  type        = string
}

variable "seed_project_id" {
  description = "Seed project created by hand with gcloud. Terraform imports it"
  type        = string
}

variable "seed_project_name" {
  description = "Display name of the seed project"
  type        = string
  default     = "portfolio-seed"
}

variable "admin_email" {
  description = "Google account. Receives the organization roles Terraform needs in the next stacks"
  type        = string
}

variable "region" {
  description = "Region of the state bucket"
  type        = string
  default     = "us-central1"
}