FROM httpd:2.4-alpine3.21

RUN mkdir -p /root/.ssh && ln -s /run/secrets/ssh_key /root/.ssh/id_rsa

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
	php83-apache2 \
	php83 \
	php83-phar \
	php83-json \
	php83-iconv \
	php83-openssl \
	php83-intl \
	php83-ftp \
	php83-xdebug \
	php83-mbstring \
	php83-soap \
	php83-gmp \
	php83-pdo_odbc \
	php83-dom \
	php83-pdo \
	php83-zip \
	php83-mysqli \
	php83-sqlite3 \
	php83-bcmath \
	php83-gd \
	php83-odbc \
	php83-pdo_mysql \
	php83-pdo_sqlite \
	php83-gettext \
	php83-xmlreader \
	php83-xmlwriter \
	php83-tokenizer \
	php83-bz2 \
	php83-pdo_dblib \
	php83-curl \
	php83-ctype \
	php83-session \
	php83-exif \
	# php83-pecl-mcrypt \
	# php83-pecl-xmlrpc \
	;

RUN sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /usr/local/apache2/conf/httpd.conf;

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "--rcfile", "/root/.bashrc", "-c"]

COPY .bashrc /root/.bashrc

# Copy apache vhost file to proxy php requests to php83-fpm container
# COPY apache.conf /usr/local/apache2/conf/000-apache.conf
# RUN echo "Include /usr/local/apache2/conf/000-apache.conf" \
#     >> /usr/local/apache2/conf/httpd.conf

RUN echo "IncludeOptional /usr/local/apache2/conf/sites-enabled/*.conf" \
    >> /usr/local/apache2/conf/httpd.conf
