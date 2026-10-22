import {
  to = google_project.seed
  id = "bspm-portfolio-devops"
}

resource "google_project" "seed" {
  project_id      = var.seed_project_id
  name            = var.seed_project_name
  org_id          = var.org_id
  billing_account = var.billing_account
  labels = {
    role       = "seed"
    managed-by = "terraform"
  }

  # Holds the state of every stack
  deletion_policy = "PREVENT"
}

# APIs the next stacks call with the seed as quota project
resource "google_project_service" "seed" {
  for_each = toset([
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "orgpolicy.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
  ])

  project            = google_project.seed.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "tfstate" {
  project       = google_project.seed.project_id
  name          = "${var.seed_project_id}-tfstate"
  location      = upper(var.region)
  storage_class = "STANDARD"
  force_destroy = false

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 10
      with_state         = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.seed]
}

# Organization Administrator can grant roles but cannot create folders, projects or policies by itself
resource "google_organization_iam_member" "admin" {
  for_each = toset([
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.projectCreator",
  ])

  org_id = var.org_id
  role   = each.value
  member = "user:${var.admin_email}"

  depends_on = [google_project_service.seed]
}