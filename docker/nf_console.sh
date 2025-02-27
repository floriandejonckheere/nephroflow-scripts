nf_function nf_console docker "Start a Rails console in the NephroFlow API container"
function nf_console() {
  nf_compose run --rm web rails c
}
