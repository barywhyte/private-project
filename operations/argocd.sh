#!/bin/bash

set -e

# The function is to ensure the helm operation finish before the next operation starts
# It checks the status of the Helm release until it is either deployed, failed, or not
wait_for_helm_release() {
  local release=$1
  local namespace=$2

  echo "⏳ Waiting for Helm release '$release' in namespace '$namespace' to finish..."
  while true; do
    status=$(helm status "$release" -n "$namespace" --output json 2>/dev/null | jq -r '.info.status' || echo "not-found")
    if [[ "$status" == "deployed" || "$status" == "failed" || "$status" == "not-found" ]]; then
      echo "✅ Helm release '$release' status: $status"
      break
    fi
    echo "⌛ Still in progress..."
    sleep 5
  done
}


# Create namespaces if they don't exist
kubectl get namespace argocd >/dev/null 2>&1 || kubectl create namespace argocd
kubectl get namespace argo-rollouts >/dev/null 2>&1 || kubectl create namespace argo-rollouts
kubectl get namespace monitoring >/dev/null 2>&1 || kubectl create namespace monitoring
kubectl get namespace db >/dev/null 2>&1 || kubectl create namespace db

# Install ArgoCD Image Updater
kubectl apply -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml -n argocd

# Add Helm repositories
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install postgres via Helm
helm upgrade --install db bitnami/postgresql \
  --namespace db \
  --set auth.username=$(kubectl get secret postgres-secret -n db -o jsonpath="{.data.postgres-user}" | base64 -d) \
  --set auth.password=$(kubectl get secret postgres-secret -n db -o jsonpath="{.data.postgres-password}" | base64 -d) \
  --set auth.database=$(kubectl get secret postgres-secret -n db -o jsonpath="{.data.postgres-db}" | base64 -d)
wait_for_helm_release db db

# Install ArgoCD via Helm
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --set global.domain=argocdbary.duckdns.org \
  --set server.ingress.enabled=true \
  --set server.ingress.ingressClassName=nginx \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/force-ssl-redirect"="true" \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/ssl-passthrough"="true" \
  --set server.ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set server.ingress.tls=true
wait_for_helm_release argocd argocd

# Install Argo Rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

# Install Loki Stack (Loki backend with gateway)
helm upgrade --install loki grafana/loki -n monitoring
wait_for_helm_release loki monitoring

# Install Promtail with proper multi-tenancy config
helm upgrade --install promtail grafana/promtail \
  --namespace monitoring \
  --values promtail-values.yml

# Print Grafana Loki info
echo "Loki installed. Configure Grafana data source as:"
echo "URL: http://loki-gateway.monitoring.svc.cluster.local/loki"
echo "Tenant ID: foo"

echo "Promtail installed and properly configured for multi-tenancy"
wait_for_helm_release promtail monitoring
