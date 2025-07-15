FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libicu-dev libxml2-dev libzip-dev unzip git curl zip \
    && docker-php-ext-install intl pdo pdo_mysql zip xml

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . /var/www/html

RUN composer install --no-interaction --prefer-dist \
    && chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

