nf_function nf_k_ns k8s "Get or set default namespace"
function nf_k_ns() {(set -euo pipefail
  NAMESPACE=${1:-""}

  if [[ -z ${NAMESPACE} ]]; then
    kubectl config view --minify --output 'jsonpath={..namespace}'

    return 0
  fi

  kubectl config set-context --current --namespace="${NAMESPACE}" > /dev/null

  echo "Namespace set to ${NAMESPACE}"
)}
