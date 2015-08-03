#!/usr/bin/env bash

# Install Docker
sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker vagrant

# Pull down the consul image
docker pull marcelocenerine/consul

# Gets the VM and Docker IPs

function getInterfaceIp() {
    echo "$(ifconfig $1 | awk -F ' *|:' '/inet addr/{print $4}')"
}

PUBLIC_IP=$(getInterfaceIp 'eth1')
DOCKER_IP=$(getInterfaceIp 'docker0')

echo "export PUBLIC_IP=${PUBLIC_IP}" >> ~/.profile

# Configure Docker to use Consul to resolve DNS
sudo echo "DOCKER_OPTS='--dns ${DOCKER_IP} --dns 8.8.8.8 --dns-search service.consul'" >> /etc/default/docker
sudo service docker restart

