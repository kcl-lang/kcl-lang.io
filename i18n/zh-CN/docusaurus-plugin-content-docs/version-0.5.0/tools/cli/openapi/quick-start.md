---
sidebar_position: 1
---

# 快速开始

## 1. 安装 KCLOpenAPI 工具

目前有多种安装方式可选：

- [通过 go install 安装](#11-通过-go-install-安装)
- [通过 curl|sh 安装（仅限 MacOS & Linux）](#12-通过-curlsh-安装（仅限-MacOS-Linux）)
- [下载发布包](#13-下载发布包)

## 1.1 通过 go install 安装

```shell
go install kcl-lang.io/kcl-openapi@latest
```

## 1.2 通过 curl|sh 安装（仅限 MacOS & Linux）

```shell
curl https://kcl-lang.io/scripts/install-kcl-openapi.sh | sh
```

## 1.3 下载发布包

```shell
# 1. 下载二进制程序
# https://github.com/kcl-lang/kcl-openapi/releases

# 2. 解压发布包，并将命令添加至 PATH
export PATH="<Your directory to store KCLOpenapi binary>:$PATH"
```

## 1.4 验证安装结果

安装完成后，您可执行 `kcl-openapi generate model -h`，如果看到如下信息则说明安装成功：

```shell
kcl-openapi command helps you to generate KCL schema structure from K8s CRD YAML/JSON file.
  1. Translate Swagger Openapi Spec to KCL code
  2. Translate Kubernetes CRD to KCL code

Examples:

  # convert a K8s CRD file into KCL files
  kcl-openapi generate model -f FILENAME --crd --skip-validation

Options:
      --crd=false: Set the spec file is a kube crd
  -f, --filename='': The filename to convert
      --skip-validation=false: Skips validation of spec prior to generation
  -t, --target='': The location to write output kcl files
      --version=false: Show the KCLOpenAPI version

Usage:
  kcl-openapi generate model -f FILENAME [options]
```

## 2. 生成 KCL 文件

- [将 OpenAPI 描述文件转换为 KCL](../openapi/openapi-to-kcl.md)
- [将 Kubernetes CRD 转换为 KCL](../openapi/crd-to-kcl.md)
