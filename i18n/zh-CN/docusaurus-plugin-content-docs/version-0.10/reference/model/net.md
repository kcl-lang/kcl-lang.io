---
title: "net"
linkTitle: "net"
type: "docs"
description: net 包 - 网络IP处理
weight: 100
---

## split_host_port

`split_host_port(ip_end_point: str) -> List[str]`

从 `ip_end_point` 分离出 `host` 和 `port`。

```python
import net

host_and_port = net.split_host_port("B-K0NZJGH6-0048.local:80")
host_port = net.join_host_port("B-K0NZJGH6-0048.local", 80)
```

## join_host_port

`join_host_port(host, port) -> str`

合并 `host` 和 `port`。

```python
import net

host_and_port = net.split_host_port("B-K0NZJGH6-0048.local:80")
host_port = net.join_host_port("B-K0NZJGH6-0048.local", 80)
```

## fqdn

`fqdn(name: str = '') -> str`

返回完全限定域名（FQDN）。

```python
import net

fqdn = net.fqdn()
```

## parse_IP

`parse_IP(ip) -> str`

将 `ip` 解析为真实的 IP 地址。

```python
import net

ip = net.parse_IP("192.168.0.1")
```

## to_IP4

`to_IP4(ip) -> str`

获取 `ip` 的 IPv4 表示形式。

```python
import net

ip = net.to_IP4("192.168.0.1")
```

## to_IP16

`to_IP16(ip) -> int`

获取 `ip` 的 IPv6 表示形式。

```python
import net

ip = net.to_IP16("192.168.0.1")
```

## IP_string

`IP_string(ip: str | int) -> str`

返回 IP 字符串。

```python
import net

ip = net.IP_string("192.168.0.1")
```

## is_IPv4

`is_IPv4(ip: str) -> bool`

判断 `ip` 是否为 IPv4。

```python
import net

ip = net.is_IPv4("192.168.0.1")
```

## is_IP

`is_IP(ip: str) -> bool`

判断 `ip` 是否为有效的 IP 地址。

```python
import net

ip = net.is_IP("192.168.0.1")
```

## is_loopback_IP

`is_loopback_IP(ip: str) -> bool`

判断 `ip` 是否为回环地址。

```python
import net

isip = net.is_loopback_IP("127.0.0.1")
```

## is_multicast_IP

`is_multicast_IP(ip: str) -> bool`

判断 `ip` 是否为组播地址。

```python
import net

isip = net.is_multicast_IP("239.255.255.255")
```

## is_interface_local_multicast_IP

`is_interface_local_multicast_IP(ip: str) -> bool`

判断 `ip` 是否为接口、本地和组播地址。

```python
import net

isip = net.is_interface_local_multicast_IP("239.255.255.255")
```

## is_link_local_multicast_IP

`is_link_local_multicast_IP(ip: str) -> bool`

判断 `ip` 是否为链路本地和组播地址。

```python
import net

isip = net.is_link_local_multicast_IP("224.0.0.0")
```

## is_link_local_unicast_IP

`is_link_local_unicast_IP(ip: str) -> bool`

判断 `ip` 是否为链路本地和单播地址。

```python
import net

isip = net.is_link_local_unicast_IP("fe80::2012:1")
```

## is_global_unicast_IP

`is_global_unicast_IP(ip: str) -> bool`

判断 `ip` 是否为全局单播地址。

```python
import net

isip = net.is_global_unicast_IP("220.181.108.89")
```

## is_unspecified_IP

`is_unspecified_IP(ip: str) -> bool`

判断 `ip` 是否为 `unspecified` 地址。

```python
import net

isip = net.is_unspecified_IP("0.0.0.0")
```
