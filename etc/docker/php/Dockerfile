ARG PHP_VERSION=""
ARG USER_ID=""
ARG GROUP_ID=""

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN apk update; \
    apk upgrade;

RUN apk add \
    libxml2-dev \
	libzip-dev \
    shadow \
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
    wget;

RUN pecl install \
	xdebug

RUN docker-php-ext-install \
    mbstring \
    pdo \
    pdo_mysql \
    mysqli \
    opcache;

# UNABLE INSTALL XDEBUG!!!
#RUN docker-php-ext-install \
#    mbstring \
#    pdo \
#    pdo_mysql \
#    mysqli \
#    opcache \

RUN docker-php-ext-enable \
	xdebug

# RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

USER "${USER_ID}:${GROUP_ID}"

COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY .bashrc /root/.bashrc

