nf_function nf_db_create database "Create an empty database"
function nf_db_create() {(set -euo pipefail
  if [[ ! ${1} ]]; then
    echo "Usage: ${0} DATABASE ..."

    return 1
  fi

  for DATABASE in "${@}"; do
    # Remove prefix
    DATABASE=${DATABASE#"${NF_DB_PREFIX}"}

    echo "Creating database ${NF_DB_PREFIX}${DATABASE}"

    nf_db -c "CREATE DATABASE ${NF_DB_PREFIX}${DATABASE}" > /dev/null

    echo "Database ${NF_DB_PREFIX}${DATABASE} created"
  done
)}
