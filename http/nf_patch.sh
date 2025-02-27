nf_function nf_patch http "Make a PATCH request to the API"
function nf_patch() {
  URL_PATH=$(nf_url "${1}")
  BODY=${2}
  OPTIONS=(${@:3})

  if [[ ! ${BODY} ]]; then
    echo "Usage: ${0} URL_PATH JSON_BODY [OPTIONS...]"

    return 1
  fi

  curl ${NF_CURL_OPTIONS} ${OPTIONS} -X PATCH \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H 'Content-Type: application/json' \
    -d "${BODY}" \
    ${NF_SERVER}/api/${URL_PATH} | jq
}
