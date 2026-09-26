---
title: "json"
linkTitle: "json"
type: "docs"
description: JSON 编码解码
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

将 KCL 对象 `data` 序列化为 JSON 格式的字符串。

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

反序列化 `value`（一个包含 JSON 格式文档的字符串实例）为一个 KCL 对象。

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

按照 [RFC 7396 JSON Merge Patch](https://datatracker.ietf.org/doc/html/rfc7396) 将 KCL 对象 `patch` 合并到 KCL 对象 `src` 中，并返回合并后的对象。

- 如果 `patch` 不是 dict/config，则直接替换 `src`。
- 如果 `patch` 中某个键的值为 `None`/`Undefined`，则该键会从结果中删除。
- 如果 `patch` 中某个键的值为 dict/config，则与 `src` 中对应的键递归合并。
- 其他情况使用 `patch` 中的值替换 `src` 中的值。

`src` 和 `patch` 都不会被修改，返回的是一个新对象。

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
    "age": None  # 删除 "age" 键
    "profile": {
        "city": "Boston"
    }
    "tags": ["a", "b"]  # 新增键
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

将 KCL 对象 `data` 序列化为 JSON 格式的字符串，并将其写入文件 `filename` 中。

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

验证给定的字符串是否是一个合法的 JSON 字符串。

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
