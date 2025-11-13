#!/bin/bash
# Inject environment variables into antora.yml as attributes
# This script should be called by the Showroom deployment process

ANTORA_FILE="/showroom/repo/content/antora.yml"

echo "=== Workshop Variable Injection ==="
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
  echo ""
  echo "Injected variables:"
  echo "  - API_URL: ${API_URL:-<not set>}"
  echo "  - MASTER_URL: ${MASTER_URL:-<not set>}"
  echo "  - SSH_USERNAME: ${SSH_USERNAME:-<not set>}"
  echo "  - BASTION_FQDN: ${BASTION_FQDN:-<not set>}"
  echo "  - ENVIRONMENT: ${ENVIRONMENT:-Amazon Web Services}"
else
  echo "✗ antora.yml not found at $ANTORA_FILE"
  echo "Current working directory: $(pwd)"
  echo "Directory listing:"
  ls -la /opt/app-root/src/ 2>/dev/null || echo "  /opt/app-root/src not accessible"
fi

echo "=== End Variable Injection ==="
