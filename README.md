# NephroFlow scripts

This repository contains convenience scripts for development at [NDTE](https://niprodigital.com).

## Prerequisites

- [Zsh](https://www.zsh.org)
- [jq](https://stedolan.github.io/jq/)
- [yq](https://github.com/mikefarah/yq)
- [curl](https://curl.se/)
- [git](https://git-scm.com/)
- [gzip](https://www.gnu.org/software/gzip/)
- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Github CLI](https://cli.github.com/)
- [GNU sed](https://www.gnu.org/software/sed/)
- [socat](http://www.dest-unreach.org/socat/)

Use the following command to install them using Homebrew:

```bash
brew install jq yq curl git gzip kubernetes-cli azure-cli gh gnu-sed socat
```

Clone the relevant repositories to your local machine:

```sh
mkdir ~/Code
cd ~/Code

git clone https://github.com/nephroflow/nephroflow-api.git
git clone https://github.com/nephroflow/nephroflow-manager.git
git clone https://github.com/nephroflow/link.git
```

## Installation

Clone the repository:

```bash
git clone https://github.com/floriandejonckheere/nephroflow-scripts ~/.nf/
```

Add the following line to your `.zshrc` file:

```bash
source ~/.nf/nf.sh
```

And configure your machine-specific settings:

```bash
nf_path <path_to_your_repositories>
nf_initials <your_initials> > /dev/null
```

## Usage

Use the `nf_help` command to get an overview of all available commands.

```bash
nf_help
```

### NephroFlow API (specific version)

This repository contains bare Docker compose files to run older versions of the NephroFlow API.
The compose files share the project name with the current version of the API, so the database and Redis containers will be shared.
The database name is suffixed with the version (e.g. `nephroflow_development_19_1`).

To start a container with a specific version of the NephroFlow API, use the following command:

```bash
nf_v 19.1
```

The container will be started with port 3000 exposed.

The image contains the installed gems at the moment of building.
Since `${NF_PATH}/nephroflow-api` is mounted to `/srv`, if there is a discrepancy between the installed gems and the ones in `Gemfile.lock`, Rails will not start.
Install the gems in the container with:

```bash
apt update
apt install -y build-essential libcurl4-openssl-dev git libxml2-dev libxslt-dev libpq-dev libicu-dev
bundle
```

If the PostgreSQL versions do not match, install the correct client version with:

```bash
apt update
apt install -y lsb-release wget gnupg
echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt update
apt install -y postgresql-client-16
```

## Development

Add new commands to their respective file in the respective folder (category).
Use the following template to add a new command:

```sh
# nf_function <name> <category> <description>
nf_function nf_my_func helpers "My helper function"
function nf_my_func() {
  ONE=${1}
  TWO=${2:-"Default value"}

  if [[ -z ${ONE} ]]; then
    echo "Usage: ${0} ONE [TWO]"

    return 1
  fi
  
  # Function body
}

# If you want the function to fail if a command fails, wrap it in set -e
function nf_my_func() {(set -euo pipefail
  # Function body
)}
```

Then, open a pull request to the `main` branch of this repository.

## License

(C) 2025 [Nipro Digital Technologies Europe](https://niprodigital.com/).
