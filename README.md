Universal Docker solution for PHP
=================================

* Environment configured according to this article: https://�.se/damp-docker-apache-mariadb-php-fpm/
* Using docker exec command: https://linoxide.com/linux-how-to/ssh-docker-container/

FEATURES
========

* [PHP/FCGID](https://hub.docker.com/_/php) - any modern version
    * opcache
    * xdebug
    * PHP extensions (see below)
* Database: [MySQL](https://hub.docker.com/_/mysql) or [MariaDB](https://hub.docker.com/_/mariadb) - any modern version
* Web server: Apache 2.4


KNOWN ISSUES
============

MariaDB does not start on Windows hosts
---------------------------------------

MariaDB container doesn't start on Windows hosts with shared databases volume.

Get error _"Installation of system tables failed"_.

Because of this default database server changed
from _[MariaDB 10.3](https://hub.docker.com/_/mariadb)_
to _[MySQL 5.7](https://hub.docker.com/_/mysql)_.

Missing Alpine Linux packages
-----------------------------

Sometimes when install PHP extension some Alpine Linux dependencies missing.

Please check [List of Alpine Linux packages](https://pkgs.alpinelinux.org/packages?branch=edge&arch=x86_64).


INSTALL
=======

After clone/copy source files:

1. Run `bin/init.sh` - script creates requiredfiles and  directories.
2. Configure `.env`.

DIRECTORY STRUCTURE
===================

All directories are required.

* bin
* web
* logs
* etc/docker
    * apache 
    * database
        * data-(mysql|mariadb)
    * php

NOTES
=====

Common notes
------------

* Apache container always has installed PHP version 7.3.
* Impossible connect MariaDB server externally with root privileges - connect to MariaDB container is required.

Windows OS notes
----------------

* Shell scripts could be executed in MinGW (e.g. GIT Bash) console.
* Impossible connect container using `docker exec` command because TTY not supported. But this command perfectly working in PowerShell console.


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

Define correct value for `DOCKER_XDEBUG_REMOTE_HOST` in the `.env` file.

For Linux hosts value could be **172.17.0.1**.

For Windows hosts value should be **host.docker.internal**.

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


PHP Extensions
==============

Installed PHP extensions
------------------------

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
1. zend opcache
1. zip
1. zlib

Extensions available for "docker-php-ext-install"
----------------------------------------------------

* bcmath
* bz2
* calendar
* ctype
* curl
* dba
* dom
* enchant
* exif
* fileinfo
* filter
* ftp
* gd
* gettext
* gmp
* hash
* iconv
* imap
* interbase
* intl
* json
* ldap
* mbstring
* mysqli
* oci8
* odbc
* opcache
* pcntl
* pdo
* pdo_dblib
* pdo_firebird
* pdo_mysql
* pdo_oci
* pdo_odbc
* pdo_pgsql
* pdo_sqlite
* pgsql
* phar
* posix
* pspell
* readline
* recode
* reflection
* session
* shmop
* simplexml
* snmp
* soap
* sockets
* sodium
* spl
* standard
* sysvmsg
* sysvsem
* sysvshm
* tidy
* tokenizer
* wddx
* xml
* xmlreader
* xmlrpc
* xmlwriter
* xsl
* zend_test
* zip


COPYRIGHT
=========

* (C) 2019 Nimpen J. Nordstr�m
* (C) 2019 Yaroslav Chupikov

