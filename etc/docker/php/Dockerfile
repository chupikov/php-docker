ARG PHP_VERSION=""
ARG ALPINE_VERSION_PHP=""

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine${ALPINE_VERSION_PHP}

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
    opcache \
    ;


# imagick
# Source code: https://github.com/Imagick/imagick/releases/tag/3.7.0
# RUN mkdir -p /usr/src/php/ext/imagick; \
#     curl -fsSL --ipv4 https://github.com/Imagick/imagick/archive/refs/tags/3.7.0.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
#     docker-php-ext-install imagick;

# igbinary
# Source code: https://github.com/igbinary/igbinary/releases/tag/3.2.7
# RUN mkdir -p /usr/src/php/ext/igbinary; \
#     curl -fsSL --ipv4 https://github.com/igbinary/igbinary/archive/refs/tags/3.2.7.tar.gz | tar xvz -C "/usr/src/php/ext/igbinary" --strip 1; \
#     docker-php-ext-install igbinary;

# yaml
# Source code: https://pecl.php.net/package/yaml
# RUN mkdir -p /usr/src/php/ext/yaml; \
#     curl -fsSL --ipv4 https://pecl.php.net/get/yaml-2.2.2.tgz | tar xvz -C "/usr/src/php/ext/yaml" --strip 1; \
#     docker-php-ext-install yaml;

# xdebug
# Source code: https://github.com/xdebug/xdebug/releases/tag/3.1.5
# RUN mkdir -p /usr/src/php/ext/xdebug; \
#     curl -fsSL --ipv4 https://github.com/xdebug/xdebug/archive/refs/tags/3.1.5.tar.gz | tar xvz -C "/usr/src/php/ext/xdebug" --strip 1; \
#     docker-php-ext-install xdebug;


RUN echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

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
