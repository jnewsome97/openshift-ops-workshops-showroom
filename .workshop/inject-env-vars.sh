#!/bin/bash
# Inject environment variables into antora.yml as attributes
# This script is called by the AgnosticD workload after Showroom deployment

ANTORA_FILE="/showroom/repo/content/antora.yml"

echo "=== Workshop Variable Injection ==="
echo "Looking for antora.yml at: $ANTORA_FILE"

if [ -f "$ANTORA_FILE" ]; then
  echo "✓ Found antora.yml"

  # Backup original
  cp "$ANTORA_FILE" "${ANTORA_FILE}.bak"

  echo "Injecting workshop variables..."

  # Add environment variables as Asciidoc attributes (lowercase with quotes)
  cat >> "$ANTORA_FILE" <<EOF
    "environment": "${ENVIRONMENT:-Amazon Web Services}"
    "ssh_username": "${SSH_USERNAME:-demo-user}"
    "ssh_password": "${SSH_PASSWORD:-}"
    "bastion_fqdn": "${BASTION_FQDN:-}"
    "api_url": "${API_URL:-}"
    "master_url": "${MASTER_URL:-}"
    "route_subdomain": "${ROUTE_SUBDOMAIN:-}"
    "home_path": "${HOME_PATH:-/opt/app-root/src}"
    "kubeadmin_password": "${KUBEADMIN_PASSWORD:-}"
    "guid": "${GUID:-}"
    "clustername": "${CLUSTERNAME:-cluster-${GUID}}"
    "routingsubdomain": "${ROUTE_SUBDOMAIN:-}"
    "zonename": "${ZONENAME:-us-east-2a}"
    "home": "${HOME_PATH:-/opt/app-root/src}"
    "SSH_USERNAME": "${SSH_USERNAME:-demo-user}"
    "SSH_PASSWORD": "${SSH_PASSWORD:-}"
    "BASTION_FQDN": "${BASTION_FQDN:-}"
    "ROUTE_SUBDOMAIN": "${ROUTE_SUBDOMAIN:-}"
    "ROUTINGSUBDOMAIN": "${ROUTE_SUBDOMAIN:-}"
    "CLUSTERNAME": "${CLUSTERNAME:-cluster-${GUID}}"
    "ZONENAME": "${ZONENAME:-us-east-2a}"
    "MASTER_URL": "${MASTER_URL:-}"
    "HOME_PATH": "${HOME_PATH:-/opt/app-root/src}"
    "HOME": "${HOME_PATH:-/opt/app-root/src}"
    "KUBEADMIN_PASSWORD": "${KUBEADMIN_PASSWORD:-}"
    "GUID": "${GUID:-}"
    "ENVIRONMENT": "${ENVIRONMENT:-Amazon Web Services}"
    "API_URL": "${API_URL:-}"
EOF

  echo "✓ Environment variables injected"
  echo ""
  echo "Injected variables:"
  echo "  - ENVIRONMENT: ${ENVIRONMENT:-Amazon Web Services}"
  echo "  - SSH_USERNAME: ${SSH_USERNAME:-<not set>}"
  echo "  - SSH_PASSWORD: ${SSH_PASSWORD:-<not set>}"
  echo "  - BASTION_FQDN: ${BASTION_FQDN:-<not set>}"
  echo "  - API_URL: ${API_URL:-<not set>}"
  echo "  - MASTER_URL: ${MASTER_URL:-<not set>}"
  echo "  - ROUTE_SUBDOMAIN: ${ROUTE_SUBDOMAIN:-<not set>}"
  echo "  - GUID: ${GUID:-<not set>}"
  echo "  - HOME_PATH: ${HOME_PATH:-/opt/app-root/src}"
else
  echo "✗ antora.yml not found at $ANTORA_FILE"
  echo "Current working directory: $(pwd)"
  echo "Directory listing:"
  ls -la /showroom/repo/ 2>/dev/null || echo "  /showroom/repo not accessible"
fi

echo "=== End Variable Injection ==="
