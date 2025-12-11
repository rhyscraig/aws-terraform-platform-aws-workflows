# aws-workflows: The Pipeline

This repository contains the centralized CI/CD logic for the Cloud Platform.
All infrastructure repositories (`aws-org`, `aws-accounts`, `aws-baselines`) **MUST** consume these workflows.

## Workflows

### 1. `reusable-tf-plan.yaml`
* **Trigger:** Pull Requests.
* **Responsibility:** The "Hard Gate".
* **Actions:**
    * Installs `tfctl` and `awsctl` (v2.2.0+).
    * Authenticates via OIDC.
    * Runs `tfctl check --mode=ci` (Hard Fail on security/linting violations).
    * Runs `tfctl plan` and posts the output to the PR as a comment.

### 2. `reusable-tf-apply.yaml`
* **Trigger:** Merge to `main`.
* **Responsibility:** Deployment.
* **Actions:**
    * Waits for GitHub Environment Approval (if configured in Repo Settings).
    * Runs `tfctl apply`.
    * Enforces Production Branch guardrails (via `tfctl`).

## Usage Example

In your infrastructure repo (e.g., `aws-baselines/.github/workflows/deploy.yaml`):

```yaml
name: Deploy Baselines

on:
  push:
    branches: [main]
  pull_request:

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  plan:
    if: github.event_name == 'pull_request'
    # Reference the reusable workflow
    uses: your-org/aws-workflows/.github/workflows/reusable-tf-plan.yaml@v1.0.0
    with:
      working-directory: ./terraform/networking
      environment: dev
    secrets:
      OIDC_ROLE_ARN: ${{ secrets.AWS_OIDC_ROLE_ARN }}
      GH_PAT: ${{ secrets.GH_PAT }}

  apply:
    if: github.ref == 'refs/heads/main'
    uses: your-org/aws-workflows/.github/workflows/reusable-tf-apply.yaml@v1.0.0
    with:
      working-directory: ./terraform/networking
      # 'production' environment triggers manual approval if configured in GitHub
      environment: production
    secrets:
      OIDC_ROLE_ARN: ${{ secrets.AWS_OIDC_ROLE_ARN }}
      GH_PAT: ${{ secrets.GH_PAT }}
```

# Setup Requirements
* **Secrets**: The calling repository must have GH_PAT (Personal Access Token) available to clone the private tfctl/awsctl tools.

* **OIDC**: The OIDC_ROLE_ARN must be trusted by the aws-workflows repository (or the calling repo, depending on AWS IAM trust policy configuration).

* **Runner**: Ubuntu Latest is assumed.