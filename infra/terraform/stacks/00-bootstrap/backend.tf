# The bucket is passed at init time: terraform init -backend-config="bucket=<state bucket>"
# First run only
terraform {
  backend "gcs" {
    prefix = "portfolio/00-bootstrap"
  }
}