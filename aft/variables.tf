variable "baseline_template" {
  description = "Module for baseline account resources"
  type        = string
  default     = "../modules/baseline"
}

variable "requested_account_name" {
  description = "Name of the account to create"
  type        = string
}

variable "target_ou" {
  description = "OU to place the new account"
  type        = string
}

variable "github_oidc_role_arn" {
  description = "OIDC Role ARN from avm-bootstrap"
  type        = string
}
