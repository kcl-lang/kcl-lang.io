---
sidebar_position: 3
---

# Quick Start

KCL is a cloud-native domain configuration and policy language. At the beginning of its design, KCL was inspired by Python3, and at the same time absorbed the conceptual design of declarative and OOP programming paradigms. In this section we will quickly demonstrate the basic features of the KCL language.

## 1. Hello KCL

The best way to learn a new language is to write a few small programs, and the same goes for configuring languages. We can write KCL programs just like writing configuration.

Here is a simple `hello.k`:

```python
hello = "KCL"
```

Set the `hello` attribute to the `"KCL"` string. Then save the code to the `hello.k` file.

How to execute this program depends on the specific development environment, we first assume that the local macOS or Linux system has installed the `kcl` command (or enter the **Docker** environment test by `docker run --rm -it kcllang/kcl`) and then run the following command:

```shell
kcl hello.k
```

The output is

```yaml
hello: KCL
```

The effect of command line execution is shown as follows:

![](/img/docs/user_docs/getting-started/hello.gif)

The output is configuration data in YAML format. Although this program is simple, we can verify the basic usage of the development environment and the `kcl` command line by executing the KCL configuration program to the output.

## 2. A little more complicated configuration

In addition to the common key-value pairs, common configuration data also has nested dictionary and list types, and the value basic type includes boolean and numeric types in addition to strings. Here's a slightly more complex `server.k` configuration:

```python
# This is a KCL document

title = "KCL Example"

owner = {
    name = "The KCL Authors"
    data = "2020-01-02T03:04:05"
}

database = {
    enabled = True
    ports = [8000, 8001, 8002]
    data = [["delta", "phi"], [3.14]]
    temp_targets = {cpu = 79.5, case = 72.0}
}

servers = [
    {ip = "10.0.0.1", role = "frontend"}
    {ip = "10.0.0.2", role = "backend"}
]
```

where `#` begins with a line comment. The value of `owner` is a dictionary. The value of the dictionary contains the content in the form of `{}`. The key-value inside the dictionary is similar to the `hello = "KCL"` example. `database` is another dictionary in which the value of the dictionary attribute appears boolean `True`, list `[]` and dictionary `{}`, in which the value of the numeric type also appears in the list and dictionary. The `servers` attribute is a list with dictionaries nested inside the list (dictionaries and lists, as well as the `schema` that will be discussed later, can be nested within each other).

The YAML output of this configuration is as follows:

```yaml
$ kcl server.k
title: KCL Example
owner:
  name: The KCL Authors
  data: '2020-01-02T03:04:05'
database:
  enabled: true
  ports:
  - 8000
  - 8001
  - 8002
  data:
  - - delta
    - phi
  - - 3.14
  temp_targets:
    cpu: 79.5
    case: 72.0
servers:
- ip: 10.0.0.1
  role: frontend
- ip: 10.0.0.2
  role: backend
```

## 3. Define the structure of the configuration using KCL schema

The KCL provides abstract support for attributes with a fixed attribute structure and default value behavior through the `schema` syntax.

For example, the configuration of `database` in the above example is generally the default value. We can define a structure for the default configuration of the database:

```python
schema DatabaseConfig:
    enabled: bool = True
    ports: [int] = [8000, 8001, 8002]
    data: [[str|float]] = [["delta", "phi"], [3.14]]
    temp_targets: {str: float} = {cpu = 79.5, case = 72.0}
```

`enabled` is a boolean type; `ports` is an integer list type; `data` is a list of lists, and the inner list elements are strings or floats; `temp_targets` is a dictionary type, and the attribute value of the dictionary is floating point type. And each attribute of `DatabaseConfig` defines a default value.

Then pass `database = DatabaseConfig {}` to generate a structure with the same attributes as the default values. We can also modify the default value:

```python
database = DatabaseConfig {
    ports = [2020, 2021]
}
```

`schema DatabaseConfig` not only provides default values for attributes, but also adds type information to attributes. Therefore, if we accidentally writes the wrong attribute value type, KCL will give a friendly error prompt, such as the following example where `ports` is wrongly written as a floating point type:

```python
database = DatabaseConfig {
    ports = [1.2, 1.3]
}
```

When executed, an error similar to the following will be generated (the displayed file path depends on the local environment):

```shell
kcl server.k
```

The output is

```shell
error[E2G22]: TypeError
 --> /path/to/server.k:8:5
  |
8 |     ports = [1.2, 1.3]
  |     ^ expected [int], got [float(1.2)|float(1.3)]
  |

 --> /path/to/server.k:3:5
  |
3 |     ports: [int] = [8000, 8001, 8002]
  |     ^ variable is defined here, its type is [int], but got [float(1.2)|float(1.3)]
  |
```

Similarly we can encapsulate the attributes of the `servers` section with the following code:

```python
schema ServerConfig:
    ip: str
    role: "frontend" | "backend"

servers = [
    ServerConfig {ip = "10.0.0.1", role = "frontend"}
    ServerConfig {ip = "10.0.0.2", role = "backend"}
]
```

The attribute `ip` of `ServerConfig` is a string type, and no default value is given. We must manually add the value of the `ip` attribute when generating the `ServerConfig` type attribute, otherwise the KCL will report a missing required attribute error. The `role` attribute is a `"frontend" | "backend"` enumerated string type.

In addition, `schema` can also combine `check`, `mixin`, optional attributes, inheritance and extension modules to achieve more complex configuration and policy data abstraction, full language details can be found at [here](/docs/reference/lang/tour).
