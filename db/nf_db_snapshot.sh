nf_function nf_db_snapshot database "Create a timestamped snapshot of a database (by version)"
function nf_db_snapshot() {(set -euo pipefail
  DATABASE=${1:-""}

  # Remove prefix
  DATABASE=${DATABASE#"${NF_DB_PREFIX}"}
  DATABASE=${DATABASE:-development}

  # NephroFlow major version
  VERSION=$(sed -nE 's/ *DEV_VERSION = "([0-9]*)\.([0-9]*)\.[0-9]*.*"/\1_\2/p' "${NF_PATH}/nephroflow-api/lib/nephroflow/version.rb")

  # Remove .0 suffix
  VERSION=${VERSION%_0}

  echo "Creating snapshot of database ${NF_DB_PREFIX}${DATABASE} (version ${VERSION})"

  nf_db_copy "${DATABASE}" "${DATABASE}_${VERSION}_$(date +%Y%m%d)" > /dev/null

  echo "Database ${NF_DB_PREFIX}${DATABASE} snapshot ${DATABASE}_${VERSION}_$(date +%Y%m%d) created"
)}
