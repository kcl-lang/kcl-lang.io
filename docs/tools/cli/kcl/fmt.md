---
sidebar_position: 3
---

# Format

The KCL Format tool supports reformatting KCL files to the standard code style. This article demonstrates the KCL code style and how to use the KCL Format tool.

## Code Style

The KCL Format tool modifies the files according to the KCL code style: [Style Guide for KCL Code](/docs/reference/lang/spec/codestyle)

The formatter honors the `.editorconfig` file for indentation settings such as `indent_style` and `indent_size` when one is present.

## How to use

- Formatting Single File

```shell
kcl fmt your_config.k
```

- Formatting multiple files

```shell
kcl fmt your_config_path
```

- Only report the files that require formatting without modifying them

```shell
kcl fmt --dry-run .
```

## Display of formatting files

- Before formatting

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

- After formatting

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

## Args

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
