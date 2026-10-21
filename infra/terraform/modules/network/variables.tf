variable "project_id" {
  description = "Project that owns the network."
  type        = string
}

variable "region" {
  description = "Region of the subnet and of the static IP."
  type        = string
}

variable "name" {
  description = "Base name for the VPC, the subnet and the IP."
  type        = string
}

variable "subnet_cidr" {
  description = "Primary range of the subnet (nodes)."
  type        = string

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "subnet_cidr must be a valid CIDR block."
  }
}

variable "pods_cidr" {
  description = "Secondary range for pods (VPC-native GKE)."
  type        = string

  validation {
    condition     = can(cidrhost(var.pods_cidr, 0))
    error_message = "pods_cidr must be a valid CIDR block."
  }
}

variable "services_cidr" {
  description = "Secondary range for ClusterIP services."
  type        = string

  validation {
    condition     = can(cidrhost(var.services_cidr, 0))
    error_message = "services_cidr must be a valid CIDR block."
  }
}