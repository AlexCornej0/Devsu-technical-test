module "network" {
  source = "../../modules/network"

  project_id    = local.project_id
  region        = var.region
  name          = var.network.name
  subnet_cidr   = var.network.subnet_cidr
  pods_cidr     = var.network.pods_cidr
  services_cidr = var.network.services_cidr
}

module "gke" {
  source = "../../modules/gke"

  project_id          = local.project_id
  zone                = var.zone
  name                = var.cluster_name
  network_id          = module.network.network_id
  subnet_id           = module.network.subnet_id
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
  machine_type        = var.machine_type
}

module "github_wif" {
  source = "../../modules/github-wif"

  project_id   = local.project_id
  repository   = var.github_repository
  environments = toset(keys(var.environments))
}