nf_function nf_refresh auth "Refresh the access token using the refresh token"
function nf_refresh() {
  OPTIONS=(${@})

  if [[ ! ${REFRESH_TOKEN} ]]; then
    echo "Error: REFRESH_TOKEN not set"

    return 1
  fi

  BODY=$(curl ${NF_CURL_OPTIONS} ${OPTIONS} -X POST \
    -H 'Content-Type: application/json' \
    -H "X-Refresh-Token: ${REFRESH_TOKEN}" \
    ${NF_SERVER}/api/auth/refresh)

  if [[ $(echo "${BODY}" | jq '.errors') != "null" ]]; then
    echo "Error refreshing token"

    return 1
  fi

  ACCESS_TOKEN=$(echo "${BODY}" | jq -r '.access')
  export ACCESS_TOKEN

  echo "Refreshed access token (valid until $(echo "${BODY}" | jq -r '.access_expires_at'))"
}
