package main
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_security_group_rule"
  resource.change.after.to_port == 22
  resource.change.after.cidr_blocks[_] == "0.0.0.0/0"
  msg := sprintf("CRITICAL: Security Group Rule '%v' opens SSH to the world!", [resource.address])
}
