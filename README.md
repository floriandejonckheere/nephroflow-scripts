# Nipro scripts

This repository contains convenience scripts for development at [NDTE](https://niprodigital.com).

## Prerequisites

- [Zsh](https://www.zsh.org)
- [jq](https://stedolan.github.io/jq/)
- [curl](https://curl.se/)
- [git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Kubernetes](https://kubernetes.io/)

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
git clone https://github.com/floriandejonckheere/nipro ~/.nipro/
```

Add the following line to your `.zshrc` file:

```bash
source ~/.nipro/nf.sh
```

## Usage

Use the `nf_help` command to get an overview of all available commands.

```bash
nf_help
```

## License

Copyright 2025 Nipro Digital Technologies Europe.
