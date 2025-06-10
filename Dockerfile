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

# Install Node.js (v20)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy project files into the container
COPY . .

# Rename postcss config file to CommonJS to avoid ES module conflict
RUN if [ -f postcss.config.js ]; then mv postcss.config.js postcss.config.cjs; fi

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Install Node dependencies and build assets
RUN npm install && npm run build

# Fix permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www && \
    chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Expose Laravel's internal server port
EXPOSE 8000

# Start Laravel dev server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
