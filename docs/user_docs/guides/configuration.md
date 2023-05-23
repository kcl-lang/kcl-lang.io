---
title: "Configuration"
sidebar_position: 1
---

## Introduction

Configuration is a vital aspect of software systems that are constantly in flux due to evolving business requirements, infrastructure demands, and other factors. Often, changing these systems' behavior quickly can be challenging, especially when doing so requires a costly and time-consuming reconstruction and redeployment process. In such cases, making changes to the business code may not be sufficient. Fortunately, configuration provides a low-overhead way to modify system functions. For instance, many developers write JSON or YAML files to configure their systems.

We can store the static configuration in JSON and YAML files as needed. Moreover, configuration can also be stored in a high-level language that allows for more flexible configuration. This language can be coded, rendered, and statically configured. KCL is a configuration language that offers such functionality. Developers can write KCL code to generate JSON/YAML and other configurations.

## Use KCL for Configuration

KCL's core features are its modeling and constraint capabilities, and its basic functions revolve around these two key elements. Additionally, KCL follows a user-centric configuration concept when designing its basic functions. Configuration code has requirements for configuration data constraints, such as type constraints and required/optional constraints on configuration attributes, range constraints, and immutability constraints. These are also some of the core issues that KCL is committed to resolving.

Now that we have an understanding of KCL's capabilities, let's explore how to use it to generate configurations.

### 1. Get the Example

Firstly, let's get the example.

```shell
git clone https://github.com/KusionStack/kcl-lang.io.git/
cd ./kcl-lang.io/examples/configuration
```

We can run the following command to show the config.

```bash
cat nginx.k
```

The output is

```python
schema Nginx:
    """Schema for Nginx configuration files"""
    http: Http

schema Http:
    server: Server

schema Server:
    listen: int | str    # The attribute `listen` can be int type or a string type.
    location?: Location  # Optional, but must be non-empty when specified

schema Location:
    root: str
    index: str

nginx = Nginx {
    http.server = {
        listen = 80
        location = {
            root = "/var/www/html"
            index = "index.html"
        }
    }
}
```

### 2. Generate YAML using KCL

Run the following command

```bash
kcl nginx.k
```

We can get the output YAML

```yaml
nginx:
  http:
    server:
      listen: 80
      location:
        root: /var/www/html
        index: index.html
```

### 3. Configuration with Dynamic Parameters

Besides, we can dynamically receive external parameters through the KCL builtin function `option`. For example, for the following KCL file (db.k), we can use the KCL command line `-D` flag to receive an external dynamic parameter.

```python
env: str = option("env") or "dev"  # The attribute `env` has a default value "den"
database: str = option("database")
hosts = {
    dev = "postgres.dev"
    stage = "postgres.stage"
    prod = "postgres.prod"
}
dbConfig = {
    host = hosts[env]
    database = database
    port = "2023"
    conn = "postgres://${host}:${port}/${database}"
}
```

```bash
# Use the `-D` flag to input external parameters.
$ kcl db.k -D database="foo"
env: dev
database: foo
hosts:
  dev: postgres.dev
  stage: postgres.stage
  prod: postgres.prod
dbConfig:
  host: postgres.dev
  database: foo
  port: "2023"
  conn: "postgres://postgres.dev:2023/foo"
```

## Summary

By using KCL, we can generate low-level data configurations. For different situations, we set dynamic parameters through the `-D` flag to meet the scene requirements. For more KCL features, please refer to [here](/docs/reference/lang/tour).
