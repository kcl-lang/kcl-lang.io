---
title: "json"
linkTitle: "json"
type: "docs"
description: json system module
weight: 100
---

## encode

```kcl
encode(
    data: any,
    sort_keys: bool = False,
    indent: int = None,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

Serialize a KCL object `data` to a JSON formatted str.

```kcl
import json

data = {
    "key1": "value1"
    "key2": "value2"
    "data": [1, 2, 3]
}
data_string = json.encode(data)
```

## decode

`decode(value: str) -> any`

Deserialize `value` (a string instance containing a JSON document) to a KCL object.

```kcl
import file
import json

data_string = json.decode(file.read(file.modpath()+"/test.json"))

key1 = data_string.key1
key2 = data_string.key2
data = data_string.data
```

## merge

`merge(src: any, patch: any) -> any`

Merges the KCL object `patch` into the KCL object `src` according to [RFC 7396 JSON Merge Patch](https://datatracker.ietf.org/doc/html/rfc7396) and returns the merged object.

- If `patch` is not a dict/config, it replaces `src` entirely.
- If a key of `patch` holds `None`/`Undefined`, that key is removed from the result.
- If a key of `patch` holds a dict/config, it is merged recursively with the corresponding key of `src`.
- Otherwise the value from `patch` replaces the value from `src`.

Neither `src` nor `patch` is modified; a new merged object is returned.

```kcl
import json

src = {
    "name": "Alice"
    "age": 18
    "profile": {
        "city": "New York"
        "zip": "10001"
    }
}
patch = {
    "age": None  # remove the key "age"
    "profile": {
        "city": "Boston"
    }
    "tags": ["a", "b"]  # add a new key
}
result = json.merge(src, patch)
# {
#     "name": "Alice"
#     "profile": {
#         "city": "Boston"
#         "zip": "10001"
#     }
#     "tags": ["a", "b"]
# }
```

## dump_to_file

```kcl
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

```kcl
import json

schema Person:
    name?: str
    age?: int
    school?: str
    data?: [int] = [1, 2, None]

person = Person {
    name: "Alice"
    age: 18
}
filename = "out.json"
json.dump_to_file(person, filename, indent=4, ignore_private=True, ignore_none=True)
```

## validate

```kcl
validate(value: str) -> bool
```

Validate whether the given string is a valid JSON.

```kcl
import json

# Right cases

resultRight1: bool = json.validate("1")
resultRight2: bool = json.validate("true")
resultRight3: bool = json.validate("1.20")
resultRight4: bool = json.validate("null")
resultRight5: bool = json.validate("[0, 1, 2]")
resultRight6: bool = json.validate('{"key": "value"}')

# Wrong cases

resultWrong1: bool = json.validate("1@")
resultWrong2: bool = json.validate("True")
resultWrong3: bool = json.validate("1.20.23+1")
resultWrong4: bool = json.validate("None")
resultWrong5: bool = json.validate("[0, 1, 2,]")
resultWrong6: bool = json.validate(r'''{"key": 'value'}''')
```
