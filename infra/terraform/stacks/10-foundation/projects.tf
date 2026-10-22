# A deleted project ID stays reserved for 30 days: a random suffix allows destroy and re-create
resource "random_id" "project_suffix" {
  for_each = var.projects

  byte_length = 2
}

module "project" {
  source   = "../../modules/project"
  for_each = var.projects

  project_id      = "${each.value.name}-${random_id.project_suffix[each.key].hex}"
  name            = each.value.name
  org_id          = var.org_id
  folder_id       = each.value.folder == null ? null : trimprefix(google_folder.this[each.value.folder].name, "folders/")
  billing_account = var.billing_account
  apis            = each.value.apis
  budget_amount   = each.value.budget_amount
  labels          = merge({ managed-by = "terraform" }, each.value.labels)

  depends_on = [google_org_policy_policy.folder_boolean]
}