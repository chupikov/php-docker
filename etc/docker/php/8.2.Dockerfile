FROM php:8.2-fpm-alpine3.21

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
