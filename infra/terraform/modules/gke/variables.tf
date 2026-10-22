variable "project_id" {
  description = "Project of the cluster."
  type        = string
}

variable "zone" {
  description = "Zone of the cluster"
  type        = string
}

variable "name" {
  description = "Cluster name"
  type        = string
}

variable "network_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "pods_range_name" {
  description = "Secondary range for pods"
  type        = string
}

variable "services_range_name" {
  description = "Secondary range for services"
  type        = string
}

variable "machine_type" {
  description = "Node machine type"
  type        = string
  default     = "e2-standard-2"
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.node_count >= 1
    error_message = "node_count must be at least 1."
  }
}

variable "maintenance_start" {
  description = "Start of the daily 4-hour"
  type        = string
  default     = "2026-01-01T08:00:00Z"
}