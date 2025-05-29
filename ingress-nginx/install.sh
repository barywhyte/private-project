#!/bin/bash

# Helm install ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx


helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx  \
  --namespace ingress-nginx \
  --create-namespace \
  --timeout 600s \
  --debug \
  --set controller.publishService.enabled=true \
  --set controller.service.externalTrafficPolicy=Local \
  --set "controller.extraArgs.enable-ssl-passthrough="
