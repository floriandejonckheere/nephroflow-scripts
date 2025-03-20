nf_function nf_rel release "Release a new version"
function nf_rel() {
  REPOSITORY=${1:-nephroflow-api}
  RELEASE=${2}

  if [[ -z ${RELEASE} ]]; then
    echo "Usage: ${0} REPOSITORY RELEASE"
    return 1
  fi

  echo "Checking out release branch ${RELEASE} for ${REPOSITORY}"
  git -C "${NF_PATH}/${REPOSITORY}" fetch --all
  git -C "${NF_PATH}/${REPOSITORY}" checkout "release/v${RELEASE}"

  # Update the version in CHANGELOG.md
  nf_rel_bump "${REPOSITORY}" || {
    echo "Error: Could not bump version in CHANGELOG.md"
    return 1
  }

  # Parse the new version from CHANGELOG.md
  NEW_VERSION=$(grep -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" "${NF_PATH}/${REPOSITORY}/CHANGELOG.md" | head -1 | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/')

  echo "Creating release v${NEW_VERSION}"
  git -C "${NF_PATH}/${REPOSITORY}" checkout -b "$(nf_initials)/v${NEW_VERSION}" || {
    echo "Error: Could not create branch $(nf_initials)/v${NEW_VERSION}"
    return 1
  }
  git -C "${NF_PATH}/${REPOSITORY}" add CHANGELOG.md || {
    echo "Error: Could not add CHANGELOG.md"
    return 1
  }
  git -C "${NF_PATH}/${REPOSITORY}" commit -m "Bump version to v${NEW_VERSION}" || {
    echo "Error: Could not commit CHANGELOG.md"
    return 1
  }

  git -C "${NF_PATH}/${REPOSITORY}" push origin "$(nf_initials)/v${NEW_VERSION}" || {
    echo "Error: Could not push branch $(nf_initials)/v${NEW_VERSION}"
    return 1
  }

  # Create a pull request
  gh pr create \
    --assignee "@me" \
    --base "release/v${RELEASE}" \
    --head "$(nf_initials)/v${NEW_VERSION}" \
    --title "[R${RELEASE}] Bump version to v${NEW_VERSION}" \
    --body "Bump version to v${NEW_VERSION}" \
    --reviewer "nephroflow/engineering" || {
      echo "Error: Could not create pull request"
      return 1
    }

  echo "Release v${NEW_VERSION} pull request created successfully"
}
