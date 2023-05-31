---
title: "Helm KCL Plugin"
sidebar_position: 4
---

## Introduction

[Helm](https://github.com/helm/helm) is a tool for managing Charts. Charts are packages of pre-configured Kubernetes resources. You can use the `Helm-KCL-Plugin` to

+ Edit the helm charts in a hook way to separate data and logic for the Kubernetes manifests management.
+ For multi-environment and multi-tenant scenarios, you can maintain these configurations gracefully rather than simply copy and paste.
+ Validate all KRM resources using the KCL schema.

## Prerequisites

+ Install [Helm](https://github.com/helm/helm)
+ Install [Helm KCL Plugin](https://github.com/KusionStack/helm-kcl)

## Quick Start

Let’s write a KCL function which add annotation `managed-by=helm-kcl-plugin` only to `Deployment` resources in the helm chart.

### 1. Get the Example

```bash
git clone https://github.com/KusionStack/helm-kcl.git/
cd ./helm-kcl/examples/workload-charts-with-kcl
```

### 2. Test and Run

Run the KCL code via the `Helm KCL Plugin`.

```bash
helm kcl template --file ./kcl-run.yaml
```

The output yaml is

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/instance: workload
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: workload
    app.kubernetes.io/version: 0.1.0
    helm.sh/chart: workload-0.1.0
  name: workload
spec:
  ports:
  - name: www
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app.kubernetes.io/instance: workload
    app.kubernetes.io/name: workload
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/instance: workload
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: workload
    app.kubernetes.io/version: 0.1.0
    helm.sh/chart: workload-0.1.0
  name: workload
  annotations:
    managed-by: helm-kcl-plugin
spec:
  selector:
    matchLabels:
      app.kubernetes.io/instance: workload
      app.kubernetes.io/name: workload
  template:
    metadata:
      labels:
        app.kubernetes.io/instance: workload
        app.kubernetes.io/name: workload
    spec:
      containers:
      - image: nginx:alpine
        name: frontend
```

## Guides for Developing KCL

Here's what you can do in the KCL code:

+ Read resources from `option("resource_list")`. The `option("resource_list")` complies with the [KRM Functions Specification](https://kpt.dev/book/05-developing-functions/01-functions-specification). You can read the input resources from `option("resource_list")["items"]` and the `functionConfig` from `option("resource_list")["functionConfig"]`.
+ Return a KPM list for output resources.
+ Return an error using `assert {condition}, {error_message}`.

## More Documents and Examples

+ [Helm KCL Plugin](https://github.com/KusionStack/helm-kcl)
