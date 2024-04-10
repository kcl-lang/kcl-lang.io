---
title: "Automation"
sidebar_position: 6
---

## Introduction

KCL provides many automation related capabilities, mainly including tools and multilingual APIs. Via `package_identifier : key_identifier` mode, KCL supports the indexing of any configured key value, thus completing the addition, deletion, modification and query of any key value. For example, the following figure shows that we can directly execute the following command to modify the image. The code diff before and after modification is also shown in the figure.

![](/img/blog/2022-09-15-declarative-config-overview/14-kcl-image-update.png)

In addition, the automation capability of KCL can be realized and integrated into CI/CD.

![](/img/blog/2022-09-15-declarative-config-overview/15-kcl-automation.png)

## Use KCL for Automation

### 0. Prerequisite

- Install [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install)

### 1. Get the Example

Firstly, let's get the example.

```bash
git clone https://github.com/kcl-lang/kcl-lang.io.git/
cd ./kcl-lang.io/examples/automation
```

We can run the following command to show the config.

```bash
cat main.k
```

The output is

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "app"
    replicas = 1
    labels.key = "value"
}
```

We can run the command to get the config

```bash
kcl main.k
```

The output is

```yaml
app:
  name: app
  replicas: 1
  labels:
    app: app
    key: value
```

### 2. Use KCL CLI for Automation

KCL allows us to directly modify the values in the configuration model through the KCL CLI `-O|--overrides` parameter. The parameter contains three parts e.g., `pkg`, `identifier`, `attribute` and `override_value`.

```bash
kcl main.k -O override_spec
```

- `override_spec` represents a unified representation of the configuration model fields and values that need to be modified

```bash
override_spec: [[pkgpath] ":"] identifier ("=" value | "-")
```

- `pkgpath`: indicates the package path where the identifier needs to be modified, usually in the form of `a.b.c`. For the main package,`pkgpath` is represented as `__ main__`. When omitted or not written, it indicates the main package
- `identifier` indicates the identifier that needs to modify the configuration, usually in the form of `a.b.c`.
- `value` indicates the value of the configuration that needs to be modified, which can be any legal KCL expression, such as number/string literal value, list/dict/schema expression, etc.
- `=` denotes modifying of the value of the identifier.
- `-` denotes deleting of the identifier.

#### Override Configuration

Run the command to update the application name.

```bash
kcl main.k -O app.name='new_app'
```

The output is

```yaml
app:
  name: new_app
  replicas: 1
  labels:
    app: new_app
    key: value
```

We can see the `name` attribute of the `app` config is updated to `new_app`.

Besides, when we use KCL CLI `-d` argument, the KCL file will be modified to the following content at the same time.

```bash
kcl main.k -O app.name='new_app' -d
```

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "new_app"
    replicas = 1
    labels: {key = "value"}
}
```

Note that when `name` of `app` is not in the `App` schema config, it will be added into the config after override.

#### Delete Configuration

Run the command to delete the `key` attribute of `labels`.

```bash
kcl main.k -O app.labels.key-
```

The output is

```yaml
app:
  name: app
  replicas: 1
  labels:
    app: app
```

### 3. Use KCL API for Automation

In addition, we can automatically modify the configuration attributes through the [multilingual API](/docs/reference/xlang-api/overview).

Take the RestAPI as an example. The RestAPI service can be started in the following way:

```bash
kcl server
```

The service can then be requested via the POST protocol:

```bash
curl -X POST http://127.0.0.1:2021/api:protorpc/KclvmService.OverrideFile -H 'content-type: accept/json' -d '{
    "file": "main.k",
    "specs": ["app.name=\"nginx\""]
}'
```

After the service call is completed, main.k will be modified as follows:

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "nginx"
    replicas = 1
    labels: {
        "key" = "value"
    }
}
```

## Summary

The document introduces the automation capabilities of KCL, including tools and multilingual APIs. It supports indexing of any configured key value, allowing for the addition, deletion, modification, and querying of any key value. It can also be integrated into CI/CD. The document provides an example of using KCL to automate configuration management, including using the KCL CLI to override and delete configurations, and using the KCL API to modify configuration attributes. For more information about KCL automation and Override API, please refer to [here](/docs/reference/lang/tour#kcl-cli-variable-override).
