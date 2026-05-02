# Usamos PHP con Apache
FROM php:8.2-apache

# Instalamos herramientas necesarias y el driver de MongoDB
RUN apt-get update && apt-get install -y \
    libssl-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Habilitamos el sistema de rutas de Apache
RUN a2enmod rewrite

# Copiamos tu código al servidor
COPY . /var/www/html/

# Instalamos Composer y las librerías (vendor)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-interaction --optimize-autoloader

# Damos permisos para que el servidor pueda leer los archivos
RUN chown -R www-data:www-data /var/www/html