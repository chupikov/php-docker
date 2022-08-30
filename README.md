Universal Docker solution for PHP
=================================

* Environment configured according to this article: https://�.se/damp-docker-apache-mariadb-php-fpm/
* Using [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer)
  by Michele Locati for install PHP extensions. 
* Using docker exec command: https://linoxide.com/linux-how-to/ssh-docker-container/

CHANGELOG
---------

### Version 0.5

* Added support for [Xdebug 3](https://xdebug.org/docs/).


FEATURES
========

* [PHP/FCGID](https://hub.docker.com/_/php) - any modern version based on [Alpine linux](https://alpinelinux.org/).
  Tested with PHP versions 7.2, 7.3, 7.4, 8.0. 
    * opcache
    * xdebug [version 3](https://xdebug.org/docs/)
    * ffmpeg
    * pngout
    * PHP extensions (see below)
* Database: [MySQL](https://hub.docker.com/_/mysql) or [MariaDB](https://hub.docker.com/_/mariadb) - any modern version
* Web server: Apache 2.4

Tested with PHP frameworks and CMS
----------------------------------

* [Wordpress](https://wordpress.org/) 5.4.1.

DIRECTORY STRUCTURE
===================

All directories are required.

* bin
* src
    * web
* logs
* etc/docker
    * apache 
    * database
        * data-(mysql|mariadb)
    * php


KNOWN ISSUES
============

MariaDB does not start on Windows hosts
---------------------------------------

MariaDB container doesn't start on Windows hosts with shared databases volume.

Get error _"Installation of system tables failed"_.

Because of this default database server changed
from _[MariaDB 10.3](https://hub.docker.com/_/mariadb)_
to _[MySQL 5.7](https://hub.docker.com/_/mysql)_.

Impossible install from PECL/PEAR
---------------------------------

* See thread [pecl install redis on php8 fails](https://github.com/docker-library/php/issues/1118) on GitHhub as soon as this looks like similar problem.

Impossible install `igbinary` extension from PECL because of following error:

```
#0 0.373 install-php-extensions v.1.5.37
#0 0.484 ### WARNING Module already installed: mbstring ###
#0 0.502 ### WARNING Module already installed: pdo ###
#0 1.962 Updating channel "pecl.php.net"
#0 6.970 Channel "pecl.php.net" is not responding over http://, failed with message: Connection to `pecl.php.net:80' failed: php_network_getaddresses: getaddrinfo failed: Try again
#0 6.970 Trying channel "pecl.php.net" over https:// instead
#0 11.98 Cannot retrieve channel.xml for channel "pecl.php.net" (Connection to `ssl://pecl.php.net:443' failed: php_network_getaddresses: getaddrinfo failed: Try again)

   ...

#0 52.74 ### INSTALLING REMOTE MODULE igbinary ###
#0 57.80 No releases available for package "pecl.php.net/igbinary"
#0 57.80 install failed
```

After **enable IPV6** for both networks in `docker-compose.yml` situation a bit changed but result still the same:

```
#0 0.436 install-php-extensions v.1.5.37
#0 0.530 ### WARNING Module already installed: mbstring ###
#0 0.546 ### WARNING Module already installed: pdo ###
#0 1.989 Updating channel "pecl.php.net"
#0 2.371 Channel "pecl.php.net" is up to date

   ...

#0 33.69 ### INSTALLING REMOTE MODULE igbinary ###
#0 38.73 No releases available for package "pecl.php.net/igbinary"
#0 38.73 install failed
```

How IPV6 was enabled:

```yaml
networks:
  backend:
    enable_ipv6: true
  frontend:
    enable_ipv6: true
```

As I understand problem that CURL forced to use IPv6 over IPv4 and if IPv6 not supported by network (docker or host etc) then connection fails.

However strange that package `igbinary` can't be found even if connect to PECL successfull.

INSTALL
=======

After clone/copy source files:

1. Copy `.env.sample` to `.env`.
2. Configure `.env`.
3. Run `bin/init.sh` - script creates required files and  directories.
4. Configure PHP `etc/docker/php/php.ini`.
5. Configure Apache `etc/docker/apache/apache.conf`.


CONFIGURATION
=============

Database
--------

In purpose of disable database access from frontend network comment `frontend` network in the `docker-compose.yml` file.

### DOCKER_DATABASE_ENGINE

Possible values:

* [mariadb](https://hub.docker.com/_/mariadb)
    * DOCKER_DATABASE_ENGINE=mariadb
    * DOCKER_DATABASE_VERSION=10.3
* [mysql](https://hub.docker.com/_/mysql)
    * DOCKER_DATABASE_ENGINE=mysql
    * DOCKER_DATABASE_VERSION=5.7

XDEBUG
------

Supporting versions:
* [Xdebug version 3](https://xdebug.org/docs/) by default (see [Upgrading from Xdebug 2 to 3](https://xdebug.org/docs/upgrade_guide)).
* [Xdebug version 2](https://2.xdebug.org/docs/) (link available Dec 31st, 2021) can be configured.

Define correct value for `DOCKER_XDEBUG_REMOTE_HOST` in the `.env` file.

For Linux hosts value could be **172.17.0.1**.

For Windows hosts value should be **host.docker.internal**.

Web root directory
------------------

By default `./src` is a _PHP project root directory_
and `./src/web` is a _web root directory_.

In some cases (for example because of used PHP framework requirements)
_web root directory_ need to be changed.

### Rename web root directory

For example rename `./src/web` to `./src/public`.

1. Rename directory `./src/web` to `./src/public`.
2. Edit `etc/docker/apache/apache.conf` file, update `/var/www/html/web` to `/var/www/html/public`, for example:
```
	ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php:9000/var/www/html/public/$1

	DocumentRoot /var/www/html/public

	<Directory /var/www/html/public/>
		DirectoryIndex index.php
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
```

### Make root web directory equals to `src` directory

1. Directory `./src/web` isn't required anymore, you can delete it.
2. Edit `etc/docker/apache/apache.conf` file, update `/var/www/html/web` to `/var/www/html`, for example:
```
	ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php:9000/var/www/html/$1

	DocumentRoot /var/www/html

	<Directory /var/www/html/>
		DirectoryIndex index.php
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
```


USAGE
=====

Start
-----

```bash
docker-compose up --build -d
```

Stop
----

```bash
docker-compose down
```

Connect database container
-------------------------

If required some actions in the database with root privileges.

```sh
docker exec -it docker_test_mysql /bin/bash
mysql
```

Connect Apache container
-------------------------

If required execute some code in the console.

```sh
docker exec -it docker_test_apache /bin/bash
```

Connect PHP container
-------------------------

If required execute some code in the console.

```sh
docker exec -it docker_test_php /bin/bash
```

Connect database from host computer
-----------------------------------

```sh
mysql -h 127.0.0.1 -u <DOCKER_DB_USERNAME> -p <DOCKER_DB_NAME>
```

Use value of the <DOCKER_DB_PASSWORD> as password.

In purpose of connect database as **root user** please refer to chapter _"Connect database container"_ above.


Connect database from PHP
-------------------------

Use `database` (service name from "docker-compose.yml") as host name.

For example:

```php
$mysqli = new \mysqli('database', 'docker_test', 'docker_test', 'docker_test');
```


Information
===========

* [List of Alpine Linux packages](https://pkgs.alpinelinux.org/packages?branch=edge&arch=x86_64).
* [Extensions available for "docker-php-ext-install"](etc/available-extensions.md).
* [Extensions available for "mlocati/docker-php-extension-installer"](https://github.com/mlocati/docker-php-extension-installer).

PHP Extensions
==============

Installed PHP extensions
------------------------

See also [Extensions available for "docker-php-ext-install"](etc/available-extensions.md) and [Extensions available for "mlocati/docker-php-extension-installer"](https://github.com/mlocati/docker-php-extension-installer).

1. bz2
1. cgi-fcgi
1. core
1. ctype
1. curl
1. date
1. dom
1. exif
1. fileinfo
1. filter
1. ftp
1. gd
1. gettext
1. hash
1. iconv
1. igbinary
1. imagick
1. intl
1. json
1. libxml
1. mbstring
1. mysqli
1. mysqlnd
1. openssl
1. pcre
1. pdo
1. pdo_mysql
1. pdo_sqlite
1. phar
1. posix
1. readline
1. reflection
1. session
1. simplexml
1. soap
1. sodium
1. spl
1. sqlite3
1. standard
1. tokenizer
1. xdebug
1. xml
1. xmlreader
1. xmlwriter
1. yaml
1. zend opcache
1. zip
1. zlib


COPYRIGHT
=========

* (c) 2019 Nimpen J. Nordstr�m
* (c) 2019-2021 Yaroslav Chupikov
