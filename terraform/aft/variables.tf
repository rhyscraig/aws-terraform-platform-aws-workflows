variable "requested_account_name" { type = string, default = "dev-test" }
variable "target_ou_id" { type = string, default = "Development" }
variable "github_oidc_role_arn" { type = string }
variable "baseline_template" { type = string, default = "./modules/baseline" }
