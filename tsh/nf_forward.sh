nf_function nf_forward tsh "Forward a local (privileged) TCP port to a local TCP port"
function nf_forward() {(set -euo pipefail
  FROM=${1:-""}
  TO=${2:-""}

  if [[ -z ${FROM} || -z ${TO} ]]; then
    echo "Usage: ${0} FROM TO"

    return 1
  fi

  echo "Forwarding local port ${FROM} to ${TO}"

  if [[ ${FROM} -lt 1024 ]]; then
    sudo socat" TCP-LISTEN:${FROM},reusaddr,fork" "TCP:127.0.0.1:${TO}"
  else
    socat "TCP-LISTEN:${FROM},reusaddr,fork" "TCP:127.0.0.1:${TO}"
  fi
)}
