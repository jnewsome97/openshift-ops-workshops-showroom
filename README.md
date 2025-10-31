# OpenShift Operations Workshops

This repository contains **two separate workshops** for OpenShift administrators, both compatible with OCP 4.20+. Each workshop is maintained in its own git branch with different content and focus areas.

## What's Inside

This is a **multi-workshop repository** using branch-based variants:
- Each branch represents a complete, standalone workshop
- Same core admin topics, different advanced modules
- Both use modern Showroom framework with integrated terminal

---

## Workshop 1: OpenShift for Admins (Standard)

**Git Branch**: `main`
**Focus**: Core administration + GitOps + Windows Containers
**Modules**: 16 total

### Content Overview
Core topics (14 modules):
- Environment Setup & Installation
- Application & Storage Management
- MachineSets & Infrastructure Nodes
- Logging with Loki
- LDAP Group Synchronization
- Monitoring Basics
- Templates, Quotas & Limits
- Networking
- Project Self-Provisioning
- Cluster Resource Quota
- Taints & Tolerations

Advanced topics (2 modules):
- **GitOps** - Argo CD deployment and management
- **Windows Containers** - Windows node integration

### Deploy in AgnosticV
```yaml
ocp4_workload_showroom_content_git_repo: https://github.com/jnewsome97/openshift-ops-workshops-showroom.git
ocp4_workload_showroom_content_git_repo_ref: main
ocp4_workload_showroom_content_antora_playbook: default-site.yml
```

---

## Workshop 2: Modern App Dev Roadshow - Ops Track (AppMod)

**Git Branch**: `appmod`
**Focus**: Core administration + ACS 4.1 + ACM 2.7
**Modules**: 17 total

### Content Overview
Core topics (14 modules):
- Environment Setup & Installation
- Application & Storage Management
- MachineSets & Infrastructure Nodes
- Logging with Loki
- LDAP Group Synchronization
- Monitoring Basics
- Templates, Quotas & Limits
- Networking
- Project Self-Provisioning
- Cluster Resource Quota
- Taints & Tolerations

Advanced topics (3 modules):
- **ACS 4.1 Vulnerability Scanning** - Container security scanning
- **ACS 4.1 DevSecOps** - Pipeline integration with Tekton
- **ACM 2.7 Multicluster Management** - Cluster fleet management

### Deploy in AgnosticV
```yaml
ocp4_workload_showroom_content_git_repo: https://github.com/jnewsome97/openshift-ops-workshops-showroom.git
ocp4_workload_showroom_content_git_repo_ref: appmod
ocp4_workload_showroom_content_antora_playbook: default-site.yml
```

---

## Repository Structure

```
openshift-ops-workshops-showroom/
├── default-site.yml          # Antora playbook (same for both workshops)
├── content/
│   ├── antora.yml           # Component config (title differs per branch)
│   └── modules/
│       └── ROOT/
│           ├── nav.adoc     # Navigation (differs per branch - determines modules)
│           ├── pages/       # Workshop content (.adoc files)
│           └── images/      # Images (organized by module)
│               ├── gitops/
│               ├── acs-vulnerability-4-1/
│               ├── acs-devsecops-4-1/
│               ├── acm-multicluster-2-7/
│               └── ...
└── README.md
```

### Key Files Per Branch

**Branch-specific differences:**
- `content/antora.yml` - Workshop title
- `content/modules/ROOT/nav.adoc` - Module list and order

**Shared across branches:**
- `default-site.yml` - Antora build configuration
- `content/modules/ROOT/pages/*.adoc` - All module content files
- `content/modules/ROOT/images/` - All workshop images

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
