Universal Docker solution
=========================

* Environment configured according to this article: https://á.se/damp-docker-apache-mariadb-php-fpm/
* Using docker exec command: https://linoxide.com/linux-how-to/ssh-docker-container/

Install
=======

After clone/copy source files:

1. Configure `.env`.
2. Run `bin/init.sh` - script creates required directories.

Directory structure
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

Copyright
=========

* (C) 2019 Nimpen J. Nordström
* (C) 2019 Yaroslav Chupikov

