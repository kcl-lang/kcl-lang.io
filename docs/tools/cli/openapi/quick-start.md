---
sidebar_position: 1
---

# Quick Start

## 1. 安装 KCLOpenAPI tool

```shell
# 1. 下载二进制程序
# https://github.com/kcl-lang/kcl-openapi/releases

# 2. 将命令添加至PATH
export PATH="<Your directory to store KCL OpenAPI binary>:$PATH"
```

- 验证安装结果，执行 `kcl-openapi -h`，看到如下信息说明安装成功：

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

# 2. 生成 KCL 文件

- [OpenAPI to KCL](../openapi/openapi-to-kcl.md)
- [CRD to KCL](../openapi/crd-to-kcl.md)
