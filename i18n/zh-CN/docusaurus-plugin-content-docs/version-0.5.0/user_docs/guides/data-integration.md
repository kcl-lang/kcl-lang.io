---
title: "数据集成"
sidebar_position: 4
---

## 简介

在 KCL 中，不仅可以将 KCL 编写的配置代码编译输出为 YAML 格式的数据，还可以将 JSON/YAML 等数据直接嵌入到 KCL 语言当中。

## 使用 KCL 进行数据集成

### 1. 获得示例

```bash
git clone https://github.com/KusionStack/kcl-lang.io.git/
cd ./kcl-lang.io/examples/data-integration
```

### 2. YAML 集成

我们可以运行以下命令来显示 KCL YAML 集成配置。

```bash
cat yaml.k
```

```python
import yaml

schema Server:
    ports: [int]

server: Server = yaml.decode("""\
ports:
- 80
- 8080
""")
server_yaml = yaml.encode({
    ports = [80, 8080]
})
```

在上述代码中，我们通过 KCL 内置的 `yaml` 模块以及其中的 `yaml.decode` 直接完成 YAML 数据的集成，并且使用 `Server` schema 对集成的 YAML 数据直接进行校验。此外，我们可以使用 `yaml.encode` 完成 YAML 数据的序列化。

我们通过如下命令可以获得配置输出:

```bash
$ kcl yaml.k
server:
  ports:
    - 80
    - 8080
server_yaml: "ports:\n  - 80\n  - 8080\n"
```

### 3. JSON 集成

同样的，对于 JSON 数据，我们可以使用 `json.encode` 和 `json.decode` 函数以同样的方式进行数据集成。

我们可以运行以下命令来显示 KCL JSON 集成配置。

```bash
cat json.k
```

```python
import json

schema Server:
    ports: [int]

server: Server = json.decode('{"ports": [80, 8080]}')
server_json = json.encode({
    ports = [80, 8080]
})
```

执行命令输出为:

```bash
$ kcl json.k
server:
  ports:
    - 80
    - 8080
server_json: "{\"ports\": [80, 8080]}"
```

## 小结

本文介绍了如何在 KCL 中进行数据集成，使用 KCL 内置的 yaml 和 json 包将 YAML 和 JSON 数据直接集成到 KCL 语言中，并使用相应的解码和编码功能对其进行验证和序列化。
