nf_function nf_r_load redis "Load Redis/Valkey database from a file"
function nf_r_load() {(set -euo pipefail
  FILE=${1:-redis}
  FILE="${FILE%.rdb}.rdb"

  echo "Restoring Redis/Valkey database from ${FILE}"

  nf_compose stop "$(nf_r_name)"
  nf_compose run --rm -T "$(nf_r_name)" sh -c "cat > /data/dump.rdb" < "${FILE}"
  nf_compose start "$(nf_r_name)"

  echo "Redis/Valkey database loaded from ${FILE}"
)}
