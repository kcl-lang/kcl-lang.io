---
title: "json"
linkTitle: "json"
type: "docs"
description: JSON 编码解码
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

将 KCL 对象 `data` 序列化为 JSON 格式的字符串。

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

反序列化 `value`（一个包含 JSON 格式文档的字符串实例）为一个 KCL 对象。

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

将 KCL 对象 `data` 序列化为 JSON 格式的字符串，并将其写入文件 `filename` 中。

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

验证给定的字符串是否是一个合法的 JSON 字符串。

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
