#!/bin/bash

# Get python3 version
PYTHON_VERSION=$(dpkg --list | grep -Eo "python3\.[0-9]+" | uniq | tail -1)

sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-dev "${PYTHON_VERSION}-venv" git libssl-dev libffi-dev build-essential

[[ ! -d ~/src/virtualenvs ]] && mkdir ~/src/virtualenvs

python3 -m venv ~/src/virtualenvs/pwntools
# shellcheck disable=SC1090
. ~/src/virtualenvs/pwntools/bin/activate && python -m pip install --upgrade pip
# shellcheck disable=SC1090
. ~/src/virtualenvs/pwntools/bin/activate && python -m pip install --upgrade pwntools
