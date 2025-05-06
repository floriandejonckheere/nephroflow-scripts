nf_function nf_db_terminate database "Terminate all connections to a database"
function nf_db_terminate() {(set -euo pipefail
  DATABASE=${1:-development}

  # Remove prefix
  DATABASE=${DATABASE#"${NF_DB_PREFIX}"}

  echo "Terminating all connections to database ${NF_DB_PREFIX}${DATABASE}"

  nf_db -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND datname='${NF_DB_PREFIX}${DATABASE}'" > /dev/null

  echo "Connections to ${NF_DB_PREFIX}${DATABASE} terminated"
)}
