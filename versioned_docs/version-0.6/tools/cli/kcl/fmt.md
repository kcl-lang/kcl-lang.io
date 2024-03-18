---
sidebar_position: 2
---

# Format

The KCL Format tool supports reformatting KCL files to the standard code style. This article demonstrates the KCL code style and how to use the KCL Format tool.

## Code Style

The KCL Format tool modifies the files according to the KCL code style: [Style Guide for KCL Code](/docs/reference/lang/spec/codestyle)

## How to use

- Formatting Single File

```text
kcl-fmt your_config.k
```

- Formatting multiple files

```text
kcl-fmt your_config_path -R
```

- Args
  - `-R|--recursive` Whether to recursively traverse subfolder
  - `-w|--fmt-output` Whether to output to STDOUT, without `-w` indicates in-place modification.

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
