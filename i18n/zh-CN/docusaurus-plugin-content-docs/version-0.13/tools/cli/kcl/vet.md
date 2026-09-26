---
sidebar_position: 7
---

# 校验工具

## 简介

KCL 支持通过内置的 `kcl vet` 命令行工具提供了基本的配置数据校验能力，可以编写 KCL schema 对输入的 JSON/YAML 格式文件进行类型以及数值的校验。

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
kcl vet data.json schema.k
```

## 指定校验的 schema

当校验的 KCL 文件中存在多个 schema 定义时，kcl vet 工具会默认取第一个 schema 定义进行校验，如果需要指定校验的 schema，可以使用 `-s|--schema` 参数

```shell
kcl vet data.json schema.k -s User
```

## 命令行参数

```shell
This command validates the data file using the kcl code.

Usage:
  kcl vet [flags]

Examples:
  # Validate the JSON data using the kcl code
  kcl vet data.json code.k

  # Validate the YAML data using the kcl code
  kcl vet data.yaml code.k --format yaml

  # Validate the JSON data using the kcl code with the schema name
  kcl vet data.json code.k -s Schema

  # Validate and output results as JSON for CI/CD integration
  kcl vet data.json code.k --output json

  # Validate against a schema that imports an external KCL package
  kcl vet data.yaml schema.k -E my_pkg=./vendor/my_pkg

Flags:
  -a, --attribute_name string   Specify the validate config attribute name.
  -E, --external stringArray    Specify the mapping of package name and path where the package is located, e.g., my_pkg=./vendor/my_pkg
      --format string           Specify the validate data format. e.g., yaml, json. Default is json
  -h, --help                    help for vet
      --output string           Specify the output format. e.g., text, json. Default is text (default "text")
  -s, --schema string           Specify the validate schema.
```
