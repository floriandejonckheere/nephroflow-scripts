nf_function nf_db_load database "Load a database from a file"
function nf_db_load() {(set -euo pipefail
  # Remove prefix
  DATABASE=${1#"${NF_DB_PREFIX}"}
  DATABASE=${DATABASE:-development}

  FILE=${2:-${NF_DB_PREFIX}${DATABASE}}

  # Check if the file is a .sql file or a .gz file
  FILE="${FILE%.sql}.sql"
  if [[ ! -f "${FILE}" ]]; then
    FILE="${FILE}.gz"
  fi

  if [[ ! ${DATABASE} ]]; then
    echo "Usage: ${0} DATABASE [FILE]"

    return 1
  fi

  if [[ ! -f "${FILE}" ]]; then
    echo "File ${FILE} not found"

    return 1
  fi

  # Decompress file if necessary
  if [[ "${FILE}" == *.gz ]]; then
    gunzip -c "${FILE}" > "${FILE%.gz}"
    FILE="${FILE%.gz}"
  fi


  TYPE=$(file -b "${FILE}")
  if [[ "${TYPE}" == *"PostgreSQL custom database dump"* ]]; then
    # Use pg_restore for custom format
    echo "Loading database ${NF_DB_PREFIX}${DATABASE} from ${FILE} using pg_restore"

    nf_compose exec -T postgres pg_restore -U postgres -d "${NF_DB_PREFIX}${DATABASE}" < "${FILE}" > /dev/null || {
      echo "Failed to load database ${NF_DB_PREFIX}${DATABASE} from ${FILE}"
      return 1
    }
  else
    # Use psql for plain text format
    echo "Loading database ${NF_DB_PREFIX}${DATABASE} from ${FILE} using psql"

    nf_compose exec -T postgres psql -U postgres "${NF_DB_PREFIX}${DATABASE}" < "${FILE}" > /dev/null || {
      echo "Failed to load database ${NF_DB_PREFIX}${DATABASE} from ${FILE}"
      return 1
    }
  fi

  echo "Database ${NF_DB_PREFIX}${DATABASE} loaded from ${FILE}"
)}
