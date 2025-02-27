nf_function nf_cop_diff dev "Autocorrect RuboCop offenses in changed files (staged only)"
function nf_cop_diff() {
  git diff --staged --name-only | grep '\.rb$' | xargs rubocop --autocorrect-all --force-exclusion
}
