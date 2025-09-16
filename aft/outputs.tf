output "account_id" {
  value       = module.baseline_account.account_id
  description = "AWS Account ID of the newly created account"
}

output "baseline_resources" {
  value       = module.baseline_account.resources
  description = "Resources deployed in baseline module"
}

output "provisioning_status" {
  value       = module.baseline_account.status
  description = "Provisioning phase status"
}
