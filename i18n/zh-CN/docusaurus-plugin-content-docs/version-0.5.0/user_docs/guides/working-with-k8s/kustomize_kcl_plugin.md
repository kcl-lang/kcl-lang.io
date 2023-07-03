---
title: "Kustomize KCL 插件"
sidebar_position: 3
---

## 简介

[Kustomize](https://github.com/kubernetes-sigs/kustomize) 允许自定义用于多种目的原始的、无模板的 YAML 文件，同时保留原始 YAML 不变和可用。

KCL 可用于创建函数，以改变和/或验证 Kubernetes 资源模型（KRM）的 YAML 输入/输出格式，并且我们提供 Kustomize KCL 函数来简化函数编写过程。

## 先决条件

+ 安装 [kustomize](https://github.com/kubernetes-sigs/kustomize)

## 快速开始

让我们编写一个仅向 Deployment 资源添加 annotation `managed-by=kustomize-kcl` 的 KCL 函数

### 1. 获取示例

```bash
git clone https://github.com/kcl-lang/kustomize-kcl.git
cd ./kustomize-kcl/examples/set-annotation/
```

### 2. 测试和运行

```bash
# 注意：您需要添加 sudo 和 --as-current-user 以确保 KCL 有权在容器文件系统中写入临时文件。
sudo kustomize fn run ./local-resource/ --as-current-user --dry-run
```

输出的YAML为

```yaml
# kcl-fn-config.yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  annotations:
    config.kubernetes.io/function: |
      container:
        image: docker.io/peefyxpf/kustomize-kcl:v0.1.0
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
  # 编辑此源代码
  # 您在此的 KCL 代码将 `ResourceList` 预加载到 `option("resource_list")`
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

## KCL 开发指南

以下是可以使用 KCL 执行的操作：

+ 从 `option("resource_list")` 读取资源。`option("resource_list")` 符合 [KRM 函数规范](https://kpt.dev/book/05-developing-functions/01-functions-specification)。 你可以从 `option("resource_list")["items"]` 读取输入资源，并从 `option("resource_list")["functionConfig"]` 读取 `functionConfig`。
+ 返回输出资源的 KPM 列表。
+ 使用 `assert {condition}，{error_message}` 返回错误消息。

## 更多文档和示例

+ [Kustomize KCL 插件](https://github.com/kcl-lang/kustomize-kcl)
