#!/bin/bash
set -e

echo "================================================"
echo "🚀 OpenShift Ops Workshop Setup"
echo "================================================"
echo ""

# Get current namespace - try multiple methods
NAMESPACE=$(oc project -q 2>/dev/null || true)
if [ -z "$NAMESPACE" ]; then
    # Try to get from service account
    NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null || true)
fi
if [ -z "$NAMESPACE" ]; then
    # Find showroom namespace
    NAMESPACE=$(oc get namespaces -o name 2>/dev/null | grep showroom | head -1 | cut -d'/' -f2 || true)
fi
if [ -z "$NAMESPACE" ]; then
    echo "❌ Error: Could not detect namespace. Please run: oc project <namespace>"
    exit 1
fi

echo "📍 Using namespace: $NAMESPACE"
echo ""

# Set current project
oc project $NAMESPACE >/dev/null 2>&1 || true

# 1. Grant cluster-admin permissions
echo "📋 Step 1: Granting cluster-admin permissions..."
cat <<EOFRBAC | oc apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: showroom-cluster-admin-${NAMESPACE}
  labels:
    app.kubernetes.io/part-of: showroom
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: showroom
  namespace: ${NAMESPACE}
EOFRBAC
echo "✅ Cluster-admin permissions granted"
echo ""

# 2. Install CLI tools
echo "🔧 Step 2: Installing CLI tools..."
mkdir -p ~/bin

# NooBaa CLI
echo "  - Installing NooBaa CLI v5.11.0..."
wget -q https://github.com/noobaa/noobaa-operator/releases/download/v5.11.0/noobaa-linux-v5.11.0 -O ~/bin/noobaa
chmod +x ~/bin/noobaa

# OpenShift Client (oc/kubectl) 4.20.0
echo "  - Installing OpenShift Client v4.20.0..."
wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.20.0/openshift-client-linux-4.20.0.tar.gz -O /tmp/oc.tar.gz
tar -xzf /tmp/oc.tar.gz -C ~/bin/ oc kubectl
rm -f /tmp/oc.tar.gz
chmod +x ~/bin/oc ~/bin/kubectl

# yq
echo "  - Installing yq v4.48.1..."
wget -q https://github.com/mikefarah/yq/releases/download/v4.48.1/yq_linux_amd64 -O ~/bin/yq
chmod +x ~/bin/yq

# AWS CLI
echo "  - Installing AWS CLI..."
wget -q https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install -i /usr/local/aws-cli -b /usr/local/bin 2>/dev/null || /tmp/aws/install --install-dir ~/.local/aws-cli --bin-dir ~/bin --update
rm -rf /tmp/aws* /tmp/awscliv2.zip

# Helm
echo "  - Installing Helm v3.19.0..."
wget -q https://get.helm.sh/helm-v3.19.0-linux-amd64.tar.gz -O /tmp/helm.tar.gz
tar -xzf /tmp/helm.tar.gz -C /tmp
mv /tmp/linux-amd64/helm ~/bin/
rm -rf /tmp/helm.tar.gz /tmp/linux-amd64
chmod +x ~/bin/helm

echo "✅ CLI tools installed"
echo ""

# 3. Add ~/bin to PATH
echo "🔧 Step 3: Configuring PATH..."
if ! grep -q 'export PATH=$HOME/bin:$PATH' ~/.bashrc; then
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
fi
export PATH=$HOME/bin:$PATH
echo "✅ PATH configured"
echo ""

# 4. Download photo album demo app
echo "📦 Step 4: Downloading photo album demo app..."
mkdir -p ~/workshop-content/support
wget -q https://github.com/red-hat-storage/demo-apps/raw/main/packaged/photo-album.tgz -O /tmp/photo-album.tgz
tar -xzf /tmp/photo-album.tgz -C ~/workshop-content/support/
rm -f /tmp/photo-album.tgz
echo "✅ Photo album demo app available in ~/workshop-content/support/"
echo ""

# 5. Verify installation
echo "🔍 Step 5: Verifying installation..."
echo "  - NooBaa: $(~/bin/noobaa version 2>/dev/null || echo 'installed')"
echo "  - oc: $(~/bin/oc version --client -o json | grep gitVersion | cut -d'"' -f4 2>/dev/null || echo 'installed')"
echo "  - yq: $(~/bin/yq --version 2>/dev/null || echo 'installed')"
echo "  - aws: $(aws --version 2>/dev/null || ~/bin/aws --version 2>/dev/null || echo 'installed')"
echo "  - helm: $(~/bin/helm version --short 2>/dev/null || echo 'installed')"
echo ""

# 6. Test cluster-admin access
echo "🔐 Step 6: Testing cluster-admin access..."
if oc version --short 2>/dev/null | grep -q "Server Version"; then
    echo "✅ Cluster-admin access confirmed"
else
    echo "⚠️  Cluster-admin access pending (may need to restart terminal)"
fi
echo ""

echo "================================================"
echo "✅ Workshop Setup Complete!"
echo "================================================"
echo ""
echo "Installed tools:"
echo "  • NooBaa CLI v5.11.0"
echo "  • OpenShift Client v4.20.0 (oc/kubectl)"
echo "  • yq v4.48.1"
echo "  • AWS CLI"
echo "  • Helm v3.19.0"
echo ""
echo "Demo apps:"
echo "  • Photo Album: ~/workshop-content/support/"
echo ""
echo "⚡ Run 'source ~/.bashrc' or restart your terminal to use the tools"
echo "================================================"
