nf_function nf_compose helper "Run docker compose command"
nf_usage nf_compose "COMMAND"
function nf_compose() {
  COMPOSE_FILE="${NF_PATH}/nephroflow-api/compose.yaml"

  if [[ ! -f ${COMPOSE_FILE} ]]; then
    COMPOSE_FILE="${NF_PATH}/nephroflow-api/docker-compose.yml"
  fi

  if [[ ! -f ${COMPOSE_FILE} ]]; then
    echo "Error: ${COMPOSE_FILE} not found"

    return 1
  fi

  docker compose -f "${COMPOSE_FILE}" "${@}"
}
