# Module `github-wif`

Workload Identity Federation for GitHub Actions: one pool and OIDC provider restricted to one repository, and one deployer service account per GitHub Environment.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `project_id` | `string` | required | Project that owns the pool and the deployer accounts. |
| `repository` | `string` | required | GitHub repository allowed to authenticate, as owner/name (case-sensitive). |
| `environments` | `set(string)` | required | GitHub Environments that deploy. Each one gets its own deployer service account. |
| `pool_id` | `string` | `github` | Workload Identity Pool ID. |

## Outputs

| Name | Description |
| --- | --- |
| `provider_name` | Full provider name, the workload_identity_provider input of google-github-actions/auth. |
| `deployer_emails` | Deployer service account email per environment. |