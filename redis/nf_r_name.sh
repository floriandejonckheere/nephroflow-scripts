nf_function nf_r_name redis "Return the name of the Redis or Valkey container"
function nf_r_name() {
  # Parse compose file
  REDIS=$(yq '.volumes | has("redis")' "$(nf_compose_file)")

  if [[ ${REDIS} == "true" ]]; then
    echo "redis"

    return
  fi

  VALKEY=$(yq '.volumes | has("valkey")' "$(nf_compose_file)")
  if [[ ${VALKEY} == "true" ]]; then
    echo "valkey"

    return
  fi

  echo "No Redis or Valkey container found in the compose file"

  return 1
}
