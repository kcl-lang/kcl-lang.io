---
sidebar_position: 1
---

# Quick Start

## 1. Install KCLOpenAPI Tool

The kcl-openapi tool can be installed in following ways:

- [Quick Start](#quick-start)
  - [1. Install KCLOpenAPI Tool](#1-install-kclopenapi-tool)
  - [1.1 go install](#11-go-install)
  - [1.2 Curl|sh install (MacOS \& Linux)](#12-curlsh-install-macos--linux)
  - [1.3 Download from release](#13-download-from-release)
  - [1.4 Verify your installation](#14-verify-your-installation)
  - [2. Generate KCL Files](#2-generate-kcl-files)

## 1.1 go install

```shell
go install kcl-lang.io/kcl-openapi@latest
```

## 1.2 Curl|sh install (MacOS & Linux)

If you don't have go, you can install the CLI with this one-liner:

```shell
curl -fsSL https://kcl-lang.io/script/install-kcl-openapi.sh | /bin/bash
```

## 1.3 Download from release

```shell
# 1. download the released binary from:
# https://github.com/kcl-lang/kcl-openapi/releases

# 2. Unzip the package and add the binary location to PATH
export PATH="<Your directory to store KCLOpenapi binary>:$PATH"
```

## 1.4 Verify your installation

```shell
➜  kcl-openapi -v
kcl-openapi 0.5.0
```

## 2. Generate KCL Files

- [OpenAPI to KCL](../openapi/openapi-to-kcl.md)
- [CRD to KCL](../openapi/crd-to-kcl.md)
