#!/bin/bash

set -e



# Validate credentials before proceeding
if [ -z "$DOCKER_HUB_USERNAME" ] || [ -z "$DOCKER_HUB_TOKEN" ]; then
  echo "❌ Docker Hub credentials not set!"
  exit 1
fi

echo "🐳 Installing Docker & Docker Compose..."
sudo yum install -y yum-utils git docker jq
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker ec2-user

echo "📦 Setting up app directories..."
mkdir -p ~/app && cd ~/app

echo "🔄 Cloning or pulling repository..."
[ ! -d ".git" ] && git clone https://github.com/shaddydevops/laravel-.git . || git pull origin main


echo "🔐 Fetching secrets from AWS Secrets Manager..."
BACKEND_SECRET=$(aws secretsmanager get-secret-value --secret-id BackendSecrets --query SecretString --output text --region us-east-1 || echo "")
FRONTEND_SECRET=$(aws secretsmanager get-secret-value --secret-id FrontendSecrets --query SecretString --output text --region us-east-1 || echo "")

if [ -z "$BACKEND_SECRET" ] || [ -z "$FRONTEND_SECRET" ]; then
  echo "❌ Failed to retrieve one or both secrets."
  exit 1
fi

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
