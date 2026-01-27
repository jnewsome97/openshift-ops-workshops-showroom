# OpenShift Days - Ops Track

Operations workshop content for OpenShift 4.x, built with Antora for the Showroom framework.

## Workshop Modules

### Phase 1: Platform Foundation
| Module | Status |
|--------|--------|
| Platform Overview | :yellow_circle: Draft |
| Installation & Verification | :yellow_circle: Draft |
| Identity & Users (OIDC) | :yellow_circle: Draft |
| Identity & Users (LDAP) | :yellow_circle: Draft |
| Application Management | :yellow_circle: Draft |

### Phase 2: Networking
| Module | Status |
|--------|--------|
| Networking & Ingress | :yellow_circle: Draft |

### Phase 3: Day 2 Operations
| Module | Status |
|--------|--------|
| Observability | :red_circle: Placeholder |
| Debugging & Troubleshooting | :yellow_circle: Draft |
| Performance Tuning | :yellow_circle: Draft |

### Phase 4: Workloads & Architecture
| Module | Status |
|--------|--------|
| Virtualization | :yellow_circle: Draft |
| ACM Multi-Cluster | :red_circle: Placeholder |
| Hosted Control Planes | :yellow_circle: Draft |

### Phase 5: Security
| Module | Status |
|--------|--------|
| Security (Secrets, Certs, ACS) | :red_circle: Placeholder |

### Phase 6: Platform Engineering
| Module | Status |
|--------|--------|
| Cloud Infrastructure | :red_circle: Placeholder |
| Developer Hub | :yellow_circle: Draft |
| OpenShift Lightspeed | :white_circle: TBA |

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
