data "terraform_remote_state" "foundation" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
    prefix = "portfolio/10-foundation"
  }
}

locals {
  project_id = data.terraform_remote_state.foundation.outputs.projects[var.project_key]
}