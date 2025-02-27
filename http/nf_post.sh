nf_function nf_post http "Make a POST request to the API"
function nf_post() {
  URL_PATH=$(nf_url "${1}")
  BODY=${2}
  OPTIONS=(${@:3})

  if [[ ! ${BODY} ]]; then
    echo "Usage: ${0} URL_PATH JSON_BODY [OPTIONS...]"

    return 1
  fi

  curl ${NF_CURL_OPTIONS} ${OPTIONS} -X POST \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H 'Content-Type: application/json' \
    -d "${BODY}" \
    ${NF_SERVER}/api/${URL_PATH} | jq
}
