nf_function nf_db_recreate database "Drop and recreate a database"
function nf_db_recreate() {(set -euo pipefail
  if [[ ! ${1} ]]; then
    echo "Usage: ${0} DATABASE ..."

    return 1
  fi

  for DATABASE in "${@}"; do
    nf_db_drop "${DATABASE}"
    nf_db_create "${DATABASE}"
  done
)}
