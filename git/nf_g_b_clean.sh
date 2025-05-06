nf_function nf_g_b_clean git "Clean version bump branches"
function nf_g_b_clean() {
  git branch --delete $(nf_initials)/v{{1,2}{2,34,6,7,8,9},5}.{0,1,2} 2> /dev/null
}
