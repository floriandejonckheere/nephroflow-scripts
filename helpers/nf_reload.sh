nf_function nf_reload helper "Reload all scripts"
function nf_reload() {
  source "${NF_PATH_CLI}/nf.sh"
  echo "Reloaded all scripts"
}
