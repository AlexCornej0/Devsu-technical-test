resource "google_project" "this" {
  project_id      = var.project_id
  name            = var.name
  org_id          = var.folder_id == null ? var.org_id : null
  folder_id       = var.folder_id
  billing_account = var.billing_account
  labels          = var.labels

  auto_create_network = false
  # A test environment must be destroyable
  deletion_policy = "DELETE"
}

resource "google_project_service" "this" {
  for_each = var.apis

  project = google_project.this.project_id
  service = each.value

  # Disabling an API on destroy can break other resources
  disable_on_destroy = false
}

resource "google_billing_budget" "this" {
  count = var.budget_amount == null ? 0 : 1

  billing_account = var.billing_account
  display_name    = "${var.project_id} monthly budget"

  budget_filter {
    projects = ["projects/${google_project.this.number}"]
  }

  amount {
    specified_amount {
      # currency_code omitted on purpose
      units = tostring(var.budget_amount)
    }
  }

  # Emails the billing admins at 50%,90 % and 100% of the budget
  dynamic "threshold_rules" {
    for_each = [0.5, 0.9, 1.0]
    content {
      threshold_percent = threshold_rules.value
    }
  }
}