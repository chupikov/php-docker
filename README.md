Universal Docker solution for PHP
=================================

* Environment configured according to this article: https://.se/damp-docker-apache-mariadb-php-fpm/
* Using [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) by Michele Locati to install PHP extensions. 
* Using the docker exec command: https://linoxide.com/linux-how-to/ssh-docker-container/

SUPPORTED PHP VERSIONS
----------------------

- **8.5** (Alpine 3.23)
- **8.4** (Alpine 3.23)
- **8.3** (Alpine 3.23)
- **8.2** (Alpine 3.23)
- **8.1** (Alpine 3.22)
- **8.0** (Alpine 3.16)
- **7.4** (Alpine 3.16)
- **7.3** (Alpine 3.12; Dockerfile not included)
- **7.2** (Alpine 3.12; Dockerfile not included)

PHP versions prior to `7.2` are not supported by Alpine version `3.12`.


CHANGELOG
---------

### Version 0.10

* Added support for PHP 8.5.
* Alpine version in the Apache container set to 3.23.
* Updated Alpine version for the following PHP versions:
    * 7.4 (Alpine 3.16)
    * 8.0 (Alpine 3.16)
    * 8.1 (Alpine 3.22)
    * 8.2 (Alpine 3.23)
    * 8.3 (Alpine 3.23)
    * 8.4 (Alpine 3.23)

### Version 0.9

* Uses only Alpine Linux for all supported PHP versions.
* Improved PHP version configuration. Each supported PHP version now has its own Dockerfile; it is now sufficient to define the PHP version only.
* Added complete Dockerfiles for PHP versions:
    * 7.4 (Alpine 3.12)
    * 8.0 (Alpine 3.16)
    * 8.1 (Alpine 3.21)
    * 8.2 (Alpine 3.21)
    * 8.3 (Alpine 3.21)
    * 8.4 (Alpine 3.21)
* Environment variable `ALPINE_VERSION_PHP` is unused in the new Dockerfiles.
* Environment variables removed from the Apache Dockerfile:
    * `ALPINE_VERSION_APACHE`
    * `DOCKER_APACHE_VERSION`
* Apache Docker container:
    * Uses Alpine version 3.21
    * Uses Apache version 2.4
    * Uses PHP version 8.3
    * Excluded PHP extensions `php83-pecl-mcrypt` and `php83-pecl-xmlrpc`
* MariaDB is now working in Windows environments.

### Version 0.7

* Added support for *Debian 12 Bookworm* and PHP versions `8.1`, `8.2`.

### Version 0.6

* Fixed an issue with non-working PECL (see [ISSUES.md](ISSUES.md)) by downgrading the Alpine version to `3.12`.
* Introduced new environment variables:
    * `ALPINE_VERSION_PHP`
    * `ALPINE_VERSION_APACHE`

### Version 0.5

* Added support for [Xdebug 3](https://xdebug.org/docs/).


FEATURES
========

* [PHP/FCGID](https://hub.docker.com/_/php/tags?page=1&name=fpm-) - any modern version supported by [Alpine Linux](https://alpinelinux.org/) or [Debian Linux](https://www.debian.org/).
  Tested with PHP versions `7.2`, `7.3`, `7.4`, `8.0`, `8.1`, `8.2`. 
    * opcache
    * xdebug [version 3](https://xdebug.org/docs/)
    * ffmpeg
    * pngout
    * PHP extensions (see below)
* Database: [MySQL](https://hub.docker.com/_/mysql) or [MariaDB](https://hub.docker.com/_/mariadb) - any modern version
* Web server: Apache 2.4


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

See [ISSUES.md](ISSUES.md):


INSTALL
=======

After cloning/copying source files:

1. Copy `.env.sample` to `.env`.
2. Configure `.env`:
    * Define the PHP version.
    * Define the database engine and version.
    * Optionally define other environment variables.
3. Run `bin/init.sh` - the script creates required files and directories.
4. Configure PHP in `etc/docker/php/php.ini`.
5. Configure Apache in `etc/docker/apache/apache.conf`.


CONFIGURATION
=============

Database
--------

To disable database access from the frontend network, comment out the `frontend` network in the `docker-compose.yml` file.

### DOCKER_DATABASE_ENGINE

Possible values:

* [mariadb](https://hub.docker.com/_/mariadb)
    * DOCKER_DATABASE_ENGINE=mariadb
    * DOCKER_DATABASE_VERSION=11.7
* [mysql](https://hub.docker.com/_/mysql)
    * DOCKER_DATABASE_ENGINE=mysql
    * DOCKER_DATABASE_VERSION=5.7

XDEBUG
------

Supported versions:
* [Xdebug version 3](https://xdebug.org/docs/) by default (see [Upgrading from Xdebug 2 to 3](https://xdebug.org/docs/upgrade_guide)).

Define the correct value for `DOCKER_XDEBUG_REMOTE_HOST` in the `.env` file.

For Linux hosts, the value could be **172.17.0.1**.

For Windows hosts, the value should be **host.docker.internal**.

Web root directory
------------------

By default, `./src` is the _PHP project root directory_ and `./src/web` is the _web root directory_.

In some cases (for example, due to PHP framework requirements), the _web root directory_ needs to be changed.

### Rename web root directory

For example, to rename `./src/web` to `./src/public`:

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

### Make the root web directory equal to the `src` directory

1. Directory `./src/web` is no longer required; you can delete it.
2. Edit the `etc/docker/apache/apache.conf` file and update `/var/www/html/web` to `/var/www/html`. For example:
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

System user within the Docker container
---------------------------------------

Docker is configured in a way that allows you to use the following within the `php` container:

* Your system username, UID, and GID (as defined on the host machine) as the file owner.
* Your GIT configuration.
* Your private SSH key.

To configure this feature, define the following environment variables in the `.env` file:

* `HOST_USER` - the name of your system user.
* `HOST_UID` - the UID of your system user.
* `HOST_GID` - the GID of your system user.

```.env
HOST_USER=user
HOST_UID=1000
HOST_GID=1000
```
**WARNING!** If defined incorrectly, containers might not start.

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

Connect to the database container
---------------------------------

If actions are required in the database with root privileges:

```sh
docker exec -it docker_test_mysql /bin/bash
mysql
```

Connect to the Apache container
-------------------------------

If you need to execute code in the console:

```sh
docker exec -it docker_test_apache /bin/bash
```

Connect to the PHP container
----------------------------

If you need to execute code in the console:

```sh
docker exec -it docker_test_php /bin/bash
```

Connect to the database from the host computer
----------------------------------------------

```sh
mysql -h 127.0.0.1 -u <DOCKER_DB_USERNAME> -p <DOCKER_DB_NAME>
```

Use value of <DOCKER_DB_PASSWORD> as the password.

To connect to the database as the **root user**, please refer to the "Connect to the database container" section above.


Connect to the database from PHP
--------------------------------

Use `database` (service name from "docker-compose.yml") as the host name.

Example:

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

See also [Extensions available for the "docker-php-ext-install"](etc/available-extensions.md) and [Extensions supported by the "mlocati/docker-php-extension-installer"](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions).

* bz2
* cgi-fcgi
* core
* ctype
* curl
* date
* dom
* exif
* fileinfo
* filter
* ftp
* gd
* gettext
* hash
* iconv
* igbinary
* imagick
* intl
* json
* libxml
* mbstring
* mysqli
* mysqlnd
* openssl
* pcre
* pdo
* pdo_mysql
* pdo_sqlite
* phar
* posix
* readline
* reflection
* session
* simplexml
* soap
* sodium
* spl
* sqlite3
* standard
* tokenizer
* xdebug
* xml
* xmlreader
* xmlwriter
* yaml
* zend opcache
* zip
* zlib


Installed Apache modules
------------------------

* access_compat_module
* alias_module
* auth_basic_module
* authn_core_module
* authn_file_module
* authz_core_module
* authz_groupfile_module
* authz_host_module
* authz_user_module
* autoindex_module
* dir_module
* env_module
* filter_module
* headers_module
* log_config_module
* mime_module
* mpm_event_module
* reqtimeout_module
* rewrite_module
* setenvif_module
* status_module
* unixd_module
* version_module


COPYRIGHT
=========

* (c) 2019 Nimpen J. Nordstr�m
* (c) 2019-2026 Yaroslav Chupikov
