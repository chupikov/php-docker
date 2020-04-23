ARG APACHE_VERSION=""
ARG USER_ID=""
ARG GROUP_ID=""

FROM httpd:${APACHE_VERSION:+${APACHE_VERSION}-}alpine

RUN apk update; \
    apk upgrade;

RUN apk add \
    shadow \
	bash \
	mc \
	git \
	curl \
	apache2 \
	openssl \
	ca-certificates \
	tzdata \
	openntpd \
	php7-apache2 \
	php7 \
	php7-phar \
	php7-json \
	php7-iconv \
	php7-openssl \
	php7-intl \
	php7-ftp \
	php7-xdebug \
	php7-mcrypt \
	php7-mbstring \
	php7-soap \
	php7-gmp \
	php7-pdo_odbc \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-sqlite3 \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xmlreader \
	php7-xmlwriter \
	php7-tokenizer \
	php7-xmlrpc \
	php7-bz2 \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-exif;

RUN sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /usr/local/apache2/conf/httpd.conf;

# RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

USER "${USER_ID}:${GROUP_ID}"

COPY .bashrc /root/.bashrc

# Copy apache vhost file to proxy php requests to php-fpm container
COPY apache.conf /usr/local/apache2/conf/000-apache.conf
RUN echo "Include /usr/local/apache2/conf/000-apache.conf" \
    >> /usr/local/apache2/conf/httpd.conf

