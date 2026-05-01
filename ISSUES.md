KNOWN ISSUES
============

Network IPv6 error
------------------

Some time ago, it was impossible to start containers because of a Docker network error:

```
 ⠿ Network src_backend
 Error

failed to create network src_backend: Error response from daemon: could not find an available, non-overlapping IPv6 address pool among the defaults to assign to the network
```

The reason is unknown.

**Solution**: Disable IPv6 for networks in `docker-compose.yml`:

```yaml
networks:
  backend:
    enable_ipv6: false
  frontend:
    enable_ipv6: false
```
