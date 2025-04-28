nf_function nf_shell docker "Start a shell in the NephroFlow API container (exposed port 3000 if not running already) "
function nf_shell() {
  if docker ps --format '{{.Names}}' | grep -q '^web$'; then
    echo "Starting shell in web container"
    nf_compose run --rm web bash
  else
    echo "Starting shell in web container (port 3000)"
    nf_compose run --rm --name web --service-ports web bash
  fi
}
