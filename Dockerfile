FROM php:8.2-cli

# 1. Install system dependencies
# Added libpq-dev in case you ever switch to Postgres, 
# but kept the mysql-client for database interactions.
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    zip \
    default-mysql-client \
    && docker-php-ext-install zip pdo pdo_mysql

# 2. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 3. Set working directory
WORKDIR /app

# 4. Copy project files
COPY . .

# 5. Install PHP dependencies
# Optimized for production
RUN composer install --no-interaction --no-dev --optimize-autoloader

# 6. Set permissions
# Note: 777 is a bit loose; in a strict environment, you'd use 775 
# and change ownership to www-data, but for quick deployment, this works.
RUN chmod -R 777 storage bootstrap/cache

# 7. Expose the port
EXPOSE 10000

# 8. Start-up Command
# We use a shell form here so that $PORT is correctly evaluated by the environment.
CMD php artisan migrate --force && php -S 0.0.0.0:$PORT -t public