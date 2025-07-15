FROM php:8.2-apache

# Instalar dependencias del sistema y extensiones de PHP
RUN apt-get update && apt-get install -y \
    curl gnupg2 unzip git zip libicu-dev libxml2-dev libzip-dev \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev \
    libxslt1-dev libmcrypt-dev libmagickwand-dev \
    libpq-dev libssl-dev libc-client-dev libkrb5-dev \
    libcurl4-openssl-dev zlib1g-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install intl pdo pdo_mysql zip xml gd opcache bcmath imap xsl

# Instalar Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar código fuente
COPY . .

# Instalar dependencias de PHP y JS
RUN composer install --no-interaction --prefer-dist --no-dev

# Verificar que autoload exista
RUN test -f /var/www/html/vendor/autoload.php || (echo "❌ composer install falló" && exit 1)

# Permisos y Apache
RUN chown -R www-data:www-data /var/www/html && a2enmod rewrite

EXPOSE 80
