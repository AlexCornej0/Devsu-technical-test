locals {
  repo_variables = {
    GCP_PROJECT_ID = local.platform.project_id
    GKE_CLUSTER    = local.platform.cluster_name
    GKE_LOCATION   = local.platform.zone
    WIF_PROVIDER   = local.platform.wif_provider
    PROD_URL       = "http://${local.platform.app_hosts["prod"]}"
  }
}

resource "github_actions_variable" "repo" {
  for_each = local.repo_variables

  repository    = var.repository
  variable_name = each.key
  value         = each.value
}

resource "github_actions_environment_variable" "deployer_sa" {
  for_each = var.environment_branches

  repository    = var.repository
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "DEPLOYER_SA"
  value         = local.platform.deployer_sa_emails[each.key]
}

resource "github_actions_environment_variable" "app_host" {
  for_each = var.environment_branches

  repository    = var.repository
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "APP_HOST"
  value         = local.platform.app_hosts[each.key]
}

resource "random_password" "django_secret_key" {
  for_each = var.environment_branches

  length  = 64
  special = false
}

resource "github_actions_environment_secret" "django_secret_key" {
  for_each = var.environment_branches

  repository      = var.repository
  environment     = github_repository_environment.this[each.key].environment
  secret_name     = "DJANGO_SECRET_KEY"
  plaintext_value = random_password.django_secret_key[each.key].result
}

resource "github_repository_ruleset" "protected_branches" {
  name        = "protected-branches"
  repository  = var.repository
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = [for branch in distinct(values(var.environment_branches)) : "refs/heads/${branch}"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      required_approving_review_count = 0
    }

    required_status_checks {
      dynamic "required_check" {
        for_each = var.required_checks
        content {
          context = required_check.value
        }
      }
    }
  }
}