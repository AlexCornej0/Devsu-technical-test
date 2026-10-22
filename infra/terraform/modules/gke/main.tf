resource "google_service_account" "nodes" {
  project      = var.project_id
  account_id   = "${var.name}-nodes"
  display_name = "GKE nodes of ${var.name}"
}

resource "google_project_iam_member" "nodes" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.nodes.email}"
}

resource "google_container_cluster" "this" {
  project  = var.project_id
  name     = var.name
  location = var.zone

  network    = var.network_id
  subnetwork = var.subnet_id

  # The node pool is managed below, so it can change without recreating the cluster
  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  # Dataplane V2 (eBPF) enforces NetworkPolicy without an extra add-on
  datapath_provider = "ADVANCED_DATAPATH"

  release_channel {
    channel = "REGULAR"
  }

  # Pods get their own identity instead of the node's
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Upgrades replace the only node
  maintenance_policy {
    recurring_window {
      start_time = var.maintenance_start
      end_time   = timeadd(var.maintenance_start, "4h")
      recurrence = "FREQ=DAILY"
    }
  }

  depends_on = [google_project_iam_member.nodes]
}

resource "google_container_node_pool" "this" {
  project    = var.project_id
  name       = "${var.name}-pool"
  location   = var.zone
  cluster    = google_container_cluster.this.name
  node_count = var.node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  # Surge upgrade: the new node is created before the old one is drained
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  node_config {
    machine_type    = var.machine_type
    image_type      = "COS_CONTAINERD"
    disk_type       = "pd-balanced"
    disk_size_gb    = 30
    service_account = google_service_account.nodes.email
    # Access is limited by IAM roles, not by scopes (Google's recommendation)
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      cluster = var.name
    }
  }
}