# Workshop Module Selection - Dynamic Navigation

This document explains how workshop modules can be selectively enabled/disabled, and how the navigation dynamically updates based on module selection.

## Overview

When ordering the workshop through RHPDS/Babylon, users can toggle which modules to deploy. This affects:
1. Which workloads get deployed (operators, applications)
2. Which navigation items appear in the Showroom content

## Architecture Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              RHPDS Order Form                                │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐                │
│  │ ☑ Virtualization│ │ ☐ ACM/HCP      │ │ ☑ Developer Hub │                │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘                │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AgnosticV Configuration                              │
│                                                                              │
│  module_enable_virt: true                                                   │
│  module_enable_acm: false                                                   │
│  module_enable_devhub: true                                                 │
│                                                                              │
│  infra_workloads: {{ _base + (_virt if module_enable_virt else []) + ... }} │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ocp4-workload-days-ops-track                              │
│                                                                              │
│  1. Renders workshop-settings.j2 template:                                  │
│     MODULE_ENABLE_VIRT=true                                                 │
│     MODULE_ENABLE_ACM=false                                                 │
│     MODULE_ENABLE_DEVHUB=true                                               │
│                                                                              │
│  2. Creates ConfigMap 'workshop-vars' with these values                     │
│                                                                              │
│  3. Patches Showroom deployment to inject ConfigMap as env vars             │
│                                                                              │
│  4. Executes inject-env-vars.sh inside Showroom container                   │
│                                                                              │
│  5. Rebuilds Antora site with new attributes                                │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         inject-env-vars.sh                                   │
│                                                                              │
│  Reads: $MODULE_ENABLE_VIRT, $MODULE_ENABLE_ACM, etc.                       │
│                                                                              │
│  Updates default-site.yml with:                                             │
│    asciidoc:                                                                │
│      attributes:                                                            │
│        module_virt: ''      # Only if MODULE_ENABLE_VIRT=true               │
│        module_devhub: ''    # Only if MODULE_ENABLE_DEVHUB=true             │
│        # module_acm NOT set because MODULE_ENABLE_ACM=false                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              nav.adoc                                        │
│                                                                              │
│  .Phase 4: Workloads & Architecture                                         │
│  ifdef::module_virt[]                                                       │
│  * xref:virtualization.adoc[Virtualization]      ← VISIBLE (attr set)      │
│  endif::[]                                                                  │
│  ifdef::module_acm[]                                                        │
│  * xref:acm-multicluster.adoc[ACM]               ← HIDDEN (attr not set)   │
│  endif::[]                                                                  │
│                                                                              │
│  .Phase 6: Platform Engineering                                             │
│  ifdef::module_devhub[]                                                     │
│  * xref:developer-hub.adoc[Developer Hub]        ← VISIBLE (attr set)      │
│  endif::[]                                                                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Module Mapping

| Catalog Parameter | Environment Variable | Antora Attribute | Nav Items Affected |
|-------------------|---------------------|------------------|-------------------|
| `module_enable_virt` | `MODULE_ENABLE_VIRT` | `module_virt` | Virtualization |
| `module_enable_acm` | `MODULE_ENABLE_ACM` | `module_acm` | ACM, HCP |
| `module_enable_backup` | `MODULE_ENABLE_BACKUP` | `module_backup` | (future use) |
| `module_enable_devhub` | `MODULE_ENABLE_DEVHUB` | `module_devhub` | Developer Hub |

## How ifdef Works

AsciiDoc's `ifdef::` directive checks if an attribute **exists** (not its value):

```asciidoc
ifdef::module_virt[]
* This line appears only if module_virt attribute is defined
endif::[]
```

The inject-env-vars.sh script only sets attributes for **enabled** modules:
- `MODULE_ENABLE_VIRT=true` → sets `module_virt: ''`
- `MODULE_ENABLE_VIRT=false` → does NOT set `module_virt` (attribute absent)

## Files Involved

### AgnosticD Repository

**`ansible/roles/ocp4-workload-days-ops-track/files/workshop-settings.j2`**
```jinja2
MODULE_ENABLE_VIRT={{ module_enable_virt | default(true) | string | lower }}
MODULE_ENABLE_ACM={{ module_enable_acm | default(true) | string | lower }}
MODULE_ENABLE_BACKUP={{ module_enable_backup | default(true) | string | lower }}
MODULE_ENABLE_DEVHUB={{ module_enable_devhub | default(true) | string | lower }}
```

**`ansible/roles/ocp4-workload-days-ops-track/tasks/workload.yml`**
- Creates ConfigMap from workshop-settings
- Patches Showroom deployment with envFrom
- Runs inject-env-vars.sh
- Rebuilds Antora site

### Showroom Content Repository

**`.workshop/inject-env-vars.sh`**
- Reads MODULE_ENABLE_* environment variables
- Updates default-site.yml with asciidoc.attributes
- Only sets attributes for enabled modules

**`content/modules/ROOT/nav.adoc`**
- Uses `ifdef::module_*[]` conditionals around nav items
- Items inside ifdef blocks only appear when attribute is set

## Testing Locally

Build without module attributes (all module items hidden):
```bash
npx antora default-site.yml
```

Build with module attributes (items visible):
```bash
# Create test config with attributes
cat > test-site.yml << 'EOF'
site:
  title: OpenShift Days - Ops Track
  url: http://localhost:8080
  start_page: openshift-days-ops-track::index.adoc
content:
  sources:
  - url: ./
    start_path: content
    branches: HEAD
ui:
  bundle:
    url: https://github.com/jnewsome97/rhdp_showroom_theme/releases/download/v1.0.0-execute/ui-bundle.zip
    snapshot: true
output:
  dir: ./public-test
asciidoc:
  attributes:
    module_virt: ''
    module_acm: ''
    module_devhub: ''
EOF

npx antora test-site.yml
```

## Adding New Module Conditionals

1. Add parameter to AgnosticV config:
   ```yaml
   - name: module_enable_newmodule
     formGroup: Modules
     formLabel: New Module Description
     openAPIV3Schema:
       type: boolean
       default: true
   ```

2. Add to workshop-settings.j2:
   ```jinja2
   MODULE_ENABLE_NEWMODULE={{ module_enable_newmodule | default(true) | string | lower }}
   ```

3. Update inject-env-vars.sh to handle new variable

4. Wrap nav items in nav.adoc:
   ```asciidoc
   ifdef::module_newmodule[]
   * xref:new-module.adoc[New Module]
   endif::[]
   ```
