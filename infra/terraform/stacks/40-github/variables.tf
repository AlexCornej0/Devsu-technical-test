variable "state_bucket" {
  description = "Bucket with the Terraform state"
  type        = string
}

variable "github_owner" {
  description = "Owner of the repository"
  type        = string
}

variable "repository" {
  description = "Repository name "
  type        = string
}

variable "environment_branches" {
  description = "GitHub Environment "
  type        = map(string)
}

variable "prod_reviewer" {
  description = "GitHub user who approves production deployments"
  type        = string
}

variable "required_checks" {
  description = "Job names that must be green before merging into a protected branch"
  type        = list(string)
}