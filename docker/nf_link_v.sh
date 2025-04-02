nf_function nf_link_v docker "Start a NephroFlow Link container (specific version)"
function nf_link_v() {
  VERSION=${1}

  if [[ $# -gt 1 ]]; then
    shift
    COMMAND=${*}
  else
    COMMAND="sh"
  fi

  if [[ -z ${VERSION} ]]; then
    echo "Usage: ${0} VERSION [COMMAND]"

    return 1
  fi

  COMPOSE_FILE="${NF_PATH_CLI}/compose/link/${VERSION}.yaml"

  if [[ ! -f "${COMPOSE_FILE}" ]]; then
    echo "Error: ${COMPOSE_FILE} not found"

    return 1
  fi

  echo "Checking out NephroFlow version ${VERSION} at ${NF_PATH}/link"
  git -C "${NF_PATH}/link" checkout "release/v${VERSION}" &> /dev/null || {
    echo "Error: Failed to checkout NephroFlow release branch version ${VERSION}"
    return 1
  }

  git -C "${NF_PATH}/link" pull --ff-only &> /dev/null || {
    echo "Error: Failed to fetch latest changes from remote repository"
    return 1
  }

  clr_bold "Starting NephroFlow Link container (version: ${VERSION})"
  docker compose -f "${COMPOSE_FILE}" run --rm --name "link-${VERSION}" --service-ports link "${COMMAND}"
}
