provider "google" {
  project               = local.platform.project_id
  billing_project       = local.platform.project_id
  user_project_override = true
}

data "google_client_config" "this" {}

data "google_container_cluster" "this" {
  project  = local.platform.project_id
  name     = local.platform.cluster_name
  location = local.platform.zone
}

locals {
  cluster_host = "https://${data.google_container_cluster.this.endpoint}"
  cluster_ca   = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
}

provider "kubernetes" {
  host                   = local.cluster_host
  token                  = data.google_client_config.this.access_token
  cluster_ca_certificate = local.cluster_ca
}

# helm provider 3.x: kubernetes is an attribute (= { }), not a block
provider "helm" {
  kubernetes = {
    host                   = local.cluster_host
    token                  = data.google_client_config.this.access_token
    cluster_ca_certificate = local.cluster_ca
  }
}