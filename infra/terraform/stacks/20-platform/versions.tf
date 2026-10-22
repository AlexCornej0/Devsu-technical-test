terraform {
  required_version = ">= 1.9"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.7"
    }
  }

  backend "gcs" {
    prefix = "portfolio/20-platform"
  }
}
