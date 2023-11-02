---
title: "yaml"
linkTitle: "yaml"
type: "docs"
description: yaml encode and decode function
weight: 300
---
## encode

```
encode(
    data: any,
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

Serialize a KCL object `data` to a YAML formatted str.

## decode

`decode(value: str) -> any`

Deserialize `value` (a string instance containing a YAML document) to a KCL object.

## dump_to_file

```
dump_to_file(
    data: any,
    filename: str,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

Serialize a KCL object `data` to a YAML formatted str and write it into the file `filename`.
