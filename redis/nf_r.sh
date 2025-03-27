nf_function nf_r redis "Open a Redis console"
function nf_r() {
  nf_compose exec "$(nf_r_name)" "$(nf_r_name)-cli" "${@}"
}
