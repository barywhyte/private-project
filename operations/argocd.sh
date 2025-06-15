#!/bin/bash

set -e

# Create namespaces if they don't exist
kubectl get namespace argocd >/dev/null 2>&1 || kubectl create namespace argocd
kubectl get namespace argo-rollouts >/dev/null 2>&1 || kubectl create namespace argo-rollouts
kubectl get namespace monitoring >/dev/null 2>&1 || kubectl create namespace monitoring

# Install ArgoCD Image Updater
kubectl apply -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml -n argocd

# Add Helm repositories
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

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

# Install Argo Rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

# Install Loki Stack (Loki backend with gateway)
helm upgrade --install loki grafana/loki -n monitoring


# Install Promtail with proper multi-tenancy config
helm upgrade --install promtail grafana/promtail \
  --namespace monitoring \
  --values promtail-values.yml

# Print Grafana Loki info
echo "Loki installed. Configure Grafana data source as:"
echo "URL: http://loki-gateway.monitoring.svc.cluster.local/loki"
echo "Tenant ID: foo"

echo "Promtail installed and properly configured for multi-tenancy"
