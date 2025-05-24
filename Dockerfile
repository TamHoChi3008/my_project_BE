FROM composer:2.0.12 as composer
FROM amazonlinux:2.0.20220121.0 AS app
ENV DOCUMENT_ROOT=/var/www/html/
ENV HTTPD_VERSION=2.4.52-1.amzn2
ENV PHP_VERSION=8.0.13-1.amzn2

RUN php_major_version=$PHP_VERSION \
    && php_major_version=${php_major_version:0:3} \
    && amazon-linux-extras enable php${php_major_version} \
    && yum install -y \
        gcc \
        make \
        freetype \
        freetype-devel \
        libpng \
        libpng-devel \
        libjpeg \
        libjpeg-devel \
        openssl-devel \
        openldap-devel \
        sqlite-devel \
        php-ldap \
        php-mysqli \
        php-pdo_mysql \
        php-pdo_sqlite \
        php-openssl \
        php-ftp \
        httpd \
        mod_ssl \
        php \
        php-common \
        php-pdo \
        php-bcmath \
        php-mbstring \
        php-xml \
        php-opcache \
        php-ldap \
        php-ftp --setopt=protected_multilib=false \
    && yum clean all \
    && rm -rf /var/cache/yum/* \
    && unset php_major_version

# COPY . /app

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY .dockerConfig/php.ini /etc/php.ini
COPY .dockerConfig/launchWeb.sh /launchWeb.sh

# Chạy lệnh key:generate trong thư mục của Laravel
# RUN php artisan key:generate
# CMD ["php-fpm", "-F", "-R"]

CMD ["bash", "/launchWeb.sh"]
