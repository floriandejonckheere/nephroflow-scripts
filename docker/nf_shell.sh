nf_function nf_shell docker "Start a shell in the NephroFlow API container"
function nf_shell() {
  nf_compose run --rm web bash
}
