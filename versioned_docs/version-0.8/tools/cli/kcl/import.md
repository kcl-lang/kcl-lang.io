---
sidebar_position: 4
---

# Import

## Introduction

KCL supports the built-in `kcl import` tool to import data or structure definitions from other formats into KCL. Currently, KCL supports importing JSON, YAML, Go Structure, JsonSchema, Terraform Provider Schema, OpenAPI, and Kubernetes CRD as KCL configurations or schema definitions.

## Args

```shell
This command converts other formats to KCL file.

Supported conversion modes:
- json:            convert JSON data to KCL data
- yaml:            convert YAML data to KCL data
- gostruct:        convert Go struct to KCL schema
- jsonschema:      convert JSON schema to KCL schema
- terraformschema: convert Terraform schema to KCL schema
- openapi:         convert OpenAPI spec to KCL schema
- crd:             convert Kubernetes CRD to KCL schema
- auto:            automatically detect the input format

Usage:
  kcl import [flags]

Examples:
  # Generate KCL models from OpenAPI spec
  kcl import -m openapi swagger.json

  # Generate KCL models from Kubernetes CRD
  kcl import -m crd crd.yaml

  # Generate KCL models from JSON
  kcl import data.json

  # Generate KCL models from YAML
  kcl import data.yaml

  # Generate KCL models from JSON Schema
  kcl import -m jsonschema schema.json

  # Generate KCL models from Terraform provider schema
  kcl import -m terraformschema schema.json

  # Generate KCL models from Go structs
  kcl import -m gostruct schema.go


Flags:
  -f, --force             Force overwrite output file
  -h, --help              help for import
  -m, --mode string       Specify the import mode. Default is mode (default "auto")
  -o, --output string     Specify the output file path
  -p, --package string    The package to save the models. Default is models (default "models")
  -s, --skip-validation   Skips validation of spec prior to generation
```
