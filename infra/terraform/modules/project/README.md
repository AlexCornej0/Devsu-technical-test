# Module `project`

Project with billing, APIs and an optional monthly budget (alerts at 50, 90 and 100 %).

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `project_id` | `string` | required | Globally unique project ID (6-30 chars, lowercase letters, digits and hyphens). |
| `name` | `string` | required | Display name of the project. |
| `org_id` | `string` | `null` | Organization ID. Used only when folder_id is null. |
| `folder_id` | `string` | `null` | Numeric folder ID (without the folders/ prefix). Null puts the project directly under org_id. |
| `billing_account` | `string` | required | Billing account ID (XXXXXX-XXXXXX-XXXXXX). |
| `apis` | `set(string)` | `[]` | APIs to enable, e.g. container.googleapis.com. |
| `labels` | `map(string)` | `{}` | Labels applied to the project. |
| `budget_amount` | `number` | `null` | Monthly budget in the billing account currency. Null creates no budget. |

## Outputs

| Name | Description |
| --- | --- |
| `project_id` | Project ID. |
| `number` | Project number. |