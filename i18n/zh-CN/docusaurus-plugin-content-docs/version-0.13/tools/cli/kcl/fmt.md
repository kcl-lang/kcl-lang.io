---
sidebar_position: 3
---

# 代码格式化工具

KCL 支持通过内置的命令行工具一键格式化多个 KCL 文件文档。本文展示 KCL 编码风格和 KCL 格式化工具的使用方式。

## KCL 编码风格

KCL 格式化对文件的修改样式具体见 KCL 编码风格：[Style Guide for KCL Code](/docs/reference/lang/spec/codestyle)

格式化工具在存在 `.editorconfig` 文件时会遵循其中的缩进设置（如 `indent_style`、`indent_size`）。

## 使用方式

- 单文件格式化

```shell
kcl fmt your_config.k
```

- 文件夹内多文件格式化

```shell
kcl fmt your_config_path -R
```

- 只报告需要格式化的文件，不修改文件内容

```shell
kcl fmt --dry-run .
```

- 命令行参数
  - `-R|--recursive` 设置是否递归遍历子文件夹
  - `-w|--fmt-output` 设置是否输出到标准输出流，不加 `-w` 表示原地格式化 KCL 文件
  - `--dry-run` 只报告需要格式化的文件，不修改文件内容

## 格式化文件效果展示

- 格式化前

```py
import     math
mixin DeploymentMixin:
    service:str ="my-service"
schema DeploymentBase:
    name: str
    image  : str
schema Deployment[replicas] ( DeploymentBase )   :
    mixin[DeploymentMixin]
    replicas   : int   = replicas
    command: [str  ]
    labels: {str:  str}
deploy = Deployment(replicas = 3){}
```

- 格式化后

```py
import math

mixin DeploymentMixin:
    service: str = "my-service"

schema DeploymentBase:
    name: str
    image: str

schema Deployment[replicas](DeploymentBase):
    mixin [DeploymentMixin]
    replicas: int = replicas
    command: [str]
    labels: {str:str}

deploy = Deployment(replicas=3) {}

```

## 参数说明

```shell
This command formats all kcl files of the current crate.

Usage:
  kcl fmt [flags]

Examples:
  # Format the single file
  kcl fmt /path/to/file.k

  # Format all files in this folder recursively
  kcl fmt ./...

Flags:
      --dry-run   Report files requiring formatting without modifying them.
  -h, --help      help for fmt
```
