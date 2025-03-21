nf_function nf_db_restore database "Restore (copy) the latest snapshot of a database (by version)"
function nf_db_restore() {
    # Remove prefix
  DATABASE=${1#"${NF_DB_PREFIX}"}
  DATABASE=${DATABASE:-development}

  # NephroFlow major version
  VERSION=${2/./_}
  VERSION=${VERSION:-$(sed -nE 's/ *DEV_VERSION = "([0-9]*)\.([0-9]*)\.[0-9]*.*"/\1_\2/p' "${NF_PATH}/nephroflow-api/lib/nephroflow/version.rb")}

  # Remove .0 suffix
  VERSION=${VERSION%_0}

  # Find latest snapshot
  LATEST=$(nf_db_ls | cut -d '|' -f1 | grep "${DATABASE}_${VERSION}_" | sort -r | head -n 1)

  if [[ "${LATEST}" == "" ]]; then
    echo "Error: No snapshots found for ${NF_DB_PREFIX}${DATABASE} version ${VERSION}"

    return 1
  fi

  if [[ $(nf_db_ls | cut -d '|' -f1 | grep "${NF_DB_PREFIX}${DATABASE}$") != "" ]]; then
    echo "Error: Database ${NF_DB_PREFIX}${DATABASE} already exists"

    return 1
  fi

  echo "Restoring database ${NF_DB_PREFIX}${DATABASE} from ${LATEST} (version ${VERSION})"

  nf_db_copy "${LATEST}" "${DATABASE}" > /dev/null

  echo "Database ${NF_DB_PREFIX}${DATABASE} restored from ${LATEST} (version ${VERSION})"
}
