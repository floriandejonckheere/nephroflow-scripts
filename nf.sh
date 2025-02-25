#!/usr/bin/env zsh

##
# Variables
#

# Application version
export NF_VERSION="0.0.1"

# URL for the NephroFlow API server
export NF_SERVER=http://localhost:3000

# Path to directory containing the repositories
export NF_PATH=~/Code

# Path to the NephroFlow CLI
export NF_PATH_CLI="${HOME}/.nipro"

# Database prefix
export NF_DB_PREFIX=nephroflow_

# cURL options
declare -a NF_CURL_OPTIONS
export NF_CURL_OPTIONS=(--silent --fail --show-error)

# Import scripts
for FILE in $(find "${NF_PATH_CLI}" -name '*.sh' -not -path '*/nf.sh'); do
  source "${FILE}"
done

##
# Help and usage
#
unset NF_FUNCTION_NAMES
declare -a NF_FUNCTION_NAMES

unset NF_FUNCTION_DESCRIPTIONS
declare -a NF_FUNCTION_DESCRIPTIONS

function nf_function() {
  NAME=${1}
  DESCRIPTION=${2}

  NF_FUNCTION_NAMES+=("${NAME}")
  NF_FUNCTION_DESCRIPTIONS+=("${DESCRIPTION}")
}

function nf_help() {
  echo "NephroFlow CLI ${NF_VERSION}"

  for i in $(seq 1 ${#NF_FUNCTION_NAMES[@]}); do
    printf "  %-30s %s\n" "${NF_FUNCTION_NAMES[$i]}" "${NF_FUNCTION_DESCRIPTIONS[$i]}"
  done
}

##
# Configuration functions
#

nf_function nf_server "Set API server (default: http://localhost:3000)"
function nf_server() {
  SERVER=${1:-http://localhost:3000}

  export NF_SERVER=${SERVER}

  echo "API server set to ${SERVER}"
}

nf_function nf_path "Set repositories path (default: ~/Code)"
function nf_path() {
  _PATH=${1:-~/Code}

  export NF_PATH=${_PATH}

  echo "Repositories path set to ${_PATH}"
}

nf_function nf_db_prefix "Set database prefix (default: nephroflow_)"
function nf_db_prefix() {
  PREFIX=${1:-nephroflow_}

  export NF_DB_PREFIX=${PREFIX}

  echo "Database prefix set to ${PREFIX}"
}

nf_function nf_curl_options "Set cURL options (default: ${NF_CURL_OPTIONS[*]})"
function nf_curl_options() {
  # shellcheck disable=SC2206
  NF_CURL_OPTIONS=(${=@:-"--silent" "--fail" "--show-error"})

  echo "cURL options set to ${NF_CURL_OPTIONS[*]}"
}

##
# Helper functions
#
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
