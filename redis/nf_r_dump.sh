nf_function nf_r_dump redis "Dump Redis database to a file"
function nf_r_dump() {(set -euo pipefail
  FILE=${1:-redis}
  FILE="${FILE%.rdb}.rdb"

  echo "Dumping Redis database to ${FILE}"

  nf_r "SAVE"
  nf_compose exec "$(nf_r_name)" sh -c "cat /data/dump.rdb" > "${FILE}"

  echo "Redis database dumped to ${FILE}"
)}
