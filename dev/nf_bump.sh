nf_function nf_bump dev "Bump (patch) version in CHANGELOG.md"
function nf_bump() {(set -euo pipefail
  REPOSITORY=${1:-$(basename "${PWD}")}

  # Get today's date in YYYY-MM-DD format
  DATE=$(date +"%Y-%m-%d")

  # Extract the current version from CHANGELOG.md
  CURRENT_VERSION=$(grep -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" "${NF_PATH}/${REPOSITORY}/CHANGELOG.md" | head -1 | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/' || true)

  if [[ -z ${CURRENT_VERSION} ]]; then
    CURRENT_VERSION="$(nf_version)"
  fi

  if [[ -z ${CURRENT_VERSION} ]]; then
    echo "Error: Could not find a version number in CHANGELOG.md or version.rb"

    return 1
  fi

  # Split the version into major, minor, patch
  IFS='.' read -r MAJOR MINOR PATCH <<< "${CURRENT_VERSION}"

  # Version from version.rb does not have a patch version, set to -1 so it gets bumped to 0
  if [[ -z ${PATCH} ]]; then
    PATCH=-1
  fi

  # Increment the patch version
  NEW_PATCH=$((PATCH + 1))
  NEW_VERSION="${MAJOR}.${MINOR}.${NEW_PATCH}"

  # Write section
  gsed -i -e "s/^## \[Unreleased\]/## \[Unreleased\]\n\n## \[${NEW_VERSION}] - ${DATE}/" "${NF_PATH}/${REPOSITORY}/CHANGELOG.md"

  # Write hyperlinks
  if (( PATCH == -1 )); then
    # Make a guess at the previous version
    PREVIOUS_VERSION="${MAJOR}.$((MINOR - 1))"

    BRANCH=$(git rev-parse --abbrev-ref HEAD)

    gsed -i -e "s/^\[unreleased\].*/\[unreleased\]: https:\/\/github.com\/$(nf_repo | sed -e 's/\//\\\//g')\/compare\/v${NEW_VERSION}...${BRANCH}\n\[${NEW_VERSION}\]: https:\/\/github.com\/$(nf_repo | sed -e 's/\//\\\//g')\/compare\/release\/v${PREVIOUS_VERSION}..v${NEW_VERSION}/" -i "${NF_PATH}/${REPOSITORY}/CHANGELOG.md"
  else
    gsed -i -e "s/^\[unreleased\].*/\[unreleased\]: https:\/\/github.com\/$(nf_repo | sed -e 's/\//\\\//g')\/compare\/v${NEW_VERSION}...release\/v${MAJOR}.${MINOR}\n\[${NEW_VERSION}\]: https:\/\/github.com\/$(nf_repo | sed -e 's/\//\\\//g')\/compare\/v${CURRENT_VERSION}..v${NEW_VERSION}/" -i "${NF_PATH}/${REPOSITORY}/CHANGELOG.md"
  fi

  echo "Bumped CHANGELOG.md from ${CURRENT_VERSION} to version ${NEW_VERSION}"
)}
