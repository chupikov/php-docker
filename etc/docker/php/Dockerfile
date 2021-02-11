ARG PHP_VERSION=""

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN apk update; \
    apk upgrade;

RUN apk add --update --no-cache \
    bash \
    unzip \
    mc \
    curl \
    wget;

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && sync
RUN install-php-extensions \
    gd \
    imagick \
    mbstring \
    intl \
    gettext \
    igbinary \
    bz2 \
    zip \
    soap \
    exif \
    pdo \
    pdo_mysql \
    mysqli \
    yaml \
    xdebug \
    opcache;

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY .bashrc /root/.bashrc
COPY install.sh /root/install.sh

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "--rcfile", "/root/.bashrc", "-c"]

RUN /root/install.sh

WORKDIR /var/www/html


# RUN addgroup -g 1000 user
# RUN adduser -u 1000 -G user -h /home/user -s /bin/bash -D user
# COPY .bashrc "/home/user/.bashrc"
# USER user:www-data
