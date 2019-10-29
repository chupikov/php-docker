Universal Docker solution for PHP
=================================

* Environment configured according to this article: https://á.se/damp-docker-apache-mariadb-php-fpm/
* Using docker exec command: https://linoxide.com/linux-how-to/ssh-docker-container/

INSTALL
=======

After clone/copy source files:

1. Configure `.env`.
2. Run `bin/init.sh` - script creates required directories.

DIRECTORY STRUCTURE
===================

All directories are required.

* bin
* html
* logs
* mirasoltek/docker
    * apache 
    * mysql
        * data
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

Connect MariaDB container
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

COPYRIGHT
=========

* (C) 2019 Nimpen J. Nordström
* (C) 2019 Yaroslav Chupikov

