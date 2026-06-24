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
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CONSUMER_DIR="${SCRIPT_DIR}/consumer"
LIBRARY_DIR="${REPO_ROOT}/helm/kubectl-apply-job"
RELEASE="test"

for bin in helm yq; do
  command -v "${bin}" >/dev/null 2>&1 || { echo "ERROR: '${bin}' is required but not installed" >&2; exit 1; }
done

# Provide the library chart as an unpacked subchart in consumer/charts.
#
# We copy the source directly instead of `helm dependency build`, which packages
# the chart into a .tgz cached by version: because we never bump the version for
# template-only changes, that cache would silently render stale chart content.
echo "==> Vendoring library chart into consumer/charts"
rm -rf "${CONSUMER_DIR}/charts"
mkdir -p "${CONSUMER_DIR}/charts/kubectl-apply-job"
cp -R "${LIBRARY_DIR}/." "${CONSUMER_DIR}/charts/kubectl-apply-job/"

failures=0

# assert "<scenario>" <docs> <configmaps> <separators> <helm args...>
#
# Two independent checks on the same render:
#   1. Parsed view  - yq counts non-null documents / ConfigMaps.
#   2. Raw view     - the literal number of `---` separator lines.
# Both drop by one when two manifests merge into a single document, so each
# catches the separator regression on its own.
assert() {
  local name="$1" want_total="$2" want_cm="$3" want_sep="$4"; shift 4

  local rendered
  rendered="$(helm template "${RELEASE}" "${CONSUMER_DIR}" "$@")"

  local total cm sep
  total="$(yq ea '[select(. != null)] | length' - <<<"${rendered}")"
  cm="$(yq ea '[select(.kind == "ConfigMap")] | length' - <<<"${rendered}")"
  sep="$(grep -cx -- '---' <<<"${rendered}" || true)"

  if [[ "${total}" == "${want_total}" && "${cm}" == "${want_cm}" && "${sep}" == "${want_sep}" ]]; then
    printf 'PASS  %-28s docs=%s configmaps=%s separators=%s\n' "${name}" "${total}" "${cm}" "${sep}"
  else
    printf 'FAIL  %-28s docs=%s (want %s) configmaps=%s (want %s) separators=%s (want %s)\n' \
      "${name}" "${total}" "${want_total}" "${cm}" "${want_cm}" "${sep}" "${want_sep}"
    failures=$((failures + 1))
  fi
}

# Base resources always rendered: NetworkPolicy, ServiceAccount, ClusterRole,
# ClusterRoleBinding, Job = 5. Add one ConfigMap per file, plus one
# CiliumNetworkPolicy when cilium is enabled. helm template emits one `---`
# separator per document, so the known-good separator count equals the doc count.
ONE="files/crd-a.yaml"
TWO="files/crd-a.yaml,files/crd-b.yaml"
THREE="files/crd-a.yaml,files/crd-b.yaml,files/crd-c.yaml"

echo "==> Running scenarios"
#      scenario              docs cm sep  args
assert "1 file, cilium off"  6 1 6 --set ciliumNetworkPolicy.enabled=false --set "kubectlApplyJob.files={${ONE}}"
assert "1 file, cilium on"   7 1 7 --set ciliumNetworkPolicy.enabled=true  --set "kubectlApplyJob.files={${ONE}}"
assert "2 files, cilium off" 7 2 7 --set ciliumNetworkPolicy.enabled=false --set "kubectlApplyJob.files={${TWO}}"
assert "2 files, cilium on"  8 2 8 --set ciliumNetworkPolicy.enabled=true  --set "kubectlApplyJob.files={${TWO}}"
assert "3 files, cilium off" 8 3 8 --set ciliumNetworkPolicy.enabled=false --set "kubectlApplyJob.files={${THREE}}"
assert "3 files, cilium on"  9 3 9 --set ciliumNetworkPolicy.enabled=true  --set "kubectlApplyJob.files={${THREE}}"

echo
if [[ "${failures}" -eq 0 ]]; then
  echo "All scenarios passed."
else
  echo "${failures} scenario(s) failed." >&2
  exit 1
fi
