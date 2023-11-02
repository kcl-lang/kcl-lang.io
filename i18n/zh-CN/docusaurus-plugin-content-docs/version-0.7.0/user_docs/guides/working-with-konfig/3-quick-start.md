---
id: guide
sidebar_label: 快速开始
---
# 简介

本篇指南向你展示，如何使用 KCL 语言与其相对应的 CLI 工具，完成一个运行在 Kubernetes 中的 Long-Running 应用的部署，我们将组织配置的单位叫做应用（Application），描述应用部署和运维细节的配置集合叫做应用服务（Server），它本质上是通过 KCL 定义的运维模型。

要将一个运行在 Kubernetes 中的应用完全部署起来，一般需要下发多个 Kubernetes 资源，本次演示的样例涉及以下 Kubernetes 资源：

- 命名空间（Namespace）
- 无状态工作负载（Deployment）
- 服务（Service）

> 不清楚相关概念的，可以前往 Kubernetes 官方网站，查看相关说明：

- [Learn Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Service](https://kubernetes.io/docs/concepts/services-networking/service/)

## 准备工作

在开始之前，我们需要做以下准备工作：

1. 安装 [kcl](https://kcl-lang.io/docs/user_docs/getting-started/install/)

2. 下载开源 Konfig 库，仓库地址: [https://github.com/kcl-lang/konfig.git](https://github.com/kcl-lang/konfig.git)

```shell
git clone https://github.com/kcl-lang/konfig.git && cd konfig
```

## 快速开始

### 1. 配置编译

Konfig 的编程语言是 KCL，不是 Kubernetes 认识的 JSON/YAML，因此还需要编译得到最终输出。

进入到项目的 Stack 目录（`examples/appops/nginx-example/dev`）并执行编译：

```bash
cd examples/appops/nginx-example/dev && kcl run
```

可以获得如下 YAML 输出:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sampleappprod
  namespace: sampleapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: sampleapp
      app.kubernetes.io/env: prod
      app.kubernetes.io/instance: sampleapp-prod
      app.k8s.io/component: sampleappprod
  template:
    metadata:
      labels:
        app.kubernetes.io/name: sampleapp
        app.kubernetes.io/env: prod
        app.kubernetes.io/instance: sampleapp-prod
        app.k8s.io/component: sampleappprod
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
  name: sampleapp
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: sampleapp
spec:
  ports:
  - nodePort: 30201
    port: 80
    targetPort: 80
  selector:
    app.kubernetes.io/name: sampleapp
    app.kubernetes.io/env: prod
    app.kubernetes.io/instance: sampleapp-prod
    app.k8s.io/component: sampleappprod
  type: NodePort
```

完成编译，可以看到 3 个资源：

- 一个 name 为 nginx-exampledev 的 Deployment
- 一个 name 为 nginx-example 的 Namespace
- 一个 name 为 nginx-example 的 Service

### 2. 配置修改

Server 模型中的 image 属性用于声明应用的业务容器镜像，我们可以修改 base/main.k 中的 image 的值进行镜像修改或升级:

```diff
14c14
<     image = "nginx:1.7.8"
---
>     image = "nginx:latest"
```

重新编译配置代码可以获得修改后的 YAML 输出：

```shell
kpm run
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

## 小结

本文主要介绍了如何使用 KCL 语言与其相对应的 Konfig 库，完成一个运行在 Kubernetes 中的 Long-Running 服务应用的部署。
