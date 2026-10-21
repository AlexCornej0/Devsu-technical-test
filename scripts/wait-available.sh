#!/usr/bin/env bash
# Waits until a Deployment has at least <min> available replicas.
# helm --wait only proves the rollout finished; this proves the HPA minimum is really serving.
# Usage: scripts/wait-available.sh <namespace> <deployment> <min> [timeout_seconds]
set -euo pipefail

ns=${1:?namespace}
deploy=${2:?deployment}
min=${3:?minimum available replicas}
timeout=${4:-180}

end=$((SECONDS + timeout))
while true; do
  available=$(kubectl -n "$ns" get deploy "$deploy" -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)
  available=${available:-0}
  if [ "$available" -ge "$min" ]; then
    echo "OK: $available/$min available replicas of $ns/$deploy"
    exit 0
  fi
  if [ "$SECONDS" -ge "$end" ]; then
    echo "Timeout after ${timeout}s: $available/$min available replicas of $ns/$deploy" >&2
    kubectl -n "$ns" get deploy,rs,pods -o wide >&2 || true
    exit 1
  fi
  sleep 5
done