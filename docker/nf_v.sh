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

  COMPOSE_FILE="${NF_PATH_CLI}/compose/api/${VERSION}.yaml"

  if [[ ! -f "${COMPOSE_FILE}" ]]; then
    echo "Error: ${COMPOSE_FILE} not found"

    return 1
  fi

  echo "Checking out NephroFlow version ${VERSION} at ${NF_PATH}/nephroflow-api"
  git -C "${NF_PATH}/nephroflow-api" checkout "release/v${VERSION}" || {
    echo "Error: Failed to checkout NephroFlow release branch version ${VERSION}"
    return 1
  }

  git -C "${NF_PATH}/nephroflow-api" pull --ff-only || {
    echo "Error: Failed to fetch latest changes from remote repository"
    return 1
  }

  echo "Starting NephroFlow API container (version: ${VERSION})"
  docker compose -f "${COMPOSE_FILE}" run --name "nephroflow-web-${VERSION}" --service-ports web "${COMMAND}"
}
