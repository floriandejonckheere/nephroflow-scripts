nf_function nf_db database "Open a database console"
function nf_db() {
  nf_compose exec postgres psql -P pager -U postgres "${@}"
}
