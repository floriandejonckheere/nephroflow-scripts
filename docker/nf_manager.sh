nf_function nf_manager docker "Start NephroFlow Manager"
function nf_manager() {
  BRANCH=${1}

  (
    cd "${NF_PATH}/nephroflow-manager" || return
    [[ ${BRANCH} ]] && (git checkout ${BRANCH}; git pull --ff-only)
    corepack pnpm install
    corepack pnpm run dev
  )
}
