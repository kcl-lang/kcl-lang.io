---
title: "Helm KCL 插件"
sidebar_position: 2
---

## 简介

[Helm](https://github.com/helm/helm) 是一个管理 Charts 的工具。Charts 是预配置的 Kubernetes 资源的包。您可以使用 `Helm-KCL-Plugin` 来完成以下操作：

- 以 hook 的方式编辑 Helm charts，将数据和逻辑分离以便更好地管理 Kubernetes manifests
- 对于多环境和多租户方案，可以优雅地维护这些配置，而不仅仅是简单地复制和粘贴
- 使用 KCL 模式验证所有 KRM 资源

## 先决条件

- 安装 [Helm](https://github.com/helm/helm)
- 安装 [Helm KCL 插件](https://github.com/kcl-lang/helm-kcl)

## 快速开始

让我们编写一个仅向 `Deployment` 资源添加 annotation `managed-by=helm-kcl-plugin` 的 KCL 函数

### 1. 获取示例

```bash
git clone https://github.com/kcl-lang/helm-kcl.git/
cd ./helm-kcl/examples/workload-charts-with-kcl
```

### 2. 测试和运行

通过 `Helm KCL Plugin` 运行KCL代码。

```bash
helm kcl template --file ./kcl-run.yaml
```

输出的YAML为

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

## KCL 开发指南

以下是您可以在 KCL 代码中执行的操作：

- 从 `option("resource_list")` 读取资源。`option("resource_list")` 符合 [KRM 函数规范](https://kpt.dev/book/05-developing-functions/01-functions-specification)。 你可以从 `option("resource_list")["items"]` 读取输入资源，并从 `option("resource_list")["functionConfig"]` 读取 `functionConfig`。
- 返回输出资源的 KPM 列表。
- 使用 `assert {condition}，{error_message}` 返回错误消息。

## 更多文档和示例

- [Helm KCL 插件](https://github.com/kcl-lang/helm-kcl)
