variable "org_id" {
  description = "Organization ID. Null: no folders or policies, projects without a parent"
  type        = string
  default     = null
}

variable "billing_account" {
  description = "Billing account ID linked to every project"
  type        = string
}

variable "seed_project_id" {
  description = "Seed project"
  type        = string
}

variable "folders" {
  description = "Folders under the organization"
  type = map(object({
    display_name = string
  }))
  default = {}
}

variable "folder_boolean_policies" {
  description = "Boolean organization policy constraints enforced on every folder"
  type        = set(string)
  default     = []
}

variable "projects" {
  description = "Projects to create, by key"
  type = map(object({
    name          = string
    folder        = optional(string)
    budget_amount = optional(number)
    apis          = set(string)
    labels        = optional(map(string), {})
  }))

  validation {
    condition     = alltrue([for p in var.projects : length(p.name) <= 25])
    error_message = "Project names must be at most 25 chars (the 5-char suffix makes 30, the GCP limit)."
  }
}