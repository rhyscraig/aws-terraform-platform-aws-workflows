module "baseline_account" {
  source = var.baseline_template

  account_name  = var.requested_account_name
  target_ou     = var.target_ou
  oidc_role_arn = var.github_oidc_role_arn
}

module "pre_hooks" {
  source = "./modules/hooks"

  account_name = var.requested_account_name
  phase        = "pre"
}

module "post_hooks" {
  source = "./modules/hooks"

  account_name = var.requested_account_name
  phase        = "post"
}
