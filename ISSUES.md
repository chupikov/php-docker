KNOWN ISSUES
============

MariaDB does not start on Windows hosts
---------------------------------------

MariaDB container doesn't start on Windows hosts with shared databases volume.

Get error _"Installation of system tables failed"_.

Because of this default database server changed
from _[MariaDB 10.3](https://hub.docker.com/_/mariadb)_
to _[MySQL 5.7](https://hub.docker.com/_/mysql)_.


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
