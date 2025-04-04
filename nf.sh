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

export NF_INITIALS

##
# Help and usage
#
unset NF_CATEGORIES
declare -A NF_CATEGORIES

unset NF_FUNCTIONS
declare -A NF_FUNCTIONS

unset NF_USAGE
declare -A NF_USAGE

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

function nf_usage() {
  NAME=${1}
  USAGE=${2}

  if [[ -z ${NAME} || -z ${USAGE} ]]; then
    echo "Usage: ${0} NAME USAGE"

    return 1
  fi

  if [[ ! ${NF_FUNCTIONS[${NAME}]} ]]; then
    echo "Error: ${NAME} is not a valid function"

    return 1
  fi

  # Add to usage list
  NF_USAGE[${NAME}]="${USAGE}"
}

# Define categories
nf_category helper "Helper functions"
nf_category config "Configuration functions"
nf_category auth "Authentication functions"
nf_category http "HTTP functions"
nf_category database "Database functions"
nf_category docker "Docker functions"
nf_category dev "Development functions"
nf_category redis "Redis functions"
nf_category tsh "Teleport SSH functions"
nf_category k8s "Kubernetes functions"
nf_category az "Azure functions"

function nf_help() {
  COMMAND=${1}

  if [[ -z ${COMMAND} ]]; then
    echo "NephroFlow Scripts ${NF_VERSION}"

    # Loop over categories, and print functions in each category
    for CATEGORY in ${(k)NF_CATEGORIES}; do
      printf "\n%s\n" "${NF_CATEGORIES[${CATEGORY}]}"

      # Loop over functions in category
      for FUNCTION in ${(s: :)NF_CATEGORIES_TO_FUNCTIONS[${CATEGORY}]}; do
        printf "  %-30s %s\n" "${FUNCTION}" "${NF_FUNCTIONS[${FUNCTION}]}"
      done
    done
  else
    echo "${COMMAND}: ${NF_FUNCTIONS[${COMMAND}]}"
    echo "Usage: ${COMMAND} ${NF_USAGE[${COMMAND}]}"
  fi
}

##
# Configuration functions
#
nf_function nf_server config "Set API server (default: http://localhost:3000)"
nf_usage nf_server "[SERVER]"
function nf_server() {
  SERVER=${1:-http://localhost:3000}

  export NF_SERVER=${SERVER}

  echo "API server set to ${SERVER}"
}

nf_function nf_path config "Set repositories path (default: ~/Code)"
nf_usage nf_path "[PATH]"
function nf_path() {
  _PATH=${1:-~/Code}

  export NF_PATH=${_PATH}

  echo "Repositories path set to ${_PATH}"
}

nf_function nf_db_prefix config "Set database prefix (default: nephroflow_)"
nf_usage nf_db_prefix "[PREFIX]"
function nf_db_prefix() {
  PREFIX=${1:-nephroflow_}

  export NF_DB_PREFIX=${PREFIX}

  echo "Database prefix set to ${PREFIX}"
}

nf_function nf_curl_options config "Set cURL options (default: ${NF_CURL_OPTIONS[*]})"
nf_usage nf_curl_options "[OPTIONS]"
function nf_curl_options() {
  # shellcheck disable=SC2206
  NF_CURL_OPTIONS=(${=@:-"--silent" "--fail" "--show-error"})

  echo "cURL options set to ${NF_CURL_OPTIONS[*]}"
}

nf_function nf_initials config "Get or set initials for the current user"
nf_usage nf_initials "[INITIALS]"
function nf_initials() {
  INITIALS=${1}

  if [[ -z ${INITIALS} ]]; then
    if [[ -z ${NF_INITIALS} ]]; then
      echo "Initials not set. Please configure your initials using 'nf_initials <initials>'"

      return 1
    fi

    echo "${NF_INITIALS}"
  else
    if [[ ! ${INITIALS} =~ ^[a-zA-Z]{2,3}$ ]]; then
      echo "Error: Initials must be 2 or 3 letters"

      return 1
    fi

    export NF_INITIALS=${INITIALS}

    echo "Initials set to ${INITIALS}"
  fi
}

##
# Load all scripts in the current directory
#
for FILE in $(find "${NF_PATH_CLI}" -name '*.sh' -not -path '*/nf.sh'); do
  source "${FILE}"
done
