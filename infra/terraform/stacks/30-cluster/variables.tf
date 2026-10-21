variable "state_bucket" {
  description = "Bucket with the Terraform state"
  type        = string
}

variable "traefik_chart_version" {
  description = "Traefik Helm chart version"
  type        = string
  default     = "42.0.0"
}