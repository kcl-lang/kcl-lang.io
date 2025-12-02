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

## parse_CIDR

`parse_CIDR(cidr: str) -> {}`

Parses the CIDR block `cidr` into a dict members.

If `cidr` parses, the returned dict has two members:
`ip` has the first IP in the block and `mask` has the prefix length as an `int`.

If `cidr` does not parse, returns the empty dict, `{}`.

```python
import net

assert net.parse_CIDR("10.0.0.0/8") == { ip: "10.0.0.0", mask: 8 }
assert net.parse_CIDR("2001:db8::/56") == { ip: "2001:db8::", mask: 56 }
assert net.parse_CIDR("invalid") == {}
```

## is_IP_in_CIDR

`is_IP_in_CIDR(ip: str, cidr: str) -> bool`

If `ip` is contained in `cidr`, returns `True`. Otherwise, returns `False`.

If `ip` is an IPv4 address and `cidr` is an IPv6 CIDR, treats `ip` as
if it were encoded as an IPv4-mapped IPv6 address.

```python
import net

assert net.is_IP_in_CIDR("10.1.2.3", "10.0.0.0/8")
assert not net.is_IP_in_CIDR("11.1.2.3", "10.0.0.0/8")
assert net.is_IP_in_CIDR("2001:db8::9", "2001:db8::/56")
assert not net.is_IP_in_CIDR("2fff::9", "2001:db8::/56")
assert net.is_IP_in_CIDR("10.1.2.3", "::/0")
```

## CIDR_subnet

`CIDR_subnet(cidr: str, additional_bits: int, net_num: int) -> str`

Calculates a subnet of the CIDR `cidr`.

Extends the prefix of `cidr` by `additional_bits`. For example, if `cidr` is
a `/18` and `additional_bits` is `6`, then the result will be a `/24`.

`net_num` is a non-negative number used to populate the bits added to the prefix.

```python
import net

assert net.CIDR_subnet("10.0.0.0/8", 8, 11) == "10.11.0.0/16"
assert net.CIDR_subnet("2001:db8::/56", 8, 10) == "2001:db8:0:a::/64"
```

## CIDR_subnets

`CIDR_subnets(cidr: str, additional_bits: [int]) -> [str]`

Allocates a sequence of subnets within `cidr`. `additional_bits` specifies,
for each subnet to allocate, the number of bits by which to extend the prefix
of `cidr`. Returns a list of the allocated subnet CIDRs.

If later called with the same `cidr` and an `additional_bits` with only additions
on the end, will return the same allocations for those previous `additional_bits`.

```python
import net

assert net.CIDR_subnets("10.0.0.0/8", [8, 9, 8]) == ["10.0.0.0/16", "10.1.0.0/17", "10.2.0.0/16"]
assert net.CIDR_subnets("2001:db8::/56", [8, 7]) == ["2001:db8::/64", "2001:db8:0:2::/63"]
```

## CIDR_host

`CIDR_host(cidr: str, host_num: int) -> str`

Calculates an IP for a host within `cidr`.

`host_num` is a number used to populate the bits added to the prefix. If the number is negative,
the count starts from the end of the range.

```python
import net

assert net.CIDR_host("10.0.0.0/8", 11) == "10.0.0.11"
assert net.CIDR_host("10.0.0.0/8", -11) == "10.255.255.245"
assert net.CIDR_host("2001:db8::/56", 10) == "2001:db8::a"
```

## CIDR_netmask

`CIDR_netmask(cidr: str) -> str`

Returns the netmask for the IPv4 subnet `cidr`.

```python
import net

assert net.CIDR_netmask("10.0.0.0/8") == "10.255.255.255"
```
