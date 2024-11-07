---
title: "base64"
linkTitle: "base64"
type: "docs"
description: base64 编码解码
weight: 100
---

## encode

`encode(value: str, encoding: str = "utf-8") -> str`

使用注册的编码器对字符串 `value` 进行编码。

```python
import base64

abcd_base64 = base64.encode("abcd")
```

## decode

`decode(value: str) -> str`

使用注册的编码器对字符串 `value` 进行解码，解码的结果是一个 utf8 字符串

```python
import base64

decode = base64.decode("MC4zLjA=")
```
