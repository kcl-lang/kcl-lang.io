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

## join_host_port

`join_host_port(host, port) -> str`

Merge the `host` and `port`.

## fqdn

`fqdn(name: str = '') -> str`

Return Fully Qualified Domain Name (FQDN).

## parse_IP

`parse_IP(ip) -> str`

Parse `ip` to a real IP address

## to_IP4

`to_IP4(ip) -> str`

Get the IP4 form of `ip`.

## to_IP16

`to_IP16(ip) -> int`

Get the IP16 form of `ip`.

## IP_string

`IP_string(ip: str | int) -> str`

Get the IP string.

## is_IPv4

`is_IPv4(ip: str) -> bool`

Whether `ip` is a IPv4 one.

## is_IP

`is_IP(ip: str) -> bool`

Whether `ip` is a valid ip address.

## is_loopback_IP

`is_loopback_IP(ip: str) -> bool`

Whether `ip` is a loopback one.

## is_multicast_IP

`is_multicast_IP(ip: str) -> bool`

Whether `ip` is a multicast one.

## is_interface_local_multicast_IP

`is_interface_local_multicast_IP(ip: str) -> bool`

Whether `ip` is a interface, local and multicast one.

## is_link_local_multicast_IP

`is_link_local_multicast_IP(ip: str) -> bool`

Whether `ip` is a link local and multicast one.

## is_link_local_unicast_IP

`is_link_local_unicast_IP(ip: str) -> bool`

Whether `ip` is a link local and unicast one.

## is_global_unicast_IP

`is_global_unicast_IP(ip: str) -> bool`

Whether `ip` is a global and unicast one.

## is_unspecified_IP

`is_unspecified_IP(ip: str) -> bool`

Whether `ip` is a unspecified one.
