nf_function nf_tsh_login tsh "Login to the Teleport service"
function nf_tsh_login() {
  tsh login --proxy=teleport.nephroflow.com --auth=github
}
