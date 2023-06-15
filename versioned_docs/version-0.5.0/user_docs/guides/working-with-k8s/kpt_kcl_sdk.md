---
title: "KPT KCL SDK"
sidebar_position: 5
---

## Introduction

[kpt](https://github.com/GoogleContainerTools/kpt) is a package-centric toolchain that enables a configuration authoring, automation, and delivery experience, which simplifies managing Kubernetes platforms and KRM-driven infrastructure (e.g., Config Connector, Crossplane) at scale by manipulating declarative Configuration as Data for automating Kubernetes configuration editing including transforming and validating.

KCL can be used to create functions to transform and/or validate the YAML Kubernetes Resource Model (KRM) input/output format, but we provide KPT KCL SDKs to simplify the function authoring process.

## Prerequisites

+ Install [kpt](https://github.com/GoogleContainerTools/kpt)
+ Install [Docker](https://www.docker.com/)

## Quick Start

Let’s write a KCL function which add annotation `managed-by=kpt` only to Deployment resources.

### 1. Get the Example

```bash
git clone https://github.com/KusionStack/kpt-kcl-sdk.git/
cd ./kpt-kcl-sdk/get-started/set-annotation
```

### 2. Show the KRM

```bash
kpt pkg tree
```

The output is

```bash
set-annotation
├── [kcl-fn-config.yaml]  KCLRun set-annotation
└── data
    ├── [resources.yaml]  Deployment nginx-deployment
    └── [resources.yaml]  Service test
```

### 3. Show and Update the KCL `FunctionConfig`

```bash
cat ./kcl-fn-config.yaml
```

The output is

```yaml
# kcl-fn-config.yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata: # kpt-merge: /set-annotation
  name: set-annotation
spec:
  # EDIT THE SOURCE!
  # This should be your KCL code which preloads the `ResourceList` to `option("resource_list")`
  source: |
    [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kpt"}} for resource in option("resource_list").items]
```

### 4. Test and Run

Run the KCL code via kpt

```bash
# Note: you need add sudo and --as-current-user flags to ensure KCL has permission to write temp files in the container filesystem.
sudo kpt fn eval ./data -i docker.io/peefyxpf/kpt-kcl:v0.1.1 --as-current-user --fn-config kcl-fn-config.yaml

# Verify that the annotation is added to the `Deployment` resource and the other resource `Service` 
# does not have this annotation.
cat ./data/resources.yaml | grep annotations -A1 -B0
```

The output is

```bash
  annotations:
    managed-by: kpt
```

It can be seen that we have indeed added the annotation `managed-by=kpt`.

## Guides for Developing KCL

Here's what you can do in the KCL code:

+ Read resources from `option("resource_list")`. The `option("resource_list")` complies with the [KRM Functions Specification](https://kpt.dev/book/05-developing-functions/01-functions-specification). You can read the input resources from `option("resource_list")["items"]` and the `functionConfig` from `option("resource_list")["functionConfig"]`.
+ Return a KPM list for output resources.
+ Return an error using `assert {condition}, {error_message}`.

## More Documents and Examples

+ [KPT KCL SDK](https://github.com/KusionStack/kpt-kcl-sdk)
