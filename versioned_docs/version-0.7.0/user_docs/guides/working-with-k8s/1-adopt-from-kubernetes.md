---
title: "Adopt From Kubernetes"
sidebar_position: 1
---

## Introduction

KCL provides many out of the box support for Kubernetes configuration. Through KCL tools, we can integrate Kubernetes Schema and configuration into KCL. This section will introduce how to use KCL to integrate Kubernetes.

## Prerequisite

+ Install [kcl](https://kcl-lang.io/docs/user_docs/getting-started/install/)

## Quick Start


### 1. Migrate From Kubernetes YAML/JSON

+ YAML

```shell
kcl import deployment.yaml
```

+ JSON

```shell
kcl import deployment.json
```

### 2. Migrate From Kubernetes CRD

KCL supports extracting and generating KCL schemas from Kubernetes OpenAPI/CRD. the [KCL OpenAPI Spec](/docs/tools/cli/openapi/spec) defines the mapping between the OpenAPI specification and the KCL language features.

If you developed CRDs, you can generate the KCL version of the CRD schemas and declare CRs based on that.

* Generate KCL Schema from CRD

    ```
    kcl import -m crd -s <your_crd.yaml>
    ```

* Define CR based on CRDs in KCL

    You can initialize the CRD schema to define a CR, or further, you can use the generated schema as a backend model and design a frontend interface for users to initialize. The practice is similar to what `KCL Models` does on Kubernetes built-in models.

### 3. Get the k8s module Directly

The Kubernetes KCL modules among all versions (v1.14-v1.28) are pre-generated, you get it by executing `kcl mod add k8s:<version>` under your project. More modules can be seen [here](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1)

## Summary
This section explains how to use the `kcl import` tool to migrate JSON, YAML, Kubernetes CRDs, and more to KCL. The Quick Start Guide helps with the migration or integration from Kubernetes.
