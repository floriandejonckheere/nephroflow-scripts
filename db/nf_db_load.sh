nf_function nf_db_load database "Load a database from a file"
function nf_db_load() {
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

  echo "Loading database ${NF_DB_PREFIX}${DATABASE} from ${FILE}"

  if [[ "${FILE}" == *.sql ]]; then
    # If the file is a .sql file, use psql to load it
    nf_compose exec -T postgres psql -U postgres "${NF_DB_PREFIX}${DATABASE}" < "${FILE}" || {
      echo "Failed to load database ${NF_DB_PREFIX}${DATABASE} from ${FILE}"
      return 1
    }
  else
    # If the file is a .gz file, use gunzip to decompress it and then pipe it to psql
    gunzip -c "${FILE}" | nf_compose exec -T postgres psql -U postgres "${NF_DB_PREFIX}${DATABASE}" > /dev/null || {
      echo "Failed to load database ${NF_DB_PREFIX}${DATABASE} from ${FILE}"
      return 1
    }
  fi

  echo "Database ${NF_DB_PREFIX}${DATABASE} loaded from ${FILE}"
}
