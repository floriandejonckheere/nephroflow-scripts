nf_function nf_bump dev "Bump (patch) version in CHANGELOG.md"
function nf_bump() {(set -euo pipefail
  # Parse current version
  VERSION=$(grep '^\[unreleased\]' CHANGELOG.md | sed -e 's/.*compare\/v\([0-9]*\).\([0-9]*\).\([0-9]*\).*/\1.\2.\3/g')

  # Split version into major, minor, and patch
  MAJOR=$(echo "${VERSION}" | cut -d '.' -f 1)
  MINOR=$(echo "${VERSION}" | cut -d '.' -f 2)
  PATCH=$(echo "${VERSION}" | cut -d '.' -f 3)
  OLD_PATCH=${PATCH}

  # Increment patch
  PATCH=$((PATCH + 1))

  # Write section
  gsed -i -e "s/^## \[Unreleased\]/## \[Unreleased\]\n\n## \[${MAJOR}.${MINOR}.${PATCH}] - $(date '+%Y-%m-%d')/" CHANGELOG.md

  # Write hyperlinks
  gsed -i -e "s/^\[unreleased\].*/\[unreleased\]: https:\/\/github.com\/$(nf_repo | sed -e 's/\//\\\//g')\/compare\/v${MAJOR}.${MINOR}.${PATCH}..release\/v${MAJOR}.${MINOR}\n\[${MAJOR}.${MINOR}.${PATCH}\]: https:\/\/github.com\/$(nf_repo | sed -e 's/\//\\\//g')\/compare\/v${MAJOR}.${MINOR}.${OLD_PATCH}..v${MAJOR}.${MINOR}.${PATCH}/" -i CHANGELOG.md

  echo "Bumped version to ${MAJOR}.${MINOR}.${PATCH}"
)}
