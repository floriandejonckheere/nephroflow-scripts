# NephroFlow scripts

This repository contains convenience scripts for development at [NDTE](https://niprodigital.com).

## Prerequisites

- [Zsh](https://www.zsh.org)
- [jq](https://stedolan.github.io/jq/)
- [curl](https://curl.se/)
- [git](https://git-scm.com/)
- [gzip](https://www.gnu.org/software/gzip/)
- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

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

## License

(C) 2025 [Nipro Digital Technologies Europe](https://niprodigital.com/).
