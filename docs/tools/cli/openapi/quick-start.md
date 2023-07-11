---
sidebar_position: 1
---

# Quick Start

## 1. Install KCLOpenAPI Tool

The kcl-openapi tool can be installed in following ways:

- [go install](#11-go-install)
- [curl|sh install (MacOS & Linux)](#12-curlsh-install-macos--linux)
- [download from release](#13-dowload-from-release)

## 1.1 go install

```shell
go install kcl-lang.io/kcl-openapi@latest
```

## 1.2 Curl|sh install (MacOS & Linux)

If you don't have go, you can install the CLI with this one-liner:

```shell
curl https://kcl-lang.io/scripts/install-kcl-openapi.sh | sh
```

## 1.3 Dowload from release

```shell
# 1. download the released binary from:
# https://github.com/kcl-lang/kcl-openapi/releases

# 2. Unzip the package and add the binary location to PATH
export PATH="<Your directory to store KCLOpenapi binary>:$PATH"
```

## 1.4 Verify your installation

- To verify the installation, you can run the command: `kcl-openapi generate model -h` and the following information indicates your successful installation:

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

## 2. Generate KCL Files

- [OpenAPI to KCL](../openapi/openapi-to-kcl.md)
- [CRD to KCL](../openapi/crd-to-kcl.md)
