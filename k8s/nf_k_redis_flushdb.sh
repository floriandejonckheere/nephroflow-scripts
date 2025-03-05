nf_function nf_k_redis_flushdb k8s "database" "Flush remote Redis database"
function nf_k_redis_flushdb() {
  NAMESPACE=${1}

  if [[ -z ${NAMESPACE} ]]; then
    echo "Usage: ${0} NAMESPACE"

    return 1
  fi

  echo "Flushing Redis database in ${NAMESPACE} namespace"
  kubectl exec -ti -n "${NAMESPACE}" "${NAMESPACE}-resources-redis-master-0" -- redis-cli FLUSHDB > /dev/null
  echo "Redis database flushed"
}
