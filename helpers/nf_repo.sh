nf_function nf_repo helper "Return the relative path to the GitHub repository"
function nf_repo() {
  git remote get-url origin | sed -e 's/.*github.com[\/:]//g' -e 's/\.git$//g'
}
