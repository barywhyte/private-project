#!/bin/bash

NAMESPACE=api
ROLLOUT_NAME=api

status=$(kubectl -n $NAMESPACE get rollout $ROLLOUT_NAME -o json | jq -r '.status.phase')

if [[ "$status" == "Degraded" ]]; then
  echo "Rollout $ROLLOUT_NAME is degraded, triggering rollback..."
  kubectl argo rollouts undo $ROLLOUT_NAME -n $NAMESPACE
else
  echo "Rollout $ROLLOUT_NAME status: $status"
fi
