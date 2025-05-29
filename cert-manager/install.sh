#!/bin/bash

# Helm install cert-manager
helm repo add jetstack https://charts.jetstack.io

helm repo update

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --atomic \
  --set installCRDs=true
