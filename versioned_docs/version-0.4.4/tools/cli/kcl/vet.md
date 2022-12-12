---
sidebar_position: 4
---

# Validation

## Intro

The KCL Validation tool supports basic configuration data verification capabilities. You can write a KCL schema to verify the type and value of the input JSON/YAML files.

## How to use

There is a JSON format file `data.json`:

```json
{
    "name": "Alice",
    "age": "18",
    "message": "This is Alice",
    "data": {
        "id": "1",
        "value": "value1"
    },
    "labels": {
        "key": "value"
    },
    "hc": [1, 2, 3]
}
```

Build a validate KCL file `schema.k`:

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

```
$ kcl-vet data.json schema.k
Validate succuss!
```

## Specify the schema for validation

When multiple schema definitions exist in the KCL file, by default, the KCL Validation tool will use the first schema to check. If you need to specify a schema for verification, you can use the `-d|--schema` parameter

```
$kcl-vet data.json schema.k -d User
```

## Args

```
$ kcl-vet -h
usage: kcl-vet [-h] [-d schema] [--format format] [-n attribute_name]
               data_file kcl_file

positional arguments:
  data_file             Validation data file
  kcl_file              KCL file

optional arguments:
  -h, --help            show this help message and exit
  -d schema, --schema schema
  --format format       Validation data file format, support YAML and JSON
  -n attribute_name, --attribute-name attribute_name
```
