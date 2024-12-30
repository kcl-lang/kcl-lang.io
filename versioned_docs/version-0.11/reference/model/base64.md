---
title: "base64"
linkTitle: "base64"
type: "docs"
description: base64 system module - base64 encode and decode function
weight: 100
---

## encode

`encode(value: str, encoding: str = "utf-8") -> str`

Encode the string `value` using the codec registered for encoding.

```python
import base64

abcd_base64 = base64.encode("abcd")
```

## decode

`decode(value: str) -> str`

Decode the string `value` using the codec registered to the utf8 string for encoding.

```python
import base64

decode = base64.decode("MC4zLjA=")
```
