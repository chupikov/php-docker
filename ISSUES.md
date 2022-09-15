KNOWN ISSUES
============

MariaDB does not start on Windows hosts
---------------------------------------

MariaDB container doesn't start on Windows hosts with shared databases volume.

Get error _"Installation of system tables failed"_.

Because of this default database server changed
from _[MariaDB 10.3](https://hub.docker.com/_/mariadb)_
to _[MySQL 5.7](https://hub.docker.com/_/mysql)_.

Impossible install PHP extensions from PECL/PEAR
------------------------------------------------

**Problem**: Impossible install `igbinary` extension from PECL. Beacuse of this container build failed.

See also:

* See thread [pecl install redis on php8 fails](https://github.com/docker-library/php/issues/1118) on GitHhub as soon as this looks like similar problem.
* [Provide static IP to docker containers via docker-compose](https://stackoverflow.com/questions/39493490/provide-static-ip-to-docker-containers-via-docker-compose)
* [Container networking](https://docs.docker.com/config/containers/container-networking/)
* [Disable ip v6 in docker container](https://stackoverflow.com/questions/30750271/disable-ip-v6-in-docker-container)

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

### Update 2022-09-07

`commit: e3520c9877177762035d4a276bed9031101e2cab`

Workable version of the setup but without following extensions (see `php/Dockerfile`):
- imagick
- igbinary
- yaml
- xdebug

### Update 2022-09-07

`commit: ee295cac6471dc6c9260ce3c30efcb9bce6ab801`

Created workable configuration (see `.env`, `.env.sample`):
+ ALPINE_VERSION_PHP=3.12
+ ALPINE_VERSION_APACHE=3.14.

All modules downloaded and installed with enabled IPv6.

Network IPv6 error
------------------

At some time was impossible start containers because of Docker network error:

```
 ⠿ Network src_backend
 Error

failed to create network src_backend: Error response from daemon: could not find an available, non-overlapping IPv6 address pool among the defaults to assign to the network
```

At the moment reason is unknown.

**Solution**: Disable IPv6 for networks in the `docker-compose.yml`:

```yaml
networks:
  backend:
    enable_ipv6: false
  frontend:
    enable_ipv6: false
```

PHP versions `8.1` and `8.2` can not be compiled
------------------------------------------------

PHP versions `8.1` and `8.2` can not be compiled with Alpine versions `3.14` and above.

```
#0 520.3 Installing libavif
#0 525.3 curl: (6) Could not resolve host: codeload.github.com
#0 525.4 [/tmp/src/tmp.NjLleA]
#0 525.4   End-of-central-directory signature not found.  Either this file is not
#0 525.4   a zipfile, or it constitutes one disk of a multi-part archive.  In the
#0 525.4   latter case the central directory and zipfile comment will be found on
#0 525.4   the last disk(s) of this archive.
#0 525.4 unzip:  cannot find zipfile directory in one of /tmp/src/tmp.NjLleA or
#0 525.4         /tmp/src/tmp.NjLleA.zip, and cannot find /tmp/src/tmp.NjLleA.ZIP, period.
#0 525.4 CMake Warning:
#0 525.4   Ignoring extra path from command line:
#0 525.4
#0 525.4    ".."
#0 525.4
#0 525.4
#0 525.4 CMake Error: The source directory "/tmp/src/tmp.GGIpcp" does not appear to contain CMakeLists.txt.
#0 525.4 Specify --help for usage, or press the help button on the CMake GUI.
------
failed to solve: executor failed running [/bin/sh -c install-php-extensions     gd     mbstring     intl     gettext     bz2     zip     soap     exif     pdo     pdo_mysql     mysqli     opcache     ;]: exit code: 1
```
