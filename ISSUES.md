KNOWN ISSUES
============

Network IPv6 error
------------------

Some time ago was impossible start containers because of Docker network error:

```
 ⠿ Network src_backend
 Error

failed to create network src_backend: Error response from daemon: could not find an available, non-overlapping IPv6 address pool among the defaults to assign to the network
```

Reason is unknown.

**Solution**: Disable IPv6 for networks in the `docker-compose.yml`:

```yaml
networks:
  backend:
    enable_ipv6: false
  frontend:
    enable_ipv6: false
```
