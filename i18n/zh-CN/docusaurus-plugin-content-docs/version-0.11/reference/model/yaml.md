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

将 KCL 对象列表 `data` 序列化为包含 `---` 分隔符的 YAML Stream 格式的字符串。

```python
import yaml

yamlStr = yaml.encode_all([1, 2, 3])
```

## decode

`decode(value: str) -> any`

反序列化 `value`（一个包含 YAML 格式文档的字符串实例）为一个 KCL 对象。

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

反序列化 `value`（一个包含 `---` 分隔符的 YAML Stream 格式文档的字符串实例）为一个 KCL 对象列表。

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
    sort_keys: bool = False,
    ignore_private: bool = False,
    ignore_none: bool = False
) -> None
```

将 KCL 对象 `data` 序列化为 YAML 格式的字符串，并将其写入文件 `filename` 中。

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

将 KCL 对象列表序列化为 YAML Stream 格式，并将其写入文件 `filename` 中。

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

验证给定的字符串是否是一个合法的 YAML 或者 YAML Stream 格式的字符串。

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
