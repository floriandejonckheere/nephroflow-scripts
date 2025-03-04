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

# Path to the NephroFlow scripts
export NF_PATH_CLI="${HOME}/.nf"

# Database prefix
export NF_DB_PREFIX=nephroflow_

# cURL options
declare -a NF_CURL_OPTIONS
export NF_CURL_OPTIONS=(--silent --fail --show-error)

##
# Help and usage
#
unset NF_CATEGORIES
declare -A NF_CATEGORIES

unset NF_FUNCTIONS
declare -A NF_FUNCTIONS

unset NF_CATEGORIES_TO_FUNCTIONS
declare -A NF_CATEGORIES_TO_FUNCTIONS

function nf_category() {
  NAME=${1}
  DESCRIPTION=${2}

  NF_CATEGORIES[${NAME}]="${DESCRIPTION}"
}

function nf_function() {
  NAME=${1}
  CATEGORY=${2}
  DESCRIPTION=${3}

  # Add to functions list
  NF_FUNCTIONS[${NAME}]="${DESCRIPTION}"

  # Append to category to functions list
  if [[ ! ${NF_CATEGORIES_TO_FUNCTIONS[${CATEGORY}]} ]]; then
    NF_CATEGORIES_TO_FUNCTIONS[${CATEGORY}]="${NAME}"
  else
    NF_CATEGORIES_TO_FUNCTIONS[${CATEGORY}]="${NF_CATEGORIES_TO_FUNCTIONS[${CATEGORY}]} ${NAME}"
  fi
}

# Define categories
nf_category helper "Helper functions"
nf_category configuration "Configuration functions"
nf_category authentication "Authentication functions"
nf_category http "HTTP functions"
nf_category database "Database functions"
nf_category docker "Docker functions"
nf_category dev "Development functions"
nf_category tsh "Teleport SSH functions"
nf_category k8s "Kubernetes functions"
nf_category az "Azure functions"

function nf_help() {
  echo "NephroFlow Scripts ${NF_VERSION}"

  # Loop over categories, and print functions in each category
  for CATEGORY in ${(k)NF_CATEGORIES}; do
    printf "\n%s\n" "${NF_CATEGORIES[${CATEGORY}]}"

    # Loop over functions in category
    for FUNCTION in ${(s: :)NF_CATEGORIES_TO_FUNCTIONS[${CATEGORY}]}; do
      printf "  %-30s %s\n" "${FUNCTION}" "${NF_FUNCTIONS[${FUNCTION}]}"
    done
  done
}

##
# Configuration functions
#
nf_function nf_server configuration "Set API server (default: http://localhost:3000)"
function nf_server() {
  SERVER=${1:-http://localhost:3000}

  export NF_SERVER=${SERVER}

  echo "API server set to ${SERVER}"
}

nf_function nf_path configuration "Set repositories path (default: ~/Code)"
function nf_path() {
  _PATH=${1:-~/Code}

  export NF_PATH=${_PATH}

  echo "Repositories path set to ${_PATH}"
}

nf_function nf_db_prefix configuration "Set database prefix (default: nephroflow_)"
function nf_db_prefix() {
  PREFIX=${1:-nephroflow_}

  export NF_DB_PREFIX=${PREFIX}

  echo "Database prefix set to ${PREFIX}"
}

nf_function nf_curl_options configuration "Set cURL options (default: ${NF_CURL_OPTIONS[*]})"
function nf_curl_options() {
  # shellcheck disable=SC2206
  NF_CURL_OPTIONS=(${=@:-"--silent" "--fail" "--show-error"})

  echo "cURL options set to ${NF_CURL_OPTIONS[*]}"
}

##
# Helper functions
#
nf_function nf_compose helper "Run docker compose command"
function nf_compose() {
  COMPOSE_FILE="${NF_PATH}/nephroflow-api/compose.yaml"

  if [[ ! -f ${COMPOSE_FILE} ]]; then
    COMPOSE_FILE="${NF_PATH}/nephroflow-api/docker-compose.yml"
  fi

  if [[ ! -f ${COMPOSE_FILE} ]]; then
    echo "Error: ${COMPOSE_FILE} not found"

    return 1
  fi

  docker compose -f "${COMPOSE_FILE}" "${@}"
}

nf_function nf_url helper "Strip protocol, ://, hostname, port, and /api from URL"
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

nf_function until_fail helper "Run a command until it fails"
function until_fail() {
  while "$@"; do :; done
}

##
# Load all scripts in the current directory
#
for FILE in $(find "${NF_PATH_CLI}" -name '*.sh' -not -path '*/nf.sh'); do
  source "${FILE}"
done
