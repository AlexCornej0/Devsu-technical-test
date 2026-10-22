variable "state_bucket" {
  description = "Bucket with the Terraform state"
  type        = string
}

variable "project_key" {
  description = "Key of the project"
  type        = string
  default     = "platform"
}

variable "region" {
  description = "Region of the network and the static IP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone of the cluster"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "portfolio-gke"
}

variable "machine_type" {
  description = "Node machine type"
  type        = string
  default     = "e2-standard-2"
}

variable "network" {
  description = "VPC name and CIDR ranges"
  type = object({
    name          = string
    subnet_cidr   = string
    pods_cidr     = string
    services_cidr = string
  })
  default = {
    name          = "portfolio-vpc"
    subnet_cidr   = "10.10.0.0/24"
    pods_cidr     = "10.20.0.0/16"
    services_cidr = "10.30.0.0/20"
  }
}

variable "github_repository" {
  description = "Repository allowed to deploy, owner/name"
  type        = string
}

variable "environments" {
  description = "Deployment environments"
  type = map(object({
    host_prefix = string
  }))
}