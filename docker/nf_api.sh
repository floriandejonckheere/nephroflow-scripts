nf_function nf_api docker "Start NephroFlow API server"
function nf_api() {
  nf_compose run --rm --service-ports web rails s -b 0.0.0.0
}
