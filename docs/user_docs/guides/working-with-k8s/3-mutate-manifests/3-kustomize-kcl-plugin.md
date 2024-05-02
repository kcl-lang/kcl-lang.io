---
title: "Kustomize KCL Plugin"
sidebar_position: 3
---

## Introduction

[Kustomize](https://github.com/kubernetes-sigs/kustomize) lets you customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as is.

KCL can be used to create functions to mutate and/or validate the YAML Kubernetes Resource Model (KRM) input/output format, and we provide Kustomize KCL functions to simplify the function authoring process.

## Prerequisites

- Install [kustomize](https://github.com/kubernetes-sigs/kustomize)
- Install [Docker](https://www.docker.com/)

## Quick Start

Let’s write a KCL function which add annotation `managed-by=kustomize-kcl` only to Deployment resources.

### 1. Get the Example

```bash
git clone https://github.com/kcl-lang/kustomize-kcl.git
cd ./kustomize-kcl/examples/set-annotation/
```

### 2. Test and Run

```bash
kustomize fn run ./local-resource/ --dry-run
```

The output YAML is

```yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
  annotations:
    config.kubernetes.io/function: |
      container:
        image: docker.io/kcllang/kustomize-kcl:v0.2.0
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
# EDIT THE SOURCE!
# This should be your KCL code which preloads the `ResourceList` to `option("resource_list")
spec:
  source: |
    [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kustomize-kcl"}} for resource in option("resource_list").items]
---
apiVersion: v1
kind: Service
metadata:
  name: test
  annotations:
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
  annotations:
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
    managed-by: kustomize-kcl
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

## Guides for Developing KCL

Here's what you can do in the KCL code:

- Read resources from `option("items")`. The `option("items")` complies with the [KRM Functions Specification](https://kpt.dev/book/05-developing-functions/01-functions-specification).
- Return a KRM list for output resources.
- Return an error using `assert {condition}, {error_message}`.
- Read the PATH variables. e.g. `option("PATH")`.
- Read the environment variables. e.g. `option("env")`.

## More Documents and Examples

- [Kustomize KCL Plugin](https://github.com/kcl-lang/kustomize-kcl)
