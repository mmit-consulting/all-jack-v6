# Terraform PoC: workspace-based testing with cloned remote state (S3 backend)

## Goal

Test changes from a feature branch **without touching the** `default` **workspace state**, by:

- creating a dedicated workspace
- cloning `default` state into it
- applying changes
- destroying PoC changes
- merging PR and applying in `default` on main branch

## Steps

### 0 - Start clean

Get latest code

```bash
git checkout main
git pull
git checkout -b BRANCH_NAME
```

Init terraform and make sure you are on the default workspace

```bash
terraform init
terraform workspace select default
terraform plan # This is optional to check your curent plan
```

### 1 - Pull the `default` workspace state locally (baseline snapshot)

```bash
terraform workspace select default
terraform state pull > default.tfstate
```

### 2 - Create/select the PoC workspace

Create if needed:

```bash
terraform workspace new WORKSPACE_NAME
```

If it already exists:

```bash
terraform workspace select WORKSPACE_NAME
```

### 3 - Push the baseline state into the PoC workspace

```bash
terraform state push -force default.tfstate
```

==> After this, your PoC workspace starts with the same “known infra” as `default`

### 4 - Make your changes and test

```bash
terraform plan
terraform apply
```

**NOTE: Clean up PoC changes before opening the PR**

### 5 - Merge and apply on default (master only)

```bash
git checkout main
git pull
terraform workspace select default
terraform plan
terraform apply
```

## Two critical safety rules (must follow)

### Rule A — Always start from `default`

Before pulling state or after finishing tests:

```bash
terraform workspace select default
```

### Rule B - Never let PoC workspace live long

After destroy, delete the workspace to avoid confusion later:

```bash
terraform workspace select default
terraform workspace delete -force WORKSPACE_NAME
```

NOTE:

```bash
terraform workspace list     # lists the workspaces
terraform workspace show     # show the curent active workspace
```
