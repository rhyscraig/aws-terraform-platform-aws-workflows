# ⚡ reusable-workflows (aws-workflows)

**Classification:** Critical Platform Logic
**Owner:** Cloud Platform Team

This repository hosts the centralized **GitHub Actions** workflows for the AVM Platform.
All infrastructure repositories (`aws-org`, `aws-accounts`, `aws-baselines`) **MUST** consume these workflows to ensure security compliance.

---

## Architecture Flow

```text
Caller Repository
        ↓
reusable-static-analysis
        ↓
reusable-tf-plan
        ↓
reusable-tf-apply
```

---

## 🛡️ Security & Guardrails

These workflows enforce the **Defense-Grade** standard:
1.  **Clean Room Validation:** Static analysis runs *before* any AWS credentials are requested.
2.  **OIDC Authentication:** No long-lived AWS keys are ever stored in GitHub Secrets.
3.  **Immutable Actions:** All 3rd-party actions are pinned by SHA hash or stable major version tags.
4.  **Least Privilege:** Token permissions are scoped strictly to the job requirements.

---

## Golden Path Workflow

```yaml
jobs:
  lint:
    uses: org/ws-workflows/.github/workflows/reusable-static-analysis.yaml@v1

  plan:
    needs: lint
    uses: org/ws-workflows/.github/workflows/reusable-tf-plan.yaml@v1
```

---

## 📋 Available Workflows

### 1. `reusable-static-analysis.yaml`
**The "Gatekeeper".** Runs linting and security scans without credentials.
* **Usage:** Required as the first job in every pipeline.
* **Tools:** `terraform fmt`, `tflint`, `checkov` (offline mode).

```yaml
jobs:
  lint:
    uses: hoad-org/aws-workflows/.github/workflows/reusable-static-analysis.yaml@v0.0.2
    with:
      working-directory: "."
```

### 2. `reusable-tf-plan.yaml`
**The "Simulator".** Generates a plan and cost estimate.
* **Usage:** Runs on Pull Requests (after linting passes).
* **Inputs:** pre_plan_script (Optional) - For running assimilation/import scripts.
* **Outputs:** Uploads `tfplan` as an artifact.

```YAML

jobs:
  plan:
    needs: lint
    uses: hoad-org/aws-workflows/.github/workflows/reusable-tf-plan.yaml@v0.0.2
    with:
      env_name: "prod"
    secrets:
      OIDC_ROLE_ARN: ${{ secrets.AWS_OIDC_ROLE_ARN }}
      GH_PAT: ${{ secrets.GH_PAT }}
```

### 3. `reusable-tf-apply.yaml`
**The "Executor".** Applies changes to the cloud.
* **Usage:** Runs on merge to main.
* **Safety:** Downloads the exact `tfplan` generated in the previous step (if run in sequence) or regenerates it safely.

### 4. `reusable-drift-check.yaml`
**The "Detective".** Checks for configuration drift.
* **Usage:** Scheduled (Cron) triggers.
* **Behavior:** Fails if terraform plan detects changes not in code.

```YAML

on:
  schedule:
    - cron: '0 8 * * *' # Daily at 8am
jobs:
  drift:
    uses: hoad-org/aws-workflows/.github/workflows/reusable-drift-check.yaml@v0.0.2
    with:
      env_name: "prod"
```

### 5. `reusable-tagging.yaml`
**The "Historian".** Manages SemVer releases for modules.
* **Usage:** Called by aws-modules on merge to main.
* **Behavior:** Bumps version tag and generates a Changelog.

### 6. `reusable-tf-destroy.yaml`
**The "Nuclear Option".** Destroys infrastructure.
* **Usage:** Manual dispatch only.
* **Safety:** Requires environment approval in GitHub Settings.

## 📦 Setup Requirements
To use these workflows, the calling repository must have:

### Secrets:

`AWS_OIDC_ROLE_ARN`: The IAM Role that trusts the repo.

`GH_PAT`: Personal Access Token for cloning private tools (tfctl).

### Permissions:

`id-token`: write (For OIDC).

`contents`: read (For checkout).


### Non-Goals
- Not a general-purpose CI library
- Not intended for non-Terraform workloads
- Not compatible with static AWS credentials
