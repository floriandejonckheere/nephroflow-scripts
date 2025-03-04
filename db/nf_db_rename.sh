nf_function nf_db_rename database "Rename a database"
function nf_db_rename() {
  # Remove prefix
  OLD_DATABASE=${1#"${NF_DB_PREFIX}"}
  NEW_DATABASE=${2#"${NF_DB_PREFIX}"}

  if [[ ! ${OLD_DATABASE} || ! ${NEW_DATABASE} ]]; then
    echo "Usage: ${0} OLD_DATABASE NEW_DATABASE"

    return 1
  fi

  echo "Renaming database ${NF_DB_PREFIX}${OLD_DATABASE} to ${NF_DB_PREFIX}${NEW_DATABASE}"

  nf_db -c "ALTER DATABASE ${NF_DB_PREFIX}${OLD_DATABASE} RENAME TO ${NF_DB_PREFIX}${NEW_DATABASE}" > /dev/null

  echo "Database ${NF_DB_PREFIX}${OLD_DATABASE} renamed to ${NF_DB_PREFIX}${NEW_DATABASE}"
}
