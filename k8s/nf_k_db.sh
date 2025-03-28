nf_function nf_k_db database "Open a database console on a remote database"
function nf_k_db() {
  NAMESPACE=${1}

  if [[ -z ${NAMESPACE} ]]; then
    echo "Usage: ${0} NAMESPACE"

    return 1
  fi

  shift

  POD=$(kubectl get pods -n "${NAMESPACE}" | grep 'api-\|debug-' | head -1 | awk '{print $1}')

  if [[ -z ${POD} ]]; then
    echo "No api or debug pod found in ${NAMESPACE} namespace"

    return 1
  fi

  echo "Opening database console on ${NAMESPACE}"
  kubectl exec -ti -n "${NAMESPACE}" "${POD}" -- bash -c "eval 'PGPASSWORD=\${PG_PASSWORD} psql -P pager -h \${PG_HOST} -p \${PG_PORT} -U \${PG_USERNAME} -d \${PG_DATABASE}'"
}
