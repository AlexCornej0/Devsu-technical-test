data "terraform_remote_state" "platform" {
  backend = "gcs"
  config = {
    bucket = var.state_bucket
    prefix = "portfolio/20-platform"
  }
}

locals {
  platform = data.terraform_remote_state.platform.outputs
}