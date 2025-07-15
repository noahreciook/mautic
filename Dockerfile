FROM php:8.1-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libicu-dev libxml2-dev libzip-dev unzip git curl zip \
    && docker-php-ext-install intl pdo pdo_mysql zip xml

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar archivos del proyecto
COPY . /var/www/html

# Entrar al directorio y correr composer
WORKDIR /var/www/html
RUN composer install --no-interaction --no-plugins --no-scripts

# Permisos
RUN chown -R www-data:www-data /var/www/html

# Habilitar mod_rewrite
RUN a2enmod rewrite

