package main

# Enforce Mandatory Tags
deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions[_] == "create"
  tags := resource.change.after.tags
  not tags.Owner
  msg := sprintf("Resource '%v' is missing mandatory tag: Owner", [resource.address])
}

deny[msg] {
  resource := input.resource_changes[_]
  resource.change.actions[_] == "create"
  tags := resource.change.after.tags
  not tags.CostCenter
  msg := sprintf("Resource '%v' is missing mandatory tag: CostCenter", [resource.address])
}
