#!/bin/bash
# Install argocd and argocd-image-updater
kubectl apply -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml -n argocd

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create namespace argocd


helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --set global.domain=argocdbary.duckdns.org \
  --set server.ingress.enabled=true \
  --set server.ingress.ingressClassName=nginx \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/force-ssl-redirect"="true" \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/ssl-passthrough"="true" \
  --set server.ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set server.ingress.tls=true

# Install argocd-rollouts
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
