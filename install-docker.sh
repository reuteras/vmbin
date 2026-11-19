#!/bin/bash

# Exit if no /etc/os-release file
if [[ ! -f /etc/os-release ]]; then
	echo "No /etc/os-release - can't determine OS"
	exit
fi

# Add the invoking user to the docker group so docker can be used without sudo
add_user_to_docker_group() {
	local target_user="${SUDO_USER:-$USER}"
	if [[ -z "$target_user" || "$target_user" == "root" ]]; then
		echo "Not adding root to the docker group."
		return
	fi
	sudo groupadd -f docker
	sudo usermod -aG docker "$target_user"
	echo "Added $target_user to the docker group. Log out and back in (or run 'newgrp docker') for it to take effect."
}

# Remove conflicting packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg"
done

# For Ubuntu from https://docs.docker.com/engine/install/ubuntu/
if grep PRETTY_NAME /etc/os-release | grep "Ubuntu" > /dev/null ; then
   # Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	# shellcheck disable=SC1091
	echo \
  		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update

	# Install Docker and related tools
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	add_user_to_docker_group

	exit
fi

# For Debian from https://docs.docker.com/engine/install/debian/
if grep PRETTY_NAME /etc/os-release | grep -E "(Debian|Kali)" > /dev/null ; then
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	# shellcheck disable=SC1091
    VERSION_CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
    if [[ "$VERSION_CODENAME" == "kali-rolling" ]]; then
        VERSION_CODENAME="bookworm"
    fi
	# shellcheck disable=SC1091
	echo \
  		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  		$VERSION_CODENAME stable" | \
  		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update

	# Install Docker and related tools
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	add_user_to_docker_group

	exit
fi
