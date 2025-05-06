nf_function nf_db_ls database "List all databases"
function nf_db_ls() {(set -euo pipefail
  nf_db -t -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) FROM pg_database WHERE datistemplate = false AND datname <> 'postgres' ORDER BY datname" | tr -s '\n' | sed 's/^ *//'
)}
