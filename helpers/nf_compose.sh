nf_function nf_compose helper "Run docker compose command"
nf_usage nf_compose "COMMAND"
function nf_compose() {
  docker compose -f "$(nf_compose_file)" "${@}"
}
