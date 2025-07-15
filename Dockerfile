FROM php:8.1-apache

# Instala dependencias
RUN apt-get update && apt-get install -y \
    libicu-dev libxml2-dev libzip-dev unzip git curl \
    && docker-php-ext-install intl pdo pdo_mysql zip xml

# Copia los archivos del proyecto al servidor web
COPY . /var/www/html/

# Da permisos
RUN chown -R www-data:www-data /var/www/html

# Activa el módulo de reescritura
RUN a2enmod rewrite
