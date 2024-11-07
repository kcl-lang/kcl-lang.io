---
title: "yaml"
linkTitle: "yaml"
type: "docs"
description: yaml encode and decode function
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

Serialize a KCL object `data` to a YAML formatted str.

```python
import yaml

data = {
    "key1": "value1"
    "key2": "value2"
    "data": [1, 2, 3]
}
data_string = yaml.encode(data)
```

## encode_all

```python
encode(
    data: [any],
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> str
```

Serialize a sequence of KCL objects into a YAML stream str.

```python
import yaml

yamlStr = yaml.encode_all([1, 2, 3])
```

## decode

`decode(value: str) -> any`

Deserialize `value` (a string instance containing a YAML document) to a KCL object.

```python
import yaml
import file

data_string = yaml.decode(file.read("test.yaml"))

key1 = data_string.key1
key2 = data_string.key2
data = data_string.data
```

## decode_all

`decode_all(value: str) -> [any]`

Parse all YAML documents in a stream and produce corresponding KCL objects.

```python
import yaml

yamlStr = """\
key: value
"""
data = yaml.decode(yamlStr)
dataList = yaml.decode_all(yamlStr)
```

## dump_to_file

```python
dump_to_file(
    data: any,
    filename: str,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

Serialize a KCL object `data` to a YAML formatted str and write it into the file `filename`.

```python
import yaml

schema Person:
    name?: str
    age?: int
    school?: str
    data?: [int] = [1, 2, None]

person = Person {
    name: "Alice"
    age: 18
}
filename = "out.yaml"
yaml.dump_to_file(person, filename, ignore_private=True, ignore_none=True)
```

## dump_all_to_file

```python
dump_all_to_file(
    data: [any],
    filename: str,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

Serialize a sequence of KCL objects into a YAML stream str and write it into the file `filename`.

```python
import yaml

yamlStrList = [
    'key: value',
    '- 1\n- 2\n- 3',
    '1',
    '1.1',
    'null',
    'true',
]
yaml.dump_all_to_file(yamlStrList, "0.yaml")
```

## validate

```python
validate(value: str) -> bool
```

Validate whether the given string is a valid YAML or YAML stream document.

```python
import yaml

# Right cases

resultRight1: bool = yaml.validate("1")
resultRight2: bool = yaml.validate("true")
resultRight3: bool = yaml.validate("1.20")
resultRight4: bool = yaml.validate("null")
resultRight5: bool = yaml.validate("[0, 1, 2]")
resultRight6: bool = yaml.validate('{"key": "value"}')
resultRight7: bool = yaml.validate('a:1\n---\nb:2')

# Wrong cases

resultWrong1: bool = yaml.validate("a:\n1")
resultWrong2: bool = yaml.validate("a:\n1\n  - 2")
resultWrong3: bool = yaml.validate("a:\n-1")
resultWrong4: bool = yaml.validate("1a   : \n1")
resultWrong5: bool = yaml.validate("a:\n- 1\n-----\na:\n- 1")
resultWrong6: bool = yaml.validate(r'''{"key" + 'value'}''')
resultWrong7: bool = yaml.validate("a:1\n-----\nb:\n-2")
```
