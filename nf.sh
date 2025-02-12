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

# Database prefix
export NF_DB_PREFIX=nephroflow_

# cURL options
declare -a NF_CURL_OPTIONS
export NF_CURL_OPTIONS=(--silent --fail --show-error)

# Import scripts
source ./**/*.sh

##
# Help and usage
#
function nf_help() {
  echo "NephroFlow CLI ${NF_VERSION}"
}

##
# Configuration functions
#

# Set default API server (default: http://localhost:3000)
function nf_server() {
  SERVER=${1:-http://localhost:3000}

  export NF_SERVER=${SERVER}

  echo "API server set to ${SERVER}"
}

function nf_path() {
  _PATH=${1:-~/Code}

  export NF_PATH=${_PATH}

  echo "Repositories path set to ${_PATH}"
}

# Set default database prefix (default: nephroflow_)
function nf_db_prefix() {
  PREFIX=${1:-nephroflow_}

  export NF_DB_PREFIX=${PREFIX}

  echo "Database prefix set to ${PREFIX}"
}

# Set default curl options (default: --silent --show-error)
function nf_curl_options() {
  # shellcheck disable=SC2206
  NF_CURL_OPTIONS=(${=@:-"--silent" "--fail" "--show-error"})

  echo "cURL options set to ${NF_CURL_OPTIONS[*]}"
}

# Strip the API server from the URL
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
