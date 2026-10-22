# Module `network`

Custom-mode VPC, one subnet with secondary ranges for GKE pods and services, and a regional static IP for the ingress.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `project_id` | `string` | required | Project that owns the network. |
| `region` | `string` | required | Region of the subnet and of the static IP. |
| `name` | `string` | required | Base name for the VPC, the subnet and the IP. |
| `subnet_cidr` | `string` | required | Primary range of the subnet (nodes). |
| `pods_cidr` | `string` | required | Secondary range for pods (VPC-native GKE). |
| `services_cidr` | `string` | required | Secondary range for ClusterIP services. |

## Outputs

| Name | Description |
| --- | --- |
| `network_id` | VPC ID. |
| `subnet_id` | Subnet ID. |
| `pods_range_name` | Name of the secondary range for pods. |
| `services_range_name` | Name of the secondary range for services. |
| `ingress_ip` | Static external IP for the ingress controller. |