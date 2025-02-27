nf_function nf_signout authentication "Sign out and clear token environment variables"
function nf_signout() {
  OPTIONS=(${@})

    if [[ ! ${REFRESH_TOKEN} ]]; then
      echo "Error: REFRESH_TOKEN not set"

      return 1
    fi

  BODY=$(curl ${NF_CURL_OPTIONS} ${OPTIONS} -X DELETE \
    -H 'Content-Type: application/json' \
    -H "X-Refresh-Token: ${REFRESH_TOKEN}" \
    ${NF_SERVER}/api/auth)

  if [[ $? -eq 22 ]]; then
    echo "Error signing out"

    return 1
  fi

  unset ACCESS_TOKEN
  unset REFRESH_TOKEN

  echo "Signed out"
}
