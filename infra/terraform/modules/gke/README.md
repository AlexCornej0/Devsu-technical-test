# Module `gke`

Zonal VPC-native GKE Standard cluster (Dataplane V2, Workload Identity, Shielded Nodes) with a separately managed node pool and a dedicated node service account.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `project_id` | `string` | required | Project of the cluster. |
| `zone` | `string` | required | Zone of the cluster. Zonal: the GKE free tier covers one zonal cluster per billing account. |
| `name` | `string` | required | Cluster name. |
| `network_id` | `string` | required | VPC ID. |
| `subnet_id` | `string` | required | Subnet ID. |
| `pods_range_name` | `string` | required | Secondary range for pods. |
| `services_range_name` | `string` | required | Secondary range for services. |
| `machine_type` | `string` | `e2-standard-2` | Node machine type. |
| `node_count` | `number` | `1` | Number of nodes. One node, because the SQLite volume is ReadWriteOnce (all pods must share the node). |
| `maintenance_start` | `string` | `2026-01-01T08:00:00Z` | Start of the daily 4-hour maintenance window (RFC 3339, UTC). Only the time of day matters. |

## Outputs

| Name | Description |
| --- | --- |
| `cluster_name` | Cluster name. |
| `location` | Cluster zone. |
| `node_service_account` | Email of the node service account. |