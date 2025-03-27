nf_function nf_compose_file helper "Return the path to the Docker compose file"
function nf_compose_file() {
  COMPOSE_FILE="${NF_PATH}/nephroflow-api/compose.yaml"

  if [[ ! -f ${COMPOSE_FILE} ]]; then
    COMPOSE_FILE="${NF_PATH}/nephroflow-api/docker-compose.yml"
  fi

  if [[ ! -f ${COMPOSE_FILE} ]]; then
    echo "Error: ${COMPOSE_FILE} not found"

    return 1
  fi

  echo "${COMPOSE_FILE}"
}
