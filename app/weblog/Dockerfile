# =============================================================================
# Laravel Production Dockerfile - Multi-stage build for fast, optimized builds
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: Composer Dependencies
# -----------------------------------------------------------------------------
FROM composer:2.6 AS composer-deps

WORKDIR /app

# Copy only composer files first for better layer caching
COPY composer.json composer.lock ./

# Install dependencies without dev packages
RUN composer install \
    --no-dev \
    --no-scripts \
    --no-autoloader \
    --prefer-dist \
    --no-interaction

# Copy the rest of the application
COPY . .

# Generate optimized autoloader
RUN composer dump-autoload --optimize --no-dev

# -----------------------------------------------------------------------------
# Stage 2: Node.js Assets Build
# -----------------------------------------------------------------------------
FROM node:18-alpine AS node-assets

WORKDIR /app

# Copy package files for caching
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm install

# Copy source files needed for build
COPY webpack.mix.js ./
COPY resources ./resources
COPY public ./public

# Build production assets
RUN npm run production

# -----------------------------------------------------------------------------
# Stage 3: Production Image
# -----------------------------------------------------------------------------
FROM php:8.2-fpm-alpine AS production

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    mysql-client \
    curl \
    netcat-openbsd \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        opcache

# Configure PHP for production
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Add custom PHP configuration for performance
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini

# Configure Nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx-site.conf /etc/nginx/http.d/default.conf

# Configure Supervisor
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy startup script
COPY docker/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Set working directory
WORKDIR /var/www/html

# Copy application from composer stage
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=composer-deps /app .

# Copy built assets from node stage
COPY --from=node-assets /app/public/css ./public/css
COPY --from=node-assets /app/public/js ./public/js
COPY --from=node-assets /app/public/mix-manifest.json ./public/mix-manifest.json

# Set permissions and create required directories
RUN mkdir -p /var/log/supervisor /var/log/php /var/log/nginx \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Create healthcheck script
RUN echo '#!/bin/sh' > /usr/local/bin/healthcheck.sh \
    && echo 'curl -f http://localhost/health || exit 1' >> /usr/local/bin/healthcheck.sh \
    && chmod +x /usr/local/bin/healthcheck.sh

# Expose port
EXPOSE 80

# Healthcheck for container orchestration
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD /usr/local/bin/healthcheck.sh

# Start application using startup script
CMD ["/usr/local/bin/start.sh"]
