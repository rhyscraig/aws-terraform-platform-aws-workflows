package main

# Block Public S3 Buckets
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"
  resource.change.after.acl == "public-read"
  msg := sprintf("CRITICAL: S3 Bucket '%v' is publicly readable.", [resource.address])
}

# Block SG opening port 22 to world
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "aws_security_group_rule"
  resource.change.after.to_port == 22
  resource.change.after.cidr_blocks[_] == "0.0.0.0/0"
  msg := sprintf("CRITICAL: Security Group '%v' opens SSH to the world.", [resource.address])
}
