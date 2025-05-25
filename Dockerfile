FROM php:8.2-apache

# Set timezone
ENV TZ=Asia/Ho_Chi_Minh

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    zip unzip git curl libpq-dev libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql zip bcmath mbstring xml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY .dockerbuild/web/php.ini /etc/php.ini
COPY .dockerbuild/web/launchWeb.sh /launchWeb.sh

# Enable mod_rewrite
RUN a2enmod rewrite

# Expose HTTP & HTTPS
EXPOSE 80 443

WORKDIR /var/www/html

# set documentsRoot
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

CMD ["bash", "/launchWeb.sh"]
