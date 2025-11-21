#!/bin/bash
# Inject environment variables into antora.yml as attributes
# This script is called by the AgnosticD workload after Showroom deployment
# FIXED: Now properly updates YAML structure instead of appending duplicates

set -e

ANTORA_FILE="/showroom/repo/content/antora.yml"

echo "=== Workshop Variable Injection ==="
echo "Looking for antora.yml at: $ANTORA_FILE"

if [ ! -f "$ANTORA_FILE" ]; then
  echo "✗ antora.yml not found at $ANTORA_FILE"
  echo "Current working directory: $(pwd)"
  echo "Directory listing:"
  ls -la /showroom/repo/ 2>/dev/null || echo "  /showroom/repo not accessible"
  exit 1
fi

echo "✓ Found antora.yml"

# Backup original
cp "$ANTORA_FILE" "${ANTORA_FILE}.bak"

echo "Injecting workshop variables..."

# Check if yq is available (preferred method)
if command -v yq &> /dev/null; then
  echo "Using yq for YAML processing..."

  # Use yq to properly update the asciidoc.attributes section
  yq eval -i ".asciidoc.attributes.environment = \"${ENVIRONMENT:-Amazon Web Services}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.ssh_username = \"${SSH_USERNAME:-demo-user}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.ssh_password = \"${SSH_PASSWORD:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.bastion_fqdn = \"${BASTION_FQDN:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.api_url = \"${API_URL:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.master_url = \"${MASTER_URL:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.route_subdomain = \"${ROUTE_SUBDOMAIN:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.home_path = \"${HOME_PATH:-/opt/app-root/src}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.kubeadmin_password = \"${KUBEADMIN_PASSWORD:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.guid = \"${GUID:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.clustername = \"${CLUSTERNAME:-cluster-${GUID}}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.routingsubdomain = \"${ROUTE_SUBDOMAIN:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.zonename = \"${ZONENAME:-us-east-2a}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.home = \"${HOME_PATH:-/opt/app-root/src}\"" "$ANTORA_FILE"

  # Add uppercase variants for backward compatibility
  yq eval -i ".asciidoc.attributes.SSH_USERNAME = \"${SSH_USERNAME:-demo-user}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.SSH_PASSWORD = \"${SSH_PASSWORD:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.BASTION_FQDN = \"${BASTION_FQDN:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.ROUTE_SUBDOMAIN = \"${ROUTE_SUBDOMAIN:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.ROUTINGSUBDOMAIN = \"${ROUTE_SUBDOMAIN:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.CLUSTERNAME = \"${CLUSTERNAME:-cluster-${GUID}}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.ZONENAME = \"${ZONENAME:-us-east-2a}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.MASTER_URL = \"${MASTER_URL:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.HOME_PATH = \"${HOME_PATH:-/opt/app-root/src}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.HOME = \"${HOME_PATH:-/opt/app-root/src}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.KUBEADMIN_PASSWORD = \"${KUBEADMIN_PASSWORD:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.GUID = \"${GUID:-}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.ENVIRONMENT = \"${ENVIRONMENT:-Amazon Web Services}\"" "$ANTORA_FILE"
  yq eval -i ".asciidoc.attributes.API_URL = \"${API_URL:-}\"" "$ANTORA_FILE"

else
  # Fallback to sed-based approach if yq not available
  echo "yq not found, using sed-based approach..."

  # Create a temporary file with the variables to inject
  TEMP_VARS=$(mktemp)
  cat > "$TEMP_VARS" <<EOF
    environment: "${ENVIRONMENT:-Amazon Web Services}"
    ssh_username: "${SSH_USERNAME:-demo-user}"
    ssh_password: "${SSH_PASSWORD:-}"
    bastion_fqdn: "${BASTION_FQDN:-}"
    api_url: "${API_URL:-}"
    master_url: "${MASTER_URL:-}"
    route_subdomain: "${ROUTE_SUBDOMAIN:-}"
    home_path: "${HOME_PATH:-/opt/app-root/src}"
    kubeadmin_password: "${KUBEADMIN_PASSWORD:-}"
    guid: "${GUID:-}"
    clustername: "${CLUSTERNAME:-cluster-${GUID}}"
    routingsubdomain: "${ROUTE_SUBDOMAIN:-}"
    zonename: "${ZONENAME:-us-east-2a}"
    home: "${HOME_PATH:-/opt/app-root/src}"
    SSH_USERNAME: "${SSH_USERNAME:-demo-user}"
    SSH_PASSWORD: "${SSH_PASSWORD:-}"
    BASTION_FQDN: "${BASTION_FQDN:-}"
    ROUTE_SUBDOMAIN: "${ROUTE_SUBDOMAIN:-}"
    ROUTINGSUBDOMAIN: "${ROUTE_SUBDOMAIN:-}"
    CLUSTERNAME: "${CLUSTERNAME:-cluster-${GUID}}"
    ZONENAME: "${ZONENAME:-us-east-2a}"
    MASTER_URL: "${MASTER_URL:-}"
    HOME_PATH: "${HOME_PATH:-/opt/app-root/src}"
    HOME: "${HOME_PATH:-/opt/app-root/src}"
    KUBEADMIN_PASSWORD: "${KUBEADMIN_PASSWORD:-}"
    GUID: "${GUID:-}"
    ENVIRONMENT: "${ENVIRONMENT:-Amazon Web Services}"
    API_URL: "${API_URL:-}"
EOF

  # Find the asciidoc: attributes: section and inject variables there
  # Using awk to properly insert after "attributes:" line
  awk -v vars="$TEMP_VARS" '
    /^asciidoc:/ { in_asciidoc=1; print; next }
    /^  attributes:/ && in_asciidoc {
      print
      while ((getline line < vars) > 0) {
        print line
      }
      close(vars)
      next
    }
    /^[a-z]/ && in_asciidoc { in_asciidoc=0 }
    { print }
  ' "${ANTORA_FILE}.bak" > "$ANTORA_FILE"

  rm -f "$TEMP_VARS"
fi

echo "✓ Environment variables injected"
echo ""
echo "Injected variables:"
echo "  - ENVIRONMENT: ${ENVIRONMENT:-Amazon Web Services}"
echo "  - SSH_USERNAME: ${SSH_USERNAME:-demo-user}"
echo "  - SSH_PASSWORD: ${SSH_PASSWORD:-<not set>}"
echo "  - BASTION_FQDN: ${BASTION_FQDN:-<not set>}"
echo "  - API_URL: ${API_URL:-<not set>}"
echo "  - MASTER_URL: ${MASTER_URL:-<not set>}"
echo "  - ROUTE_SUBDOMAIN: ${ROUTE_SUBDOMAIN:-<not set>}"
echo "  - GUID: ${GUID:-<not set>}"
echo "  - HOME_PATH: ${HOME_PATH:-/opt/app-root/src}"
echo ""
echo "Validating YAML syntax..."

# Validate the YAML syntax
if command -v yq &> /dev/null; then
  if yq eval . "$ANTORA_FILE" > /dev/null 2>&1; then
    echo "✓ YAML syntax is valid"
  else
    echo "✗ ERROR: Invalid YAML syntax detected!"
    echo "Restoring backup..."
    mv "${ANTORA_FILE}.bak" "$ANTORA_FILE"
    exit 1
  fi
else
  echo "⚠ yq not available, skipping YAML validation"
fi

echo "=== End Variable Injection ==="
