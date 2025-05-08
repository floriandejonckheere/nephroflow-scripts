nf_function nf_tsh_logout tsh "Log out of the Teleport service"
function nf_tsh_logout() {(set -euo pipefail
  tsh logout
)}
