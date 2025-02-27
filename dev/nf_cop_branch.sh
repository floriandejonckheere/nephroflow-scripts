nf_function nf_cop_branch dev "Autocorrect RuboCop offenses in changed files (compared to a branch)"
function nf_branchcop() {
  BRANCH=${1:-$(git_main_branch)}

  git diff-tree -r --no-commit-id --name-only ${BRANCH}@\{u\} head | xargs ls -1 2>/dev/null | xargs rubocop --autocorrect-all --force-exclusion
}
