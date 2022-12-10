---
sidebar_position: 1
---

# Quick Start

## 1. Install KCLOpenAPI tool

```shell
# 1. Download binary
# https://github.com/KusionStack/kcl-openapi/releases

# 2. Add PATH
export PATH="<Your directory to store KCL OpenAPI binary>:$PATH"
```

- Verify the installation results through execute `kcl-openapi - h`

```shell
Usage:
  kcl-openapi [OPTIONS] <generate | validate>

Swagger tries to support you as best as possible when building APIs.

It aims to represent the contract of your API with a language agnostic description of your application in json or yaml.


Application Options:
  -q, --quiet                  silence logs
      --log-output=LOG-FILE    redirect logs to file

Help Options:
  -h, --help                   Show this help message

Available commands:
  generate  generate kcl code
  validate  validate the swagger document
```

## 2. Generate KCL Files

- [OpenAPI to KCL](../openapi/openapi-to-kcl.md)
- [CRD to KCL](../openapi/crd-to-kcl.md)
