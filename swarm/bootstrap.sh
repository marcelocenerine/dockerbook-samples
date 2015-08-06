#!/usr/bin/env bash

# Install Docker
sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker vagrant

# Enable remote TCP access to the Docker daemon (IMPORTANT: the default setup provides un-encrypted and un-authenticated direct access to the Docker daemon)
echo "DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock\"" | sudo tee --append /etc/default/docker > /dev/null
sudo service docker restart

# Pull down the swarm image
docker pull swarm

# Run swarm
IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')
docker run -d swarm join --addr=$IP:2375 token://328e1b0121e90dd175f59aa7d279e77c
