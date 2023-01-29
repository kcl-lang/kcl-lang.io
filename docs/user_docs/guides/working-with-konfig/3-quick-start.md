---
id: guide
sidebar_label: Quick Start
---
# Quick Start

This guide shows you how to use the KCL language and CLIs to complete the deployment of an application running in Kubernetes. We call the abstraction of application operation and maintenance configuration as `Server`, and its instance as `Application`. It is essentially an operation and maintenance model defined by KCL.

In actual production, the application online generally needs to update several k8s resources:

- Namespace
- Deployment
- Service

:::tip

This guide requires you to have a basic understanding of Kubernetes. If you are not familiar with the relevant concepts, please refer to the links below:

- [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
:::

## Prerequisites

Before we start, we need to complete the following steps:

1. Install KCL - See [Download and Install](/docs/user_docs/getting-started/install) for more details.

2. Clone the [Konfig repo](https://github.com/KusionStack/konfig.git)

```shell
git clone https://github.com/KusionStack/konfig.git && cd konfig
```

## Compiling

The programming language of the project is KCL, not JSON/YAML which Kubernetes recognizes, so it needs to be compiled to get the final output.

Enter stack dir `appops/nginx-example/dev` and compile:

```bash
cd appops/nginx-example/dev && kcl -Y kcl.yaml -D __konfig_output_format__=raw
```

The output YAML is:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-exampledev
  namespace: nginx-example
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx-example
      app.kubernetes.io/env: dev
      app.kubernetes.io/instance: nginx-example-dev
      app.kubernetes.io/component: nginx-exampledev
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx-example
        app.kubernetes.io/env: dev
        app.kubernetes.io/instance: nginx-example-dev
        app.kubernetes.io/component: nginx-exampledev
    spec:
      containers:
      - image: nginx:1.7.8
        name: main
        ports:
        - containerPort: 80
          protocol: TCP
        resources:
          limits:
            cpu: 100m
            memory: 100Mi
            ephemeral-storage: 1Gi
          requests:
            cpu: 100m
            memory: 100Mi
            ephemeral-storage: 1Gi
---
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-example
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-example
  namespace: nginx-example
spec:
  ports:
  - nodePort: 30201
    port: 80
    targetPort: 80
  selector:
    app.kubernetes.io/name: nginx-example
    app.kubernetes.io/env: dev
    app.kubernetes.io/instance: nginx-example-dev
    app.kubernetes.io/component: nginx-exampledev
  type: NodePort
```

After compiling, we can see three resources:

- A `Deployment` with the name `nginx-exampledev`
- A `Namespace` with the name `nginx-example`
- A `Service` with the name `nginx-example`

The above completes the configuration and takes effect. Later, we can use the command `kubectl apply` to apply and check the actual status of resources. This guide will not elaborate.

## 配置修改

The `image` attribute in the `Server` model is used to declare the application's container image. We can modify the `image` value in `base/main.k` to modify or upgrade the image:

```diff
14c14
<     image = "nginx:1.7.8"
---
>     image = "nginx:latest"
```

Recompile the configuration code to obtain the modified YAML output:

```shell
kcl -Y kcl.yaml -D __konfig_output_format__=raw
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-exampledev
  namespace: nginx-example
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx-example
      app.kubernetes.io/env: dev
      app.kubernetes.io/instance: nginx-example-dev
      app.kubernetes.io/component: nginx-exampledev
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx-example
        app.kubernetes.io/env: dev
        app.kubernetes.io/instance: nginx-example-dev
        app.kubernetes.io/component: nginx-exampledev
    spec:
      containers:
      - image: nginx:latest
        name: main
        ports:
        - containerPort: 80
          protocol: TCP
        resources:
          limits:
            cpu: 100m
            memory: 100Mi
            ephemeral-storage: 1Gi
          requests:
            cpu: 100m
            memory: 100Mi
            ephemeral-storage: 1Gi
---
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-example
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-example
  namespace: nginx-example
spec:
  ports:
  - nodePort: 30201
    port: 80
    targetPort: 80
  selector:
    app.kubernetes.io/name: nginx-example
    app.kubernetes.io/env: dev
    app.kubernetes.io/instance: nginx-example-dev
    app.kubernetes.io/component: nginx-exampledev
  type: NodePort
```
