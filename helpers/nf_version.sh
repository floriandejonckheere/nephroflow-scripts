nf_function nf_version helpers "Parse the major/minor version from version.rb"
function nf_version() {(set -euo pipefail
  REPOSITORY=${1:-$(basename "${PWD}")}

  # Find version file
  FILE=$(find "${NF_PATH}/${REPOSITORY}/lib" -name version.rb -print0)

  # Extract version
  VERSION=$(sed -nE 's/ *DEV_VERSION = "([0-9]*)\.([0-9]*)\.[0-9]*.*"/\1.\2/p' "${FILE}")

  # Remove .0 suffix
  VERSION=${VERSION%_0}

  echo "${VERSION}"
)}
