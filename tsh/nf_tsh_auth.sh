nf_function nf_tsh_auth tsh "Request authorization to the Teleport service"
function nf_tsh_auth() {(set -euo pipefail
  REASON=${1:-""}
  ROLE=${2:-"customer-access"} # customer-access, demo-access

  if [[ -z ${REASON} || -z ${ROLE} ]]; then
    echo "Usage: ${0} REASON [ROLE]"

    return 1
  fi

  tsh login --request-roles="${ROLE}" --request-reason="${REASON}"
)}
