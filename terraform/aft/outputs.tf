output "account_id" { value = module.baseline_account.account_id }
output "baseline_resources" { value = module.baseline_account.resources }
output "provisioning_status" {
  value = {
    pre_hooks  = module.pre_hooks.status
    post_hooks = module.post_hooks.status
  }
}
