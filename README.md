# AVM Accounts

## Overview
This repository contains Terraform **account blueprints, request pipelines, and provisioning hooks**. It consolidates:
- `avm-account-baselines`
- `avm-account-requests`
- `avm-account-provisioning-hooks`

---

## Contents
- **Account Baselines**
  - Terraform modules for new account baselines.
- **Account Requests**
  - Terraform modules for requesting new accounts.
- **Provisioning Hooks**
  - Pre-account creation validation logic.

---

## Inputs
| Variable | Description | Example |
|----------|-------------|---------|
| `baseline_template` | Terraform module for baseline accounts | `avm-account-baselines` |
| `requested_account_name` | Name of account to create | `dev-test` |
| `target_ou` | OU to place new account in | `Development` |
| `github_oidc_roles` | Roles for pipeline authentication | From `avm-bootstrap` outputs |

---

## Outputs
| Output | Description |
|--------|-------------|
| `account_id` | AWS Account ID of newly created account |
| `baseline_resources` | List of resources provisioned in baseline |
| `provisioning_status` | Status of account creation checks |

---

## Terraform AFT & Control Tower
- **AFT definitions** live here:
  - Account Factory pipelines (`aws_organizations_account`) or AFT modules.
- **Control Tower itself is not deployed from this repo**, but AFT uses the foundational OU/landing zone from `avm-platform`.

---

## Deployment Order
1. `avm-bootstrap` for OIDC and Terraform state.
2. `avm-platform` for foundational infra.
3. Deploy accounts via `avm-accounts`.

---

## Notes
- This repo consolidates multiple previously separate account-related repos for simplicity.
- GitHub Actions is the only required CI/CD tool.
