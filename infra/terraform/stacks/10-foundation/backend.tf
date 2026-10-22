# The bucket is passed at init time: terraform init -backend-config="bucket=<state bucket>"
terraform {
  backend "gcs" {
    prefix = "portfolio/10-foundation"
  }
}