# Workshop Setup Scripts

This directory contains scripts that run automatically when the Showroom terminal starts.

## setup

The `setup` script automatically installs the following CLI tools:

- **noobaa** (v5.11.0) - NooBaa object storage CLI
- **yq** (v4.48.1) - YAML processor
- **aws** (v2) - AWS CLI

### How it works

1. Showroom automatically runs `.workshop/setup` when the terminal starts
2. Tools are installed to `~/.local/bin` (no root required)
3. Script is idempotent - safe to run multiple times
4. Only installs tools that aren't already present

### Already included tools

These tools come pre-installed with Showroom:
- **oc** - OpenShift CLI
- **kubectl** - Kubernetes CLI
- **helm** - Helm package manager

## Deployment

When you commit this to your repository:

```bash
# Make sure the setup script is executable
git add .workshop/setup
git update-index --chmod=+x .workshop/setup
git commit -m "Add automatic CLI tools installation"
git push origin appmod
```

The tools will be automatically installed when users open the workshop terminal.
