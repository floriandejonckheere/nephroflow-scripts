nf_function nf_v_shell docker "Start a shell in the NephroFlow API container (specific version)"
function nf_v_shell() {
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

  COMPOSE_FILE="${NF_PATH_CLI}/compose/${VERSION}.yaml"

  if [[ ! -f "${COMPOSE_FILE}" ]]; then
    echo "Error: ${COMPOSE_FILE} not found"

    return 1
  fi

  docker exec -ti nephroflow-web-${VERSION} bash
}
