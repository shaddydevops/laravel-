#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Wait for MySQL to be ready (CRUCIAL ADDITION)
until mysqladmin ping -h"$DB_HOST" -u"$DB_USERNAME" -p"$DB_PASSWORD" --silent; do
  echo "Waiting for database..."
  sleep 3
done

# Check/create .env file
if [ ! -f .env ]; then
  cp .env.example .env
fi

# Generate APP_KEY if missing
if ! grep -q "^APP_KEY=" .env || [ -z "$(grep '^APP_KEY=' .env | cut -d '=' -f2)" ]; then
  echo "Generating APP_KEY..."
  php artisan key:generate --force
else
  echo "APP_KEY already exists."
fi

# Run database migrations and seeding (IMPORTANT ADDITION)
echo "Running database migrations..."
php artisan migrate --force
echo "Seeding database..."
php artisan db:seed --force

# Clear and cache configurations
php artisan config:clear
php artisan config:cache

# Start Apache
exec apache2-foreground