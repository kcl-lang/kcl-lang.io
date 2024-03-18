---
title: "yaml"
linkTitle: "yaml"
type: "docs"
description: yaml 编码解码
weight: 300
---

## encode

```python
encode(
    data: any,
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

将 KCL 对象 `data` 序列化为 YAML 格式的字符串。

## encode_all

```python
encode(
    data: [any],
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

将 KCL 对象列表 `data` 序列化为包含 `---` 分隔符的 YAML Stream 格式的字符串。

## decode

`decode(value: str) -> any`

反序列化 `value`（一个包含 YAML 格式文档的字符串实例）为一个 KCL 对象。

## decode_all

`decode_all(value: str) -> [any]`

反序列化 `value`（一个包含 `---` 分隔符的 YAML Stream 格式文档的字符串实例）为一个 KCL 对象列表。

## dump_to_file

```python
dump_to_file(
    data: any,
    filename: str,
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

将 KCL 对象 `data` 序列化为 YAML 格式的字符串，并将其写入文件 `filename` 中。

## validate

```python
validate(value: str) -> bool
```

验证给定的字符串是否是一个合法的 YAML 或者 YAML Stream 格式的字符串。
