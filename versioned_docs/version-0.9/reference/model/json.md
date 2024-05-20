---
title: "json"
linkTitle: "json"
type: "docs"
description: json system module
weight: 100
---

## encode

```python
encode(
    data: any,
    sort_keys: bool = False,
    indent: int = None,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

Serialize a KCL object `data` to a JSON formatted str.

## decode

`decode(value: str) -> any`

Deserialize `value` (a string instance containing a JSON document) to a KCL object.

## dump_to_file

```python
dump_to_file(
    data: any,
    filename: str,
    sort_keys: bool = False,
    indent: int = None,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

Serialize a KCL object `data` to a JSON formatted str and write it into the file `filename`.

## validate

```python
validate(value: str) -> bool
```

Validate whether the given string is a valid JSON.
