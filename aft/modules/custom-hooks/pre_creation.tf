variable "account_name" { type = string }
variable "phase" { type = string }

resource "null_resource" "pre_hook" {
  triggers = {
    account = var.account_name
    phase   = var.phase
  }

  provisioner "local-exec" {
    command = "echo Running pre-creation hooks for ${var.account_name}"
  }
}
