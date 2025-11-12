#!/bin/bash
# Inject environment variables into antora.yml as attributes
# This runs when Showroom builds the content

# Showroom clones content to /opt/app-root/src
ANTORA_FILE="/opt/app-root/src/content/antora.yml"

echo "=== Showroom Environment Variable Injection ==="
echo "Looking for antora.yml at: $ANTORA_FILE"

if [ -f "$ANTORA_FILE" ]; then
  echo "✓ Found antora.yml"

  # Backup original
  cp "$ANTORA_FILE" "${ANTORA_FILE}.bak"

  echo "Injecting workshop variables..."

  # Add environment variables as Asciidoc attributes
  cat >> "$ANTORA_FILE" <<EOF
    API_URL: ${API_URL:-}
    MASTER_URL: ${MASTER_URL:-}
    KUBEADMIN_PASSWORD: ${KUBEADMIN_PASSWORD:-}
    SSH_USERNAME: ${SSH_USERNAME:-}
    SSH_PASSWORD: ${SSH_PASSWORD:-}
    BASTION_FQDN: ${BASTION_FQDN:-}
    GUID: ${GUID:-}
    ROUTE_SUBDOMAIN: ${ROUTE_SUBDOMAIN:-}
    HOME_PATH: ${HOME_PATH:-/home/lab-user}
    ENVIRONMENT: ${ENVIRONMENT:-Amazon Web Services}
EOF

  echo "✓ Environment variables injected"
  echo "Variables injected: API_URL, MASTER_URL, KUBEADMIN_PASSWORD, SSH_USERNAME, SSH_PASSWORD, BASTION_FQDN, GUID, ROUTE_SUBDOMAIN, HOME_PATH, ENVIRONMENT"
else
  echo "✗ antora.yml not found at $ANTORA_FILE"
  echo "Current directory: $(pwd)"
  echo "Available files:"
  ls -la /opt/app-root/src/ 2>/dev/null || echo "  /opt/app-root/src not found"
fi

echo "=== End Injection ==="
