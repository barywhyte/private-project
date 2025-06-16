#!/bin/bash

NAMESPACE="api"  # Change if needed
ROLLOUTS=$(kubectl get rollouts -n $NAMESPACE --no-headers | awk '{print $1}')

for rollout in $ROLLOUTS; do
  phase=$(kubectl get rollout $rollout -n $NAMESPACE -o jsonpath='{.status.phase}')
  echo "Rollout: $rollout => Phase: $phase"
  if [ "$phase" == "Degraded" ]; then
    echo "Aborting rollout $rollout"
    kubectl-argo-rollouts abort $rollout -n $NAMESPACE
  fi
done
