nf_function until_fail helper "Run a command until it fails"
nf_usage until_fail "COMMAND"
function until_fail() {
  while "$@"; do :; done
}
