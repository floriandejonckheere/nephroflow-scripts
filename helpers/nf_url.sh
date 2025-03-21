nf_function nf_url helper "Strip protocol, ://, hostname, port, and /api from URL"
nf_usage nf_url "URL"
function nf_url() {
  URL=${1}

  if [[ ! ${URL} ]]; then
    echo "Usage: ${0} URL"

    return 1
  fi

  # Strip protocol, ://, hostname, port, and /api
  URL=$(echo "${URL}" | sed -E 's/^\s*(.*:\/\/)?[^\/]*\/?api\/?//g')

  echo "${URL}"
}
