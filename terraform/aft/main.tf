module "baseline_account" {
  source        = "./modules/baseline"
  account_name  = var.requested_account_name
  target_ou_id  = var.target_ou_id
  oidc_role_arn = var.github_oidc_role_arn
}

module "pre_hooks" {
  source = "./modules/custom-hooks"
  account_name = var.requested_account_name
  phase        = "pre"
}

module "post_hooks" {
  source = "./modules/custom-hooks"
  account_name = var.requested_account_name
  phase        = "post"
}
