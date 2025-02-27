nf_function nf_current_user authentication "Return the username of the user currently signed in"
function nf_current_user() {
  if [[ ! ${ACCESS_TOKEN} ]]; then
    echo "Not signed in"

    return 1
  fi

  NF_USERNAME=$(nf_get /api/current_user --no-show-error | jq -r '.user.username')

  if [[ "${NF_USERNAME}" != "" ]]; then
    echo "Signed in as ${NF_USERNAME}"

    return 0
  fi

  echo "Not signed in"

  return 1
}
