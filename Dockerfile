FROM php:8.2-cli

# Install system dependencies (IMPORTANT for MySQL)
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip default-mysql-client \
    && docker-php-ext-install zip pdo pdo_mysql

# Enable extensions explicitly
RUN docker-php-ext-enable pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Fix permissions
RUN chmod -R 777 storage bootstrap/cache

EXPOSE 10000

# Start server
CMD php -S 0.0.0.0:${PORT:-10000} -t public