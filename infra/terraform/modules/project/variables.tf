variable "project_id" {
  description = "Globally unique project ID "
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be 6-30 chars, start with a letter and contain only lowercase letters, digits and hyphens."
  }
}

variable "name" {
  description = "Display name of the project."
  type        = string
}

variable "org_id" {
  description = "Organization ID."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Numeric folder ID"
  type        = string
  default     = null
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "apis" {
  description = "APIs to enable"
  type        = set(string)
  default     = []
}

variable "labels" {
  description = "Labels applied to the project."
  type        = map(string)
  default     = {}
}

variable "budget_amount" {
  description = "Monthly budget in the billing account currency."
  type        = number
  default     = null

  validation {
    condition     = var.budget_amount == null || try(var.budget_amount > 0, false)
    error_message = "budget_amount must be null or greater than 0."
  }
}