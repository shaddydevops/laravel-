FROM php:8.2-apache

WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip libzip-dev default-mysql-client && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure Apache
RUN a2enmod rewrite
COPY .docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy composer files first
COPY composer.json composer.lock* ./

# Install dependencies (skip scripts)
RUN set -eux; \
    mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache && \
    if [ -f composer.lock ]; then \
      composer install --no-scripts --no-autoloader --no-interaction; \
    else \
      composer update --no-scripts --no-autoloader --no-interaction --no-plugins; \
    fi

# Copy application files
COPY . .

# Create required Laravel directories
RUN mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache

# Copy entrypoint script explicitly
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Run post-install scripts
RUN composer dump-autoload --optimize && \
    php artisan package:discover --ansi

# Set permissions (use absolute paths)
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]