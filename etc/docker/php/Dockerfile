ARG PHP_VERSION=""
ARG CONTAINER_USER_ID=""
ARG GROUP_ID=""

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN apk update; \
    apk upgrade;

RUN apk add --update --no-cache \
    libintl \
    icu \
    icu-dev \
    gettext \
    gettext-dev \
    libxml2-dev \
	libzip-dev \
    libbz2 \
    bzip2-dev \
    freetype \
	libmcrypt-dev \
	libpng \
	libjpeg-turbo \
	libjpeg-turbo-dev \
	freetype-dev \
	libpng-dev \
    shadow \
    libwebp \
    libwebp-dev \
    dpkg-dev \
    dpkg \
    gcc \
    g++ \
    autoconf \
    file \
	cmake \
	make \
    bash \
    mc \
    curl \
    unzip \
    ffmpeg \
    wget;

RUN docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-webp-dir=/usr/include/

RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) \
    gd

RUN pecl install \
	xdebug \
	igbinary

RUN docker-php-ext-install \
    mbstring \
    intl \
    gettext \
    bz2 \
    zip \
    soap \
    exif \
    pdo \
    pdo_mysql \
    mysqli \
    opcache;

RUN docker-php-ext-enable \
	xdebug \
	igbinary \
	exif

RUN set -ex \
    && apk add --no-cache --virtual .phpize-deps ${PHPIZE_DEPS} imagemagick imagemagick-dev libtool \
    && export CFLAGS="${PHP_CFLAGS}" CPPFLAGS="${PHP_CPPFLAGS}" LDFLAGS="${PHP_LDFLAGS}" \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick \
    && apk add --no-cache --virtual .imagick-runtime-deps imagemagick \
    && apk del .phpize-deps

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /var/www/html

# RUN usermod -u ${CONTAINER_USER_ID} www-data && groupmod -g ${CONTAINER_GROUP_ID} www-data

USER "${CONTAINER_USER_ID}:${CONTAINER_GROUP_ID}"

COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY .bashrc /root/.bashrc
COPY install.sh /root/install.sh

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "--rcfile", "/root/.bashrc", "-c"]

RUN /root/install.sh
