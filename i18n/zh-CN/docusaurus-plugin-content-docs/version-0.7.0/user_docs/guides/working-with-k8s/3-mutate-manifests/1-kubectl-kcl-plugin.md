---
title: "Kubectl KCL 插件"
sidebar_position: 1
---

## 简介

[Kubectl](https://kubernetes.io/docs/reference/kubectl/) is a command line tool for communicating with a Kubernetes cluster's control plane, using the Kubernetes API. You can use the `Kubectl-KCL-Plugin` to

- Edit the YAML configuration in a hook way to separate data and logic for the Kubernetes manifests management.
- For multi-environment and multi-tenant scenarios, you can maintain these configurations gracefully rather than simply copy and paste.
- Validate all KRM resources using the KCL schema.

## 前置条件

- Install [Kubectl](https://github.com/kubernetes/kubectl)
- Install [Kubectl KCL Plugin](https://github.com/kcl-lang/kubectl-kcl)

## 快速开始

Let’s write a KCL function which add annotation `managed-by=krm-kcl` only to `Deployment` resources in the Kubernetes manifests.

### Mutation

#### 1. Get the Example

```bash
git clone https://github.com/kcl-lang/kubectl-kcl.git/
cd ./kubectl-kcl/examples/
```

Show the config

```shell
cat ./kcl-run-oci.yaml
```

The output is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
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
---
apiVersion: v1
kind: Service
metadata:
  name: test
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
---
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
spec:
  params:
    annotations:
      managed-by: kubectl-kcl
  source: oci://ghcr.io/kcl-lang/set-annotation
```

#### 2. Test and Run

Run the KCL code via the `Kubectl KCL Plugin`.

```bash
kubectl kcl run -f ./kcl-run-oci.yaml
```

The output yaml is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    managed-by: kubectl-kcl
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
        - image: nginx:1.14.2
          name: nginx
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  annotations:
    managed-by: kubectl-kcl
  name: test
spec:
  ports:
    - port: 80
      protocol: TCP
      targetPort: 9376
  selector:
    app: MyApp
```

### Validation

Let’s do a `https-only` validation for the `Ingress` resources in the Kubernetes manifests.

#### 1. Get the Example

Show the config

```shell
cat ./kcl-vet-oci-err.yaml
```

The output is

```yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: https-only
spec:
  source: oci://ghcr.io/kcl-lang/https-only
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-example-ingress
spec:
  tls:
    - hosts:
        - https-example.foo.com
      secretName: testsecret-tls
  rules:
    - host: https-example.foo.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: service1
                port:
                  number: 80
```

#### 2. Test and Run

Run the KCL code via the `Kubectl KCL Plugin`.

```bash
kubectl kcl run -f ./kcl-run-oci-err.yaml
```

The expected error message is

```shell
Ingress should be https. The `kubernetes.io/ingress.allow-http: "false"` annotation is required for Ingress: tls-example-ingress
```

## Guides for Developing KCL

Here's what you can do in the KCL code:

- Read resources from `option("resource_list")`. The `option("resource_list")` complies with the [KRM Functions Specification](https://kpt.dev/book/05-developing-functions/01-functions-specification). You can read the input resources from `option("resource_list")["items"]` and the `functionConfig` from `option("resource_list")["functionConfig"]`.
- Return a KRM list for output resources.
- Return an error using `assert {condition}, {error_message}`.

## More Resources

- [Kubectl KCL Plugin](https://github.com/kcl-lang/kubectl-kcl)
- [Artifact Hub KCL Modules](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1)
