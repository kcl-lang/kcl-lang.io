---
title: "KCL Operator"
sidebar_position: 6
---

## Introduction

[KCL Operator](https://github.com/kcl-lang/kcl-operator) provides cluster integration, allowing you to use Access Webhook to generate, mutate, or validate resources based on KCL configuration when apply resources to the cluster. Webhook will capture creation, application, and editing operations, and execute `KCLRun` resource on the configuration associated with each operation, and the KCL programming language can be used to

- **Add** labels or annotations based on a condition.
- **Inject** a sidecar container in all KRM resources that contain a PodTemplate.
- **Validate** all KRM resources using KCL schema.
- Use an abstract model to **generate** KRM resources.

## Prerequisites

- Install Kubectl
- Prepare a Kubernetes cluster

## Quick Start

Let’s write a KCL function which add annotation `managed-by=kcl-operator` only to Pod resources at runtime.

### 1. Install KCL Operator

```bash
kubectl apply -f https://raw.githubusercontent.com/kcl-lang/kcl-operator/main/config/all.yaml
```

Use the following command to watch and wait the pod status is Running.

```shell
kubectl get po
```

### 2. Deploy the KCL source

```bash
kubectl apply -f- << EOF
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
spec:
  source: |
    items = [item | {
        metadata.annotations: {
            "managed-by" = "kcl-operator"
        }
    } for item in option("items")]
EOF
```

### 3. Validate the result

Validate the mutation result by creating a nginx Pod YAML.

```shell
kubectl apply -f- << EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  annotations:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
EOF
kubectl get po nginx -o yaml | grep kcl-operator
```

The output is

```shell
    managed-by: kcl-operator
```

## Guides for Developing KCL

Here's what you can do in the KCL code:

- Read resources from `option("items")`. The `option("items")` complies with the [KRM Functions Specification](https://kpt.dev/book/05-developing-functions/01-functions-specification).
- Return a KRM list for output resources.
- Return an error using `assert {condition}, {error_message}`.
- Read the PATH variables. e.g. `option("PATH")`.
- Read the environment variables. e.g. `option("env")`.

## More Documents and Examples

- [KRM KCL Spec](https://github.com/kcl-lang/krm-kcl)
