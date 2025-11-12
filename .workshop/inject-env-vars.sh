#!/bin/bash
# Inject environment variables into antora.yml as attributes
# This runs after content is cloned to make env vars available in Asciidoc

ANTORA_FILE="/opt/app-root/src/content/antora.yml"

if [ -f "$ANTORA_FILE" ]; then
  echo "Injecting environment variables into antora.yml..."

  # Backup original
  cp "$ANTORA_FILE" "${ANTORA_FILE}.bak"

  # Add environment variables as attributes
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

  echo "Environment variables injected into antora.yml"
fi
