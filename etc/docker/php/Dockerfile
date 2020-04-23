ARG PHP_VERSION=""
FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN apk update; \
    apk upgrade;

RUN apk add \
    bash \
    mc \
    curl;

RUN docker-php-ext-install mysqli pdo pdo_mysql
#RUN docker-php-ext-install mysqli
#RUN docker-php-ext-install pdo pdo_mysql

#RUN apk add \
#   php7-pdo \
#   php7-mysqli \
#   php7-sqlite3 \
#   php7-pdo_mysql \
#   php7-pdo_sqlite \
#   php7-exif;

COPY .bashrc /root/.bashrc

