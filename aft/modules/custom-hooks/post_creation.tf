variable "account_name" { type = string }
variable "phase" { type = string }

resource "null_resource" "post_hook" {
  triggers = {
    account = var.account_name
    phase   = var.phase
  }

  provisioner "local-exec" {
    command = "echo Running post-creation hooks for ${var.account_name}"
  }
}
