nf_function nf_rel_bump release "Bump the version in CHANGELOG.md"
function nf_rel_bump() {
  REPOSITORY=${1:-nephroflow-api}

  # Get today's date in YYYY-MM-DD format
  DATE=$(date +"%Y-%m-%d")

  # Extract the current version from CHANGELOG.md
  CURRENT_VERSION=$(grep -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" "${NF_PATH}/${REPOSITORY}/CHANGELOG.md" | head -1 | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/')

  if [[ -z ${CURRENT_VERSION} ]]; then
    echo "Error: Could not find a version number in CHANGELOG.md"
    return 1
  fi

  # Split the version into major, minor, patch
  IFS='.' read -r MAJOR MINOR PATCH <<< "${CURRENT_VERSION}"

  # Increment the patch version
  NEW_PATCH=$((PATCH + 1))
  NEW_VERSION="${MAJOR}.${MINOR}.${NEW_PATCH}"

  # Create the new version header
  HEADER="\n## [${NEW_VERSION}] - ${DATE}"

  # Create temporary file
  FILE=$(mktemp)

  awk '
    # Insert the new version header
    /## \[Unreleased\]/ {
      print
      print "'"${HEADER}"'"
      next
    }

    # Update the release links at the bottom of the file
    # 1. Update the [unreleased] link to compare with the new version
    # 2. Add a new link for the new version
    # 3. Update the previous version link
    /\[unreleased\]:/ {
      print "[unreleased]: https://github.com/nephroflow/nephroflow-api/compare/v'"${NEW_VERSION}"'...release/v'"${MAJOR}"'.'"${MINOR}"'";
      print "['"${NEW_VERSION}"']: https://github.com/nephroflow/nephroflow-api/compare/v'"${CURRENT_VERSION}"'...v'"${NEW_VERSION}"'";
      next
    }
    {
      print
    }
  ' CHANGELOG.md > "${FILE}"

  # Move the temporary file back to CHANGELOG.md
  mv "${FILE}" "${NF_PATH}/${REPOSITORY}/CHANGELOG.md"

  echo "Bumped CHANGELOG.md from ${CURRENT_VERSION} to version ${NEW_VERSION}"
}
