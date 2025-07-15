FROM php:8.1-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libicu-dev libxml2-dev libzip-dev unzip git curl zip \
    && docker-php-ext-install intl pdo pdo_mysql zip xml

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar archivos de Mautic al contenedor
COPY . /var/www/html

WORKDIR /var/www/html

# Instalar dependencias con Composer
RUN if [ -f composer.json ]; then composer install --no-interaction --prefer-dist; fi

# Permisos y configuración de Apache
RUN chown -R www-data:www-data /var/www/html
RUN a2enmod rewrite

