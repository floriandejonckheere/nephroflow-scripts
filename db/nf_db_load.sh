nf_function nf_db_load database "Load a database from a file"
function nf_db_load() {
  # Remove prefix
  DATABASE=${1#"${NF_DB_PREFIX}"}
  DATABASE=${DATABASE:-development}

  FILE=${2:-${NF_DB_PREFIX}${DATABASE}}
  FILE="${FILE%.sql}.sql.gz"

  if [[ ! ${DATABASE} ]]; then
    echo "Usage: ${0} DATABASE [FILE]"

    return 1
  fi

  echo "Loading database ${NF_DB_PREFIX}${DATABASE} from ${FILE}"

  gunzip -c "${FILE}" | nf_compose exec -T postgres psql -U postgres "${NF_DB_PREFIX}${DATABASE}" > /dev/null

  echo "Database ${NF_DB_PREFIX}${DATABASE} loaded from ${FILE}"
}
