---
title: "net"
linkTitle: "net"
type: "docs"
description: net system module
weight: 100
---

## split_host_port

`split_host_port(ip_end_point: str) -> List[str]`

Split the `host` and `port` from the `ip_end_point`.

```python
import net

host_and_port = net.split_host_port("B-K0NZJGH6-0048.local:80")
host_port = net.join_host_port("B-K0NZJGH6-0048.local", 80)
```

## join_host_port

`join_host_port(host, port) -> str`

Merge the `host` and `port`.

```python
import net

host_and_port = net.split_host_port("B-K0NZJGH6-0048.local:80")
host_port = net.join_host_port("B-K0NZJGH6-0048.local", 80)
```

## fqdn

`fqdn(name: str = '') -> str`

Return Fully Qualified Domain Name (FQDN).

```python
import net

fqdn = net.fqdn()
```

## parse_IP

`parse_IP(ip) -> str`

Parse `ip` to a real IP address

```python
import net

ip = net.parse_IP("192.168.0.1")
```

## to_IP4

`to_IP4(ip) -> str`

Get the IP4 form of `ip`.

```python
import net

ip = net.to_IP4("192.168.0.1")
```

## to_IP16

`to_IP16(ip) -> int`

Get the IP16 form of `ip`.

```python
import net

ip = net.to_IP16("192.168.0.1")
```

## IP_string

`IP_string(ip: str | int) -> str`

Get the IP string.

```python
import net

ip = net.IP_string("192.168.0.1")
```

## is_IPv4

`is_IPv4(ip: str) -> bool`

Whether `ip` is a IPv4 one.

```python
import net

ip = net.is_IPv4("192.168.0.1")
```

## is_IP

`is_IP(ip: str) -> bool`

Whether `ip` is a valid ip address.

```python
import net

ip = net.is_IP("192.168.0.1")
```

## is_loopback_IP

`is_loopback_IP(ip: str) -> bool`

Whether `ip` is a loopback one.

```python
import net

isip = net.is_loopback_IP("127.0.0.1")
```

## is_multicast_IP

`is_multicast_IP(ip: str) -> bool`

Whether `ip` is a multicast one.

```python
import net

isip = net.is_multicast_IP("239.255.255.255")
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

Whether `ip` is a unspecified one.

```python
import net

isip = net.is_unspecified_IP("0.0.0.0")
```
