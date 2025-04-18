---
title: "net"
linkTitle: "net"
type: "docs"
description: net system module
weight: 100
---

## split_host_port

`split_host_port(ip_end_point: str) -> [str]`

Splits an `ip_end_point` of the form `host:port` or `[host]:port` into a `host` and `port`.
Returns a list containing the `host` and `port`, respectively.

An IPv6 literal in the `ip_end_point` must be enclosed in square brackets and will be returned
without the enclosing brackets.

```python
import net

assert net.split_host_port("B-K0NZJGH6-0048.local:80") == ["B-K0NZJGH6-0048.local", "80"]
assert net.split_host_port("[::1]:80") == ["::1", "80"]
```

## join_host_port

`join_host_port(host: str, port: int | str) -> str`

Combines `host` and `port` into a network address of the form `host:port`.
If `host` contains a colon, as found in an IPv6 address literal, then returns `[host]:port`. 

```python
import net

assert net.join_host_port("B-K0NZJGH6-0048.local", 80) == "B-K0NZJGH6-0048.local:80"
assert net.join_host_port("::1", "80") == "[::1]:80"
```

## fqdn

`fqdn(name: str = '') -> str`

Returns the Fully Qualified Domain Name (FQDN) of `name`, determined by
performing a reverse DNS lookup on the first address returned by a forward DNS
lookup. If `name` is specified as or defaults to the empty string, uses the system
hostname for the forward DNS lookup.

This function is not supported on the WASM target.

```python
import net

fqdn = net.fqdn()
```

## parse_IP

`parse_IP(ip: str) -> str`

Parses the IP address `ip` and returns it in canonical form. If `ip` does
not have valid syntax, returns the empty string.

```python
import net

assert net.parse_IP("192.168.0.1") == "192.168.0.1"
assert net.parse_IP("2001:0db8:0:0:0:0:0:0") == "2001:db8::"
assert net.parse_IP("invalid") == ""
```

## to_IP4

`to_IP4(ip: str) -> str`

A synonym for `parse_IP()`.

```python
import net

ip = net.to_IP4("192.168.0.1")
```

## to_IP16

`to_IP16(ip) -> int`

A synonym for `parse_IP()`.

```python
import net

ip = net.to_IP16("192.168.0.1")
```

## IP_string

`IP_string(ip: str) -> str`

A synonym for `parse_IP()`.

```python
import net

ip = net.IP_string("192.168.0.1")
```

## is_IPv4

`is_IPv4(ip: str) -> bool`

If `ip` is a valid IPv4 address, returns `True`. Otherwise, returns `False`.

```python
import net

assert net.is_IPv4("192.168.0.1") == True
assert net.is_IPv4("::1") == False
assert net.is_IPv4("invalid") == False
```

## is_IP

`is_IP(ip: str) -> bool`

If `ip` is a valid IPv4 or IPv6 address, returns `True`. Otherwise, returns `False`.

```python
import net

assert net.is_IPv4("192.168.0.1") == True
assert net.is_IPv4("::1") == True
assert net.is_IPv4("invalid") == False
```

## is_loopback_IP

`is_loopback_IP(ip: str) -> bool`

If `ip` is an IPv4 or IPv6 loopback address, returns `True`. Otherwise, returns `False`.

```python
import net

assert net.is_loopback_IP("127.0.0.1") == True
assert net.is_loopback_IP("127.1.2.3") == True
assert net.is_loopback_IP("192.168.0.1") == False
assert net.is_loopback_IP("::1") == True
assert net.is_loopback_IP("::") == False
assert net.is_loopback_IP("invalid") == False
```

## is_multicast_IP

`is_multicast_IP(ip: str) -> bool`

If `ip` is an IPv4 or IPv6 multicast address, returns `True`. Otherwise, returns `False`.

```python
import net

assert net.is_multicast_IP("239.255.255.255") == True
assert net.is_multicast_IP("10.1.2.3") == False
assert net.is_multicast_IP("ff02::1") == True
assert net.is_multicast_IP("2001:0db8::") == False
assert net.is_multicast_IP("invalid") == False
```

## is_interface_local_multicast_IP

`is_interface_local_multicast_IP(ip: str) -> bool`

Whether `ip` is a interface, local and multicast one.

```python
import net

isip = net.is_interface_local_multicast_IP("239.255.255.255")
```

## is_link_local_multicast_IP

`is_link_local_multicast_IP(ip: str) -> bool`

Whether `ip` is a link local and multicast one.

```python
import net

isip = net.is_link_local_multicast_IP("224.0.0.0")
```

## is_link_local_unicast_IP

`is_link_local_unicast_IP(ip: str) -> bool`

Whether `ip` is a link local and unicast one.

```python
import net

isip = net.is_link_local_unicast_IP("fe80::2012:1")
```

## is_global_unicast_IP

`is_global_unicast_IP(ip: str) -> bool`

Whether `ip` is a global and unicast one.

```python
import net

isip = net.is_global_unicast_IP("220.181.108.89")
```

## is_unspecified_IP

`is_unspecified_IP(ip: str) -> bool`

If `ip` is the IPv4 or IPv6 unspecified address, returns `True`. Otherwise, returns `False`.

```python
import net

assert net.is_unspecified_IP("0.0.0.0") == True
assert net.is_unspecified_IP("10.0.0.1") == False
assert net.is_unspecified_IP("::") == True
assert net.is_unspecified_IP("2001:0db8::") == False
assert net.is_unspecified_IP("invalid") == False
```
