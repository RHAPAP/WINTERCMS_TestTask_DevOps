FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install zip pdo_mysql gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN git clone https://github.com/wintercms/winter.git /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && git config --global --add safe.directory /var/www/html

WORKDIR /var/www/html
RUN composer install --no-dev --ignore-platform-reqs

RUN a2enmod rewrite
ENV APACHE_DOCUMENT_ROOT=/var/www/html
EXPOSE 80