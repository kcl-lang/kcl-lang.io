---
title: "json"
linkTitle: "json"
type: "docs"
description: JSON 编码解码
weight: 100
---

## encode

```
encode(
    data: any,
    sort_keys: bool = False,
    indent: int = None,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

将 KCL 对象 `data` 序列化为 JSON 格式的字符串。

## decode

`decode(value: str) -> any`

反序列化 `value`（一个包含 JSON 格式文档的字符串实例）为一个 KCL 对象。

## dump_to_file

```
dump_to_file(
    data: any,
    filename: str,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

将 KCL 对象 `data` 序列化为 JSON 格式的字符串，并将其写入文件 `filename` 中。
