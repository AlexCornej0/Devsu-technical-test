#!/usr/bin/env bash
# Dumps everything needed to debug a failed deploy. Runs only when a job fails.
# Never fails itself: a broken diagnostic must not hide the original error.
# Usage: scripts/diagnostics.sh <namespace> [release]
set -uo pipefail

ns=${1:?namespace}
release=${2:-demo}

section() { echo; echo "===== $* ====="; }

section "Resources in $ns"
kubectl -n "$ns" get all,pvc,ingress,hpa,pdb,networkpolicy -o wide

section "Events (oldest first)"
kubectl -n "$ns" get events --sort-by=.lastTimestamp

section "Pod details"
kubectl -n "$ns" describe pods

for pod in $(kubectl -n "$ns" get pods -o name); do
  section "Logs $pod"
  kubectl -n "$ns" logs "$pod" --all-containers --tail=200
  section "Previous logs $pod (if it restarted)"
  kubectl -n "$ns" logs "$pod" --all-containers --previous --tail=100 2>/dev/null || echo "(none)"
done

section "Helm history of $release"
helm history "$release" -n "$ns" 2>/dev/null || echo "(no release)"

exit 0