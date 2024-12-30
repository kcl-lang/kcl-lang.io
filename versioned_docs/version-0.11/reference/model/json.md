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

```python
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

```python
import file
import json

data_string = json.decode(file.read(file.modpath()+"/test.json"))

key1 = data_string.key1
key2 = data_string.key2
data = data_string.data
```

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

```python
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

```python
validate(value: str) -> bool
```

Validate whether the given string is a valid JSON.

```python
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
