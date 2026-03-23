FROM php:8.2-cli [cite: 1]

# 1. Install system dependencies
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
COPY . . [cite: 3]

# 5. Install PHP dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# 6. Set permissions
# We set ownership to the root user/group for the app, but ensure 
# storage and cache are writable by the server.
RUN chmod -R 777 storage bootstrap/cache [cite: 5]

# 7. Expose the port
# Render typically uses 10000, but it will inject the $PORT variable.
EXPOSE 10000

# 8. Enhanced Start-up Command
# We use 'sh -c' to ensure the shell properly handles the '&&' and environment variables.
# This attempts migrations first, then starts the server regardless of migration success 
# to help you see the actual application errors in the logs.
CMD sh -c "php artisan migrate --force; php -S 0.0.0.0:\$PORT -t public"