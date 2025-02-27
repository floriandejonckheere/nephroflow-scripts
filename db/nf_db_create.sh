nf_function nf_db_create database "Create an empty database"
function nf_db_create() {
  if [[ ! ${1} ]]; then
    echo "Usage: ${0} DATABASE ..."

    return 1
  fi

  for DATABASE in "${@}"; do
    nf_db -c "CREATE DATABASE ${NF_DB_PREFIX}${DATABASE}" > /dev/null

    echo "Database ${NF_DB_PREFIX}${DATABASE} created"
  done
}
