#!/bin/bash

composer install --ignore-platform-reqs

composer global require "laravel/installer=10.0"

if [ ! -f .env ]; then
    cp .env.example .env
fi
. .env


if [ -z "$APP_KEY" ]; then
    php artisan key:generate;
fi

if [ -n "$DB_HOST" -a -n "$DB_DATABASE" -a -n "$DB_USERNAME" -a -n "$DB_PASSWORD" ]; then
    php artisan migrate;
else
    echo "any db parameters are empty."
fi

httpd -DFOREGROUND
