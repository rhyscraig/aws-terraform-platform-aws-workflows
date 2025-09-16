resource "aws_organizations_account" "baseline" {
  name      = var.account_name
  email     = "${var.account_name}@company.com"
  parent_id = var.target_ou_id
  role_name = "OrganizationAccountAccessRole"
}

output "account_id" { value = aws_organizations_account.baseline.id }
output "resources" { value = { iam_roles = [aws_organizations_account.baseline.role_name] } }
output "status" { value = "CREATED" }
