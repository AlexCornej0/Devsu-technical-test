resource "google_iam_workload_identity_pool" "this" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = "GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "this" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.this.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-oidc"
  display_name                       = "GitHub OIDC"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  # Tokens from any other repository are rejected before any IAM binding is evaluated
  attribute_condition = "assertion.repository == \"${var.repository}\""

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "deployer" {
  for_each = var.environments

  project      = var.project_id
  account_id   = "deployer-${each.key}"
  display_name = "GitHub Actions deployer (${each.key})"
}

# Only lets the deployer fetch cluster credentials
resource "google_project_iam_member" "cluster_viewer" {
  for_each = var.environments

  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "serviceAccount:${google_service_account.deployer[each.key].email}"
}

# Only a job running in the GitHub Environment <env> of this repository can impersonate deployer-<env>
resource "google_service_account_iam_member" "workload_identity_user" {
  for_each = var.environments

  service_account_id = google_service_account.deployer[each.key].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/subject/repo:${var.repository}:environment:${each.key}"
}