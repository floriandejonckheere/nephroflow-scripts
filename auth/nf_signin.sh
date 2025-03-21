nf_function nf_signin auth "Sign in as a user and set token environment variables (default username: henry.davidson)"
function nf_signin() {
  USER=${1:-henry.davidson}
  PASSWORD=${2:-password}
  OPTIONS=(${@:3})

  BODY=$(curl ${NF_CURL_OPTIONS} ${OPTIONS} -X POST \
    -d "{\"username\": \"${USER}\", \"password\": \"${PASSWORD}\"}" \
    -H 'Content-Type: application/json' \
    ${NF_SERVER}/api/auth)

  if [[ $(echo "${BODY}" | jq '.errors') != "null" ]]; then
    echo "Error signing in: $(echo "${BODY}" | jq -r '.errors[0].title')"

    return 1
  fi

  REFRESH_TOKEN=$(echo "${BODY}" | jq -r '.refresh')
  export REFRESH_TOKEN

  ACCESS_TOKEN=$(echo "${BODY}" | jq -r '.access')
  export ACCESS_TOKEN

  echo "Signed in as ${USER} (valid until $(echo "${BODY}" | jq -r '.refresh_expires_at'))"
}
