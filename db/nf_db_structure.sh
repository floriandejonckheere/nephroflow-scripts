nf_function nf_db_structure "Resolve schema migration conflicts in structure.sql automatically"
function nf_db_structure() {
  ruby "${NF_PATH_CLI}/db/nf_db_structure.rb" "${@}"
}
