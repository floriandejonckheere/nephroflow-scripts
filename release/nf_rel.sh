nf_function nf_rel release "Bump the version in CHANGELOG.md and create a pull request for the release branch"
function nf_rel() {(set -euo pipefail
  REPOSITORY=${1:-nephroflow-api}
  RELEASE=${2}

  if [[ -z ${RELEASE} ]]; then
    echo "Usage: ${0} REPOSITORY RELEASE"
    return 1
  fi

  echo "Checking out release branch ${RELEASE} for ${REPOSITORY}"
  git -C "${NF_PATH}/${REPOSITORY}" checkout "release/v${RELEASE}"
  git -C "${NF_PATH}/${REPOSITORY}" pull origin "release/v${RELEASE}"

  # Update the version in CHANGELOG.md
  nf_rel_bump "${REPOSITORY}"

  # Parse the new version from CHANGELOG.md
  NEW_VERSION=$(grep -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" "${NF_PATH}/${REPOSITORY}/CHANGELOG.md" | head -1 | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/')

  echo "Creating release v${NEW_VERSION}"
  git -C "${NF_PATH}/${REPOSITORY}" checkout -b "$(nf_initials)/v${NEW_VERSION}"
  git -C "${NF_PATH}/${REPOSITORY}" add "${NF_PATH}/${REPOSITORY}/CHANGELOG.md"
  git -C "${NF_PATH}/${REPOSITORY}" commit -m "Bump version to v${NEW_VERSION}"
  git -C "${NF_PATH}/${REPOSITORY}" push origin "$(nf_initials)/v${NEW_VERSION}"

  # Create a pull request
  (cd "${NF_PATH}/${REPOSITORY}"; gh pr create \
    --assignee "@me" \
    --base "release/v${RELEASE}" \
    --head "$(nf_initials)/v${NEW_VERSION}" \
    --title "[R${RELEASE}] Bump version to v${NEW_VERSION}" \
    --body "Bump version to v${NEW_VERSION}." \
    --reviewer "nephroflow/engineering")

  echo "Release v${NEW_VERSION} pull request created successfully"
)}
