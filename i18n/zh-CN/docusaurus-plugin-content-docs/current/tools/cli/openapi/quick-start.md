---
sidebar_position: 1
---

# 快速开始

## 1. 安装 KCLOpenAPI 工具

目前有多种安装方式可选：

- [通过 go install 安装](#11-通过-go-install-安装)
- [通过 curl|sh 安装（仅限 MacOS & Linux）](#12-通过-curlsh-安装（仅限-MacOS--Linux）)
- [下载发布包](#13-下载发布包)

## 1.1 通过 go install 安装

```shell
go install kcl-lang.io/kcl-openapi@latest
```

## 1.2 通过 curl|sh 安装（仅限 MacOS & Linux）

```shell
curl -fsSL https://kcl-lang.io/script/install-kcl-openapi.sh | /bin/bash
```

## 1.3 下载发布包

```shell
# 1. 下载二进制程序
# https://github.com/kcl-lang/kcl-openapi/releases

# 2. 解压发布包，并将命令添加至 PATH
export PATH="<Your directory to store KCLOpenapi binary>:$PATH"
```

## 1.4 验证安装结果


```shell
➜  kcl-openapi -v
kcl-openapi 0.5.0
```


## 2. 生成 KCL 文件

- [将 OpenAPI 描述文件转换为 KCL](../openapi/openapi-to-kcl.md)
- [将 Kubernetes CRD 转换为 KCL](../openapi/crd-to-kcl.md)
