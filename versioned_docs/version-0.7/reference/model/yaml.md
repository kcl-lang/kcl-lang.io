---
title: "yaml"
linkTitle: "yaml"
type: "docs"
description: yaml encode and decode function
weight: 300
---

## encode

```kcl
encode(
    data: any,
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

Serialize a KCL object `data` to a YAML formatted str.

## encode_all

```kcl
encode(
    data: [any],
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

Serialize a sequence of KCL objects into a YAML stream str.

## decode

`decode(value: str) -> any`

Deserialize `value` (a string instance containing a YAML document) to a KCL object.

## decode_all

`decode_all(value: str) -> [any]`

Parse all YAML documents in a stream and produce corresponding KCL objects.

## dump_to_file

```kcl
dump_to_file(
    data: any,
    filename: str,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

Serialize a KCL object `data` to a YAML formatted str and write it into the file `filename`.

## validate

```kcl
validate(value: str) -> bool
```

Validate whether the given string is a valid YAML or YAML stream document.
