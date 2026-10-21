variable "project_id" {
  description = "Project that owns the pool and the deployer accounts."
  type        = string
}

variable "repository" {
  description = "GitHub repository allowed to authenticate, as owner/name (case-sensitive)."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+/[A-Za-z0-9._-]+$", var.repository))
    error_message = "repository must look like owner/name."
  }
}

variable "environments" {
  description = "GitHub Environments that deploy. Each one gets its own deployer service account."
  type        = set(string)

  validation {
    condition     = alltrue([for e in var.environments : can(regex("^[a-z]+$", e))])
    error_message = "Environment names must be lowercase letters only (they become part of account IDs)."
  }
}

variable "pool_id" {
  description = "Workload Identity Pool ID."
  type        = string
  default     = "github"
}