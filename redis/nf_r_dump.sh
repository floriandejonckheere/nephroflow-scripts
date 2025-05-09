nf_function nf_r_dump redis "Dump Redis/Valkey database to a file"
function nf_r_dump() {(set -euo pipefail
  FILE=${1:-redis}
  FILE="${FILE%.rdb}.rdb"

  echo "Dumping Redis/Valkey database to ${FILE}"

  nf_r "SAVE"
  nf_compose exec "$(nf_r_name)" sh -c "cat /data/dump.rdb" > "${FILE}"

  echo "Redis/Valkey database dumped to ${FILE}"
)}
