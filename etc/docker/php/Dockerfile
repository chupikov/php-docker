ARG PHP_VERSION=""
ARG USER_ID=""
ARG GROUP_ID=""

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN apk update; \
    apk upgrade;

RUN apk add --update --no-cache \
    bash \
    mc \
    curl \
    unzip \
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

WORKDIR /var/www/html

# RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

USER "${USER_ID}:${GROUP_ID}"

COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY .bashrc /root/.bashrc
COPY install.sh /root/install.sh

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "--rcfile", "/root/.bashrc", "-c"]

RUN /root/install.sh
