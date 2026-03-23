FROM php:8.2-cli

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    zip \
    default-mysql-client \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install zip pdo pdo_mysql mbstring xml

# 2. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 3. Set working directory
WORKDIR /app

# 4. Copy project files
COPY . .

# 5. Install dependencies
RUN composer install --no-interaction --no-dev --optimize-autoloader

# 6. Fix permissions
RUN chmod -R 775 storage bootstrap/cache

# 7. Expose port (Render uses dynamic PORT)
EXPOSE 10000

# 8. Start server properly
CMD php artisan config:cache && \
    php artisan route:cache && \
    php artisan migrate --force && \
    php -S 0.0.0.0:${PORT:-10000} -t public