# OpenShift Days - Ops Track

Operations workshop content for OpenShift 4.x, built with Antora for the Showroom framework.

## Workshop Modules

### Phase 1: Platform Foundation
| Module | Status |
|--------|--------|
| Platform Overview | :yellow_circle: Initial draft |
| Installation & Verification | :yellow_circle: Initial draft |
| Identity & Users (OIDC) | :yellow_circle: Initial draft |
| Identity & Users (LDAP) | :yellow_circle: Initial draft |
| Application Management | :yellow_circle: Initial draft |

### Phase 2: Networking
| Module | Status |
|--------|--------|
| Networking & Ingress | :yellow_circle: Initial draft |

### Phase 3: Day 2 Operations
| Module | Status |
|--------|--------|
| Observability | :yellow_circle: Initial draft |
| Debugging & Troubleshooting | :yellow_circle: Initial draft |
| Performance Tuning | :yellow_circle: Initial draft |
| OpenShift Lightspeed | :white_circle: TBA |

### Phase 4: Workloads & Architecture
| Module | Status |
|--------|--------|
| Virtualization | :yellow_circle: Initial draft |
| ACM Multi-Cluster | :red_circle: Placeholder |
| Hosted Control Planes | :yellow_circle: Initial draft |

### Phase 5: Security
| Module | Status |
|--------|--------|
| Security (Secrets, Certs, ACS) | :red_circle: Placeholder |

### Phase 6: Platform Engineering
| Module | Status |
|--------|--------|
| Cloud Infrastructure | :red_circle: Placeholder |
| Developer Hub | :yellow_circle: Initial draft |

---

**Legend:** :yellow_circle: Initial draft | :red_circle: Placeholder | :white_circle: TBA

## Local Development

```bash
# Install Antora
npm install -g @antora/cli@3.1 @antora/site-generator@3.1

# Build and serve
antora default-site.yml
cd public && python3 -m http.server 8080
```

## Deployment

Used with AgnosticD/Showroom:

```yaml
ocp4_workload_showroom_content_git_repo: https://github.com/jnewsome97/openshift-days-ops-track-showroom.git
ocp4_workload_showroom_content_git_repo_ref: main
```

## License

Licensed under [GPL v3.0](LICENSE).
