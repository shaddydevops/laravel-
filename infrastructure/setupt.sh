#!/bin/bash
# infrastructure/setup.sh

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Configure permissions
sudo usermod -aG docker $USER
newgrp docker