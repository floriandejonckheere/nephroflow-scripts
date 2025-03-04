nf_function nf_k_db database "Open a database console on a remote database"
function nf_k_db() {
  NAMESPACE=${1}

  if [[ -z ${NAMESPACE} ]]; then
    echo "Usage: ${0} NAMESPACE"

    return 1
  fi

  shift

  POD=$(kubectl get pods -n "${NAMESPACE}" -l app=api -o jsonpath='{.items[0].metadata.name}')

  kubectl exec -ti -n "${NAMESPACE}" "${POD}" -- bash -c "eval 'PGPASSWORD=\${PG_PASSWORD} psql -P pager -h \${PG_HOST} -p \${PG_PORT} -U \${PG_USERNAME} -d \${PG_DATABASE}'"
}
