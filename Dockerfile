FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel setup
RUN php artisan key:generate \
    && php artisan config:clear \
    && php artisan cache:clear \
    && php artisan route:clear \
    && chmod -R 777 storage bootstrap/cache

# Expose port (Render uses 10000)
EXPOSE 10000

# Start server (production-safe alternative)
CMD php -S 0.0.0.0:10000 -t public