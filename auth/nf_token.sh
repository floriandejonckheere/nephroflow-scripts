nf_function nf_token authentication "Find or create an integration token and set token environment variables (default scope: link)"
function nf_token() {
  SCOPE=${1:-"link"}
  NAME="${SCOPE}-${RANDOM}"

  # Sign in as administrator (if necessary)
  nf_signin nephroflow admin &> /dev/null

  # Find or create integration token
  TOKEN=$(nf_post \
    ${NF_SERVER}/api/users/integration_tokens \
    "{\"name\":\"${NAME}\",\"scope\":\"${SCOPE}\",\"expiration_period\":\"1_month\"}" \
    | jq -r '.token')

  EXPIRATION=$(nf_get /api/users/integration_tokens | jq -r ".integration_tokens[] | select(.name == \"${NAME}\") | .expiration_at")

  ACCESS_TOKEN=${TOKEN}
  export ACCESS_TOKEN

  echo "Created integration token with scope ${SCOPE} (valid until ${EXPIRATION})"
}
