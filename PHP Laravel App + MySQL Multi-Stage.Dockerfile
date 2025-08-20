#PHP Laravel App + MySQL Multi-Stage

#the  Dockerfile
FROM composer:latest AS composer
FROM php:8.2-fpm
WORKDIR /var/www/html
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY . .
RUN composer install --no-dev --optimize-autoloader
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html
EXPOSE 9000
CMD ["php-fpm"]