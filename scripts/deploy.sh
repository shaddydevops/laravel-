#!/bin/bash

set -e

# Validate environment variables first
[ -z "$DOCKER_HUB_USERNAME" ] && { echo "❌ DOCKER_HUB_USERNAME not set"; exit 1; }
[ -z "$DOCKER_HUB_TOKEN" ] && { echo "❌ DOCKER_HUB_TOKEN not set"; exit 1; }

echo "🐳 Installing Docker & Docker Compose..."
sudo yum install -y yum-utils git docker jq
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker ec2-user

echo "📦 Setting up app directories..."
mkdir -p ~/app && cd ~/app

echo "🔄 Cloning or pulling repository..."
[ ! -d ".git" ] && git clone https://github.com/shaddydevops/laravel-.git . || git pull origin main

echo "🔐 Writing secrets to .env files..."
echo "$BACKEND_SECRET" | jq -r 'to_entries | map("\(.key)=\(.value)") | .[]' > backend/.env
echo "$FRONTEND_SECRET" | jq -r 'to_entries | map("\(.key)=\(.value)") | .[]' > frontend/.env


sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo chown ec2-user:ec2-user /usr/local/bin/docker-compose

echo "🐙 Deploying with Docker Compose..."

echo "$DOCKER_HUB_TOKEN" | docker login --username "$DOCKER_HUB_USERNAME" --password-stdin
# docker login --username "$DOCKER_HUB_USERNAME" --password-stdin "$DOCKER_HUB_TOKEN"
docker-compose pull
docker-compose down || true
docker-compose up -d db
sleep 20

if [ "$(docker inspect mysql_db --format='{{.State.Health.Status}}')" = "healthy" ]; then
  docker-compose up -d app frontend phpmyadmin
  echo "✅ Deployment Successful!"
else
  echo "❌ DB Container Unhealthy"
  docker-compose logs db
  exit 1
fi
