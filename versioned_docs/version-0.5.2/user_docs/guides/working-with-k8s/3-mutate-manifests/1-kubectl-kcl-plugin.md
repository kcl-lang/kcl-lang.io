---
title: "Kubectl KCL Plugin"
sidebar_position: 1
---

## Introduction

[Kubectl](https://kubernetes.io/docs/reference/kubectl/) is a command line tool for communicating with a Kubernetes cluster's control plane, using the Kubernetes API. You can use the `Kubectl-KCL-Plugin` to

+ Edit the YAML configuration in a hook way to separate data and logic for the Kubernetes manifests management.
+ For multi-environment and multi-tenant scenarios, you can maintain these configurations gracefully rather than simply copy and paste.
+ Validate all KRM resources using the KCL schema.

## Prerequisites

+ Install [Kubectl](https://github.com/kubernetes/kubectl)
+ Install [Kubectl KCL Plugin](https://github.com/kcl-lang/kubectl-kcl)

## Quick Start

Let’s write a KCL function which add annotation `managed-by=krm-kcl` only to `Deployment` resources in the helm chart.

### 1. Get the Example

```bash
git clone https://github.com/kcl-lang/kubectl-kcl.git/
cd ./kubectl-kcl/examples/
```

### 2. Test and Run

Run the KCL code via the `Kubectl KCL Plugin`.

```bash
kubectl kcl run -f ./kcl-run.yaml
```

The output yaml is

```yaml
apiVersion: config.kubernetes.io/v1
kind: ResourceList
items:
- apiVersion: apps/v1
  kind: Deployment
  metadata:
    annotations:
      managed-by: krm-kcl
    labels:
      app: nginx
    name: nginx-deployment
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
        - image: "nginx:1.14.2"
          name: nginx
          ports:
          - containerPort: 80
- apiVersion: v1
  kind: Service
  metadata:
    name: test
  spec:
    ports:
    - port: 80
      protocol: TCP
      targetPort: 9376
    selector:
      app: MyApp
functionConfig:
  # kcl-fn-config.yaml
  apiVersion: krm.kcl.dev/v1alpha1
  kind: KCLRun
  metadata:
  # EDIT THE SOURCE!
  # This should be your KCL code which preloads the `ResourceList` to `option("resource_list")
  spec:
    source: |
      [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "krm-kcl"}} for resource in option("resource_list").items]
```

## Guides for Developing KCL

Here's what you can do in the KCL code:

+ Read resources from `option("resource_list")`. The `option("resource_list")` complies with the [KRM Functions Specification](https://kpt.dev/book/05-developing-functions/01-functions-specification). You can read the input resources from `option("resource_list")["items"]` and the `functionConfig` from `option("resource_list")["functionConfig"]`.
+ Return a KPM list for output resources.
+ Return an error using `assert {condition}, {error_message}`.

## More Documents and Examples

+ [Kubectl KCL Plugin](https://github.com/kcl-lang/kubectl-kcl)
