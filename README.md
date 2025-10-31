# OpenShift for Admins - Showroom Workshop

Modern Showroom-based workshop for OpenShift administrators, compatible with OCP 4.20+.

## Workshop Variants

This repository supports multiple workshop variants via git branches:

### Standard Workshop (16 modules)
- **Branch**: `main`
- **Title**: "OpenShift for Admins"
- **Modules**: Core admin topics + GitOps + Windows Containers
- **Use in AgnosticV**:
  ```yaml
  ocp4_workload_showroom_content_git_repo: https://github.com/jnewsome97/openshift-ops-workshops.git
  ocp4_workload_showroom_content_git_repo_ref: main
  ocp4_workload_showroom_content_antora_playbook: default-site.yml
  ```

### AppMod Workshop (17 modules)
- **Branch**: `appmod`
- **Title**: "Modern App Dev Roadshow - Ops Track"
- **Modules**: Core admin topics + ACS 4.1 + ACM 2.7
- **Use in AgnosticV**:
  ```yaml
  ocp4_workload_showroom_content_git_repo: https://github.com/jnewsome97/openshift-ops-workshops.git
  ocp4_workload_showroom_content_git_repo_ref: appmod
  ocp4_workload_showroom_content_antora_playbook: default-site.yml
  ```

## Repository Structure

```
openshift-ops-workshops/
├── default-site.yml          # Antora playbook
├── content/
│   ├── antora.yml           # Antora component config
│   └── modules/
│       └── ROOT/
│           ├── nav.adoc     # Navigation (differs per branch)
│           ├── pages/       # Workshop content
│           └── images/      # Images
└── README.md
```

## Local Development

```bash
# Install Antora
npm install -g @antora/cli@3.1 @antora/site-generator@3.1

# Build standard workshop
git checkout main
antora default-site.yml

# Build appmod workshop
git checkout appmod
antora default-site.yml

# Serve locally
cd public && python3 -m http.server 8080
```

## Deployment

This workshop is deployed using the `ocp4_workload_showroom` AgnosticD workload with:
- **Content**: This Git repository (branch determines variant)
- **Terminal**: `quay.io/rhpds/openshift-showroom-terminal-ocp:latest`
- **Deployment**: Helm chart from showroom-deployer

## OCP 4.20 Compatibility

All workshop content and CLI tools are compatible with OpenShift 4.20.1.

## Theme

Uses RHDP Showroom theme v0.0.1 with modern Red Hat branding.
