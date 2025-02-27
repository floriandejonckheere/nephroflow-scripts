nf_function nf_tsh_forward tsh "Forward a local TCP port to a remote TCP port through Teleport"
function nf_tsh_forward() {
  HOST=${1}
  PORT=${2}
  LOCALPORT=$((8000 + PORT))

  if [[ ! ${HOST} || ! ${PORT} ]]; then
    echo "Usage: ${0} HOST PORT"

    return 1
  fi

  echo "Connecting to ${HOST}:${PORT}"

  tsh ssh -L 127.0.0.1:${LOCALPORT}:127.0.0.1:${PORT} nephroflow@${HOST}
}
