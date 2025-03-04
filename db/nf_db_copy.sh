nf_function nf_db_copy database "Copy a database"
function nf_db_copy() {
  # Remove prefix
  OLD_DATABASE=${1#"${NF_DB_PREFIX}"}
  NEW_DATABASE=${2#"${NF_DB_PREFIX}"}

  if [[ ! ${OLD_DATABASE} || ! ${NEW_DATABASE} ]]; then
    echo "Usage: ${0} OLD_DATABASE NEW_DATABASE"

    return 1
  fi

  echo "Copying database ${NF_DB_PREFIX}${OLD_DATABASE} to ${NF_DB_PREFIX}${NEW_DATABASE}"

  nf_db -c "CREATE DATABASE ${NF_DB_PREFIX}${NEW_DATABASE} TEMPLATE ${NF_DB_PREFIX}${OLD_DATABASE}" > /dev/null

  echo "Database ${NF_DB_PREFIX}${OLD_DATABASE} copied to ${NF_DB_PREFIX}${NEW_DATABASE}"
}
