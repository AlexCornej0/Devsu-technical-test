data "github_user" "prod_reviewer" {
  username = var.prod_reviewer
}

resource "github_repository_environment" "this" {
  for_each = var.environment_branches

  repository          = var.repository
  environment         = each.key
  prevent_self_review = false

  dynamic "reviewers" {
    for_each = each.key == "prod" ? [1] : []
    content {
      users = [data.github_user.prod_reviewer.id]
    }
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "this" {
  for_each = var.environment_branches

  repository     = var.repository
  environment    = github_repository_environment.this[each.key].environment
  branch_pattern = each.value
}