#!/usr/bin/env bash
#
# Renders the kubectl-apply-job library chart through test/consumer and asserts
# that the output is valid multi-document YAML with the expected resources.
#
# This guards against regressions in the `---` document separators: if two
# manifests merge into a single document (a duplicate-key merge), the rendered
# document count drops and the merged resource silently disappears, which this
# script detects.
#
# Requires: helm, yq (https://github.com/mikefarah/yq)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSUMER_DIR="${SCRIPT_DIR}/consumer"
RELEASE="test"

for bin in helm yq; do
  command -v "${bin}" >/dev/null 2>&1 || { echo "ERROR: '${bin}' is required but not installed" >&2; exit 1; }
done

# Resolve the local library chart dependency into consumer/charts (offline).
echo "==> Building chart dependencies"
helm dependency build "${CONSUMER_DIR}" >/dev/null

failures=0

# assert "<scenario>" <expected_total_docs> <expected_configmaps> <helm args...>
assert() {
  local name="$1" want_total="$2" want_cm="$3"; shift 3

  local rendered
  rendered="$(helm template "${RELEASE}" "${CONSUMER_DIR}" "$@")"

  # Count non-null documents and ConfigMap documents in the rendered stream.
  local total cm
  total="$(yq ea '[select(. != null)] | length' - <<<"${rendered}")"
  cm="$(yq ea '[select(.kind == "ConfigMap")] | length' - <<<"${rendered}")"

  if [[ "${total}" == "${want_total}" && "${cm}" == "${want_cm}" ]]; then
    printf 'PASS  %-28s docs=%s configmaps=%s\n' "${name}" "${total}" "${cm}"
  else
    printf 'FAIL  %-28s docs=%s (want %s) configmaps=%s (want %s)\n' \
      "${name}" "${total}" "${want_total}" "${cm}" "${want_cm}"
    failures=$((failures + 1))
  fi
}

# Base resources always rendered: NetworkPolicy, ServiceAccount, ClusterRole,
# ClusterRoleBinding, Job = 5. Add one ConfigMap per file, plus one
# CiliumNetworkPolicy when cilium is enabled.
ONE="files/crd-a.yaml"
TWO="files/crd-a.yaml,files/crd-b.yaml"
THREE="files/crd-a.yaml,files/crd-b.yaml,files/crd-c.yaml"

echo "==> Running scenarios"
assert "1 file, cilium off"  6 1 --set ciliumNetworkPolicy.enabled=false --set "kubectlApplyJob.files={${ONE}}"
assert "1 file, cilium on"   7 1 --set ciliumNetworkPolicy.enabled=true  --set "kubectlApplyJob.files={${ONE}}"
assert "2 files, cilium off" 7 2 --set ciliumNetworkPolicy.enabled=false --set "kubectlApplyJob.files={${TWO}}"
assert "2 files, cilium on"  8 2 --set ciliumNetworkPolicy.enabled=true  --set "kubectlApplyJob.files={${TWO}}"
assert "3 files, cilium off" 8 3 --set ciliumNetworkPolicy.enabled=false --set "kubectlApplyJob.files={${THREE}}"
assert "3 files, cilium on"  9 3 --set ciliumNetworkPolicy.enabled=true  --set "kubectlApplyJob.files={${THREE}}"

echo
if [[ "${failures}" -eq 0 ]]; then
  echo "All scenarios passed."
else
  echo "${failures} scenario(s) failed." >&2
  exit 1
fi
