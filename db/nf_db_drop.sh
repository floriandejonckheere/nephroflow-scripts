nf_function nf_db_drop database "Drop a database"
function nf_db_drop() {
  if [[ ! ${1} ]]; then
    echo "Usage: ${0} DATABASE ..."

    return 1
  fi

  for DATABASE in "${@}"; do
    # Remove prefix
    DATABASE=${DATABASE#"${NF_DB_PREFIX}"}

    nf_db -c "DROP DATABASE ${NF_DB_PREFIX}${DATABASE}" > /dev/null

    echo "Database ${NF_DB_PREFIX}${DATABASE} dropped"
  done
}
