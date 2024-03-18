---
sidebar_position: 4
---

# Validation 校验代码

## 简介

KCL 支持通过内置的 `kcl-vet` 命令行工具提供了基本的配置数据校验能力，可以编写 KCL schema 对输入的 JSON/YAML 格式文件进行类型以及数值的校验。

## 使用方式

假设有 data.json 文件，代码如下:

```json
{
  "name": "Alice",
  "age": 18,
  "message": "This is Alice",
  "data": {
    "id": 1,
    "value": "value1"
  },
  "labels": {
    "key": "value"
  },
  "hc": [1, 2, 3]
}
```

构造 schema.k 校验文件，内容如下：

```py
schema User:
    name: str
    age: int
    message?: str
    data: Data
    labels: {str:}
    hc: [int]

    check:
        age > 10

schema Data:
    id: int
    value: str
```

在目录下执行如下命令

```shell
$ kcl-vet data.json schema.k
```

## 指定校验的 schema

当校验的 KCL 文件中存在多个 schema 定义时，kcl-vet 工具会默认取第一个 schema 定义进行校验，如果需要指定校验的 schema，可以使用 `-d|--schema` 参数

```shell
$ kcl-vet data.json schema.k -d User
```

## 命令行参数

```shell
$ kcl-vet -h
USAGE:
    kcl-vet [OPTIONS] [ARGS]

ARGS:
    <data_file>    Validation data file
    <kcl_file>     KCL file

OPTIONS:
    -d, --schema <schema>
            Iterate through subdirectories recursively

        --format <format>
            Validation data file format, support YAML and JSON, default is JSON

    -h, --help
            Print help information

    -n, --attribute_name <attribute_name>
            The attribute name for the data loading
```
