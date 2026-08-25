#!/bin/bash

# Get python3 version
PYTHON_VERSION=$(dpkg --list | grep -Eo "python3\.[0-9]+" | uniq | tail -1)

sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-dev "${PYTHON_VERSION}-venv" git libssl-dev libffi-dev build-essential

# Ugly curl | sh install but this is for CTF VMs
which uv || curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install pwntools
