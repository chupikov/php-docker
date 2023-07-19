ARG PHP_VERSION=""
ARG ALPINE_VERSION_PHP=""

FROM php:${PHP_VERSION:+${PHP_VERSION}-}fpm-alpine${ALPINE_VERSION_PHP}

ARG HOST_USER=default
ARG HOST_UID=1000
ARG HOST_GID=1000

ENV USER ${HOST_USER}

RUN mkdir -p /root/.ssh && ln -s /run/secrets/ssh_key /root/.ssh/id_rsa
RUN mkdir -p /home/${HOST_USER}/.ssh \
    && ln -s /run/secrets/ssh_key /home/${HOST_USER}/.ssh/id_rsa \
    && chmod 0755 /home/${HOST_USER}/.ssh \
    ;

RUN apk update; \
    apk upgrade;

RUN apk add --update --no-cache \
    bash \
    sudo \
    openssh-client \
    unzip \
    mc \
    curl \
    wget \
    nano \
    git \
    ;

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

RUN echo "${HOST_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${HOST_USER} \
    && chmod 0440 /etc/sudoers.d/${HOST_USER} \
    ;

RUN chown -R ${HOST_UID}:${HOST_GID} /home/${HOST_USER}

WORKDIR /var/www/html

USER ${HOST_UID}:${HOST_GID}
