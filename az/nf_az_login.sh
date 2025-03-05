nf_function nf_az_login az "Log in to Azure"
function nf_az_login() {
  az login --tenant 364d007c-085f-4eac-8af2-138b2a043aea
  az acr login --name nephroflow
}
