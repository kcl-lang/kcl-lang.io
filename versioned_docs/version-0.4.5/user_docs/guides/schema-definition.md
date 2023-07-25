---
title: "Schema Definition"
sidebar_position: 3
---

The core scenario of KCL is write configurations and constraints. and a core feature of KCL is **modeling**. The keyword `schema` in KCL can be used to define structures and constraints, such as attribute types, default values, range check, and various other constraints. In addition, structures defined with KCL schema can be used in turn to verify implementation, validate input (JSON, YAML and other structured data) or generate code (multilingual structures, OpenAPI, and so on).

## Define Structures and Constraints

For example, we have the KCL file (main.k) defined below. In it, we use the `schema` keyword to define three models `App`, `Service` and `Volume`. The `App` model has four attributes `domainType`, `containerPort`, `volumes` and `services`, where

+ The type of `domainType` is a string literal union type, similar to an "enumeration", which means that the value of `domainType` can only take one of `"Standard"`, `"Customized"` and `"Global"`.
+ The type of `containerPort` is an integer (`int`). In addition, we use the `check` keyword to define its value range from 1 to 65535.
+ The type of `services` is `Service` schema list type, and we use `?` to mark it as an optional attribute.
+ The type of `volumes` is a `Volume` schema list type, and we use `?` to mark it as an optional attribute.

```python
schema App:
    domainType: "Standard" | "Customized" | "Global"
    containerPort: int
    services?: [Service]  # `?` specifies a optional attribute
    volumes?: [Volume]  # `?` specifies a optional attribute

    check:
        1 <= containerPort <= 65535  # `containerPort` must be in range [1, 65535]

schema Service:
    clusterIP: str
    $type: str

    check:
        clusterIP == "None" if $type == "ClusterIP" # When `type` is "ClusterIP", `clusterIP` must be `"None"`

schema Volume:
    container: str = "*"  # The default value of `container` is "*"
    mountPath: str

    check:
        mountPath not in ["/", "/boot", "/home", "dev", "/etc", "/root"]  # `mountPath` must not be one of the list `["/", "/boot", "/home", "dev", "/etc", "/root"]`

app: App {
    domainType = "Standard"
    containerPort = 80
    volumes = [
        {
            mountPath = "/tmp"
        }
    ]
    services = [
        {
            clusterIP = "None"
            $type = "ClusterIP"
        }
    ]
}
```

We can get the YAML output of the `app` instance by using the following command line

```shell
$ kcl main.k
app:
  domainType: Standard
  containerPort: 80
  volumes:
  - container: '*'
    mountPath: /tmp
  services:
  - clusterIP: None
    type: ClusterIP
```

In addition, we can put the `app` model into a separate `app_module.k`, then we can use the `import` keyword in `main.k` for modular management, such as the following file structure

```
.
├── app_module.k
└── main.k
```

The content of `app_module.k` is

```python
schema App:
    domainType: "Standard" | "Customized" | "Global"
    containerPort: int
    volumes: [Volume]
    services: [Service]

    check:
        1 <= containerPort <= 65535

schema Service:
    clusterIP: str
    $type: str

    check:
        clusterIP == "None" if $type == "ClusterIP"

schema Volume:
    container: str = "*"  # The default value of `container` is "*"
    mountPath: str

    check:
        mountPath not in ["/", "/boot", "/home", "dev", "/etc", "/root"]
```

The content of `main.k` is

```python
import .app_module  # A relative path import

app: app_module.App {
    domainType = "Standard"
    containerPort = 80
    volumes = [
        {
            mountPath = "/tmp"
        }
    ]
    services = [
        {
            clusterIP = "None"
            $type = "ClusterIP"
        }
    ]
}
```

We can still get the YAML output of the `app` instance by using the following command line

```shell
$ kcl main.k
app:
  domainType: Standard
  containerPort: 80
  volumes:
  - container: '*'
    mountPath: /tmp
  services:
  - clusterIP: None
    type: ClusterIP
```
