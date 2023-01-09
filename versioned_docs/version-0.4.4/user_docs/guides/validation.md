---
title: "Validation"
sidebar_position: 2
---

## Use KCL to Validate Data

In addition to using KCL code to generate configuration formats such as JSON/YAML, KCL also supports format validation of JSON/YAML data. As a configuration language, KCL covers almost all features of [OpenAPI](https://www.openapis.org/).

In KCL, a structure definition can be used to validate configuration data. At the same time, it supports user-defined constraint rules through the check block, and writes validation expressions in the schema to check and validate the attributes defined by the schema. It is very clear and simple to check whether the input JSON/YAML satisfies the corresponding schema structure definition and constraints.

## Introduction

In the schema we can use the `check` keyword to write the validation rules of every schema attribute. Each line in the check block corresponds to a conditional expression. When the condition is satisfied, the validation is successful. The conditional expression can be followed by `, "check error message"` to indicate the message to be displayed when the check fails. Here is an example of a schema with constraint expressions.

```python
import regex

schema Sample:
    foo: str  # Required, cannot be None/Undefined, and the type must be str
    bar: int  # Required, cannot be None/Undefined, and the type must be int
    fooList: [int]  # Required, cannot be None/Undefined, and the type must be int list
    color: "Red" | "Yellow" | "Blue"  # Required, literal union type, and must be one of "Red", "Yellow", "Blue".
    id?: int  # Optional, can be None/Undefined, the type must be int

    check:
        0 <= bar < 100  # bar must be greater than or equal to 0 and less than 100
        0 < len(fooList) < 100  # fooList cannot be None/Undefined, and the length must be greater than 0 and less than 100
        regex.match(foo, "^The.*Foo$")  # regular expression matching
        bar in range(100)  # bar can only range from 1 to 99
        bar in [2, 4, 6, 8]  # bar can only take 2, 4, 6, 8
        bar % 2 == 0  # bar must be a multiple of 2
        all foo in fooList {
            foo > 1
        }  # All elements in fooList must be greater than 1
        any foo in fooList {
            foo > 10
        }  # At least one element in fooList must be greater than 10
        abs(id) > 10 if id  # check expression with if guard, when id is not empty, the absolute value of id must be greater than 10
```

To sum up, the validation kinds supported in KCL schema are:

| Kind              | Method                                                                                    |
| ----------------- | ----------------------------------------------------------------------------------------- |
| Range             | Using comparison operators such as `<`, `>`                                               |
| Regex             | Using methods such as `match` from the `regex` system module                              |
| Length            | Using the `len` built-in function to get the length of a variable of type `list/dict/str` |
| Enum              | Using literal union types                                                                 |
| Optional/Required | Using optional/required attributes of schema                                                |
| Condition         | Using the check if conditional expression                                                 |

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

```
$ kcl-vet data.json schema.k
Validate succuss!
```

Based on this, KCL provides the corresponding [Validation Tool](/docs/tools/cli/kcl/vet) to validate JSON/YAML data directly.In addition, based on this capability, we can build a K-V validation visualization product.

![](/img/blog/2022-09-15-declarative-config-overview/08-kcl-validation-ui.png)

## Future Plan

The improvement of KCL validation capabilities will gradually focus on the "static" aspect, that is, at compile time, combined with the ability of formal validation, it can directly analyze whether the data meets the constraints, whether the constraints conflict with each other, etc., and can be exposed in real-time through the IDE.

We also expect that KCL models and constraints can be managed as a package (this package has only KCL files). For example, the Kubernetes models and constraints can be used out of the box. Users can generate configurations or verify existing configurations, and can simply extend the models and constraints users want through KCL inheritance.
