nf_function nf_v docker "Start a NephroFlow API container (specific version)"
function nf_v() {
  VERSION=${1}

  if [[ $# -gt 1 ]]; then
    shift
    COMMAND=${*}
  else
    COMMAND="bash"
  fi

  if [[ -z ${VERSION} ]]; then
    echo "Usage: ${0} VERSION [COMMAND]"

    return 1
  fi

  COMPOSE_PATH="${NF_PATH_CLI}/compose/${VERSION}.yaml"

  if [[ ! -f "${COMPOSE_PATH}" ]]; then
    echo "Error: ${COMPOSE_PATH} not found"

    return 1
  fi

  echo "Starting NephroFlow API container (version: ${VERSION})"
  nf_compose -f "${COMPOSE_PATH}" run --rm --service-ports web "${COMMAND}"
}
