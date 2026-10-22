resource "google_folder" "this" {
  for_each = var.org_id == null ? {} : var.folders

  display_name = each.value.display_name
  parent       = "organizations/${var.org_id}"

  # Test environment
  deletion_protection = false
}

locals {
  folder_policies = var.org_id == null ? {} : {
    for pair in setproduct(keys(var.folders), var.folder_boolean_policies) :
    "${pair[0]}/${pair[1]}" => { folder = pair[0], constraint = pair[1] }
  }
}

resource "google_org_policy_policy" "folder_boolean" {
  for_each = local.folder_policies

  name   = "${google_folder.this[each.value.folder].name}/policies/${each.value.constraint}"
  parent = google_folder.this[each.value.folder].name

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}