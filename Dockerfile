FROM php:8.2-fpm

# Install system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    gnupg \
    ca-certificates \
    mariadb-client \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Node.js (for Vite build)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy only composer files for caching
COPY composer.json composer.lock ./

# Copy remaining app files (including artisan, config, etc.)
COPY . .

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Install JS dependencies and build assets
RUN npm install && npm run build

# Set file permissions
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Expose Laravel port
EXPOSE 8000

# Start Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
