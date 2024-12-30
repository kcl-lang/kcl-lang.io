---
sidebar_position: 7
---

# Validation

## Introduction

The KCL Validation tool supports basic configuration data verification capabilities. You can write a KCL schema to verify the type and value of the input JSON/YAML files.

## How to use

There is a JSON format file `data.json`:

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

Build a validated KCL file `schema.k`:

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

Execute the following command:

```shell
kcl vet data.json schema.k
```

## Specify the schema for validation

When multiple schema definitions exist in the KCL file, by default, the KCL Validation tool will use the first schema to check. If you need to specify a schema for verification, you can use the `-s|--schema` parameter

```shell
kcl vet data.json schema.k -s User
```

## Args

```shell
This command validates the data file using the kcl code.

Usage:
  kcl vet [flags]

Examples:
  # Validate the JSON data using the kcl code
  kcl vet data.json code.k


Flags:
  -a, --attribute_name string   Specify the validate config attribute name.
      --format string           Specify the validate data format. e.g., yaml, json. Default is json
  -h, --help                    help for vet
  -s, --schema string           Specify the validate schema.
```
