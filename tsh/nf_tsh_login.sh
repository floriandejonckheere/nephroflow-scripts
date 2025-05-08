nf_function nf_tsh_login tsh "Login to the Teleport service"
function nf_tsh_login() {(set -euo pipefail
  PROXY=${1:-"teleport.nephroflow.com"} # teleport.nephroflow.com, teleport.ahctapps.aarogyasri.telangana.gov.in

  tsh login --proxy="${PROXY}"
)}
