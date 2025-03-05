nf_function nf_k_scale k8s "Scale a pod up or down (default: debug pod)"
function nf_k_scale() {
  NAMESPACE=${1}
  POD=${2:-debug}
  REPLICAS=${3:-1}

  if [[ -z ${NAMESPACE} ]]; then
    echo "Usage: ${0} NAMESPACE [POD] [REPLICAS]"

    return 1
  fi

  echo "Scaling ${POD} pod to ${REPLICAS} in ${NAMESPACE}"
  kubectl scale deployment "${POD}" --namespace="${NAMESPACE}" --replicas="${REPLICAS}" > /dev/null
  echo "Pod scaled"
}
