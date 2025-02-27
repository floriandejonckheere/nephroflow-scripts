nf_function nf_delete http "Make a DELETE request to the API"
function nf_delete() {
  URL_PATH=$(nf_url "${1}")
  OPTIONS=(${@:2})

  if [[ ! ${URL_PATH} ]]; then
    echo "Usage: ${0} URL_PATH [OPTIONS...]"

    return 1
  fi

  curl ${NF_CURL_OPTIONS} ${OPTIONS} -X DELETE \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    ${NF_SERVER}/api/${URL_PATH} | jq
}
