nf_function nf_db_dump database "Dump a database to a file"
function nf_db_dump() {(set -euo pipefail
  DATABASE=${1:-""}

  # Remove prefix
  DATABASE=${DATABASE#"${NF_DB_PREFIX}"}
  DATABASE=${DATABASE:-development}

  FILE=${2:-${NF_DB_PREFIX}${DATABASE}}
  FILE="${FILE%.sql}.sql.gz"

  if [[ ! ${DATABASE} ]]; then
    echo "Usage: ${0} DATABASE [FILE]"

    return 1
  fi

  echo "Dumping database ${NF_DB_PREFIX}${DATABASE} to ${FILE}"

  nf_compose exec postgres pg_dump -U postgres "${NF_DB_PREFIX}${DATABASE}" | gzip > "${FILE}"

  echo "Database ${NF_DB_PREFIX}${DATABASE} dumped to ${FILE}"
)}
