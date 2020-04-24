ARG PHP_VERSION=""
ARG USER_ID=""
ARG GROUP_ID=""

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine

RUN apk update; \
    apk upgrade;

RUN apk add \
    shadow \
    dpkg-dev \
    dpkg \
    gcc \
    g++ \
    autoconf \
    file \
    bash \
    mc \
    curl \
    wget;

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
#    && pecl install xdebug \
#    && docker-php-ext-enable xdebug;

# RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

USER "${USER_ID}:${GROUP_ID}"

COPY .bashrc /root/.bashrc

