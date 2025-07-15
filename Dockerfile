FROM php:8.2-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libicu-dev libxml2-dev libzip-dev unzip git curl zip libpng-dev libonig-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip xml opcache

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar código de Mautic
WORKDIR /var/www/html
COPY . .

# Instalar dependencias
RUN composer install --no-interaction --prefer-dist || true

# Permisos y configuración Apache
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Exponer puerto
EXPOSE 80

