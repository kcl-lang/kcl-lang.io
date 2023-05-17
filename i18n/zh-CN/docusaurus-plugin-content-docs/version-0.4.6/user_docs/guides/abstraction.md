---
title: "抽象"
sidebar_position: 3
---

## 什么是抽象

抽象是指一个实体的简化表示，通常用于计算。它允许隐藏特定的具体细节，同时向程序员提供最相关的信息。每一个抽象都是为满足特定需求而定制的，并且可以极大地提高给定实体的可用性。在 KCL 的上下文中，抽象可以使代码更容易理解和维护，同时也可以简化用户界面。

需要注意的是，代码抽象并不是为了减少代码大小，而是为了提高可维护性和可扩展性。在抽象代码的过程中，应考虑可重用性、可读性和可扩展性等因素，并根据需要对代码进行不断优化。

良好的抽象可以提供如下价值

1. 提供不同的焦点，关注点分离，以便更好地理解特定的身份、角色和场景。
2. 屏蔽较低级别的细节，以避免潜在的错误。
3. 提升用户友好性和自动化。

KCL 自身可能不会评估用户定的模型抽象的合理性，但它提供了技术解决方案来帮助用户构建抽象。

## 使用 KCL 进行抽象

现在，让我们将 Docker Compose 和 Kubernetes 资源抽象为应用程序配置

以应用程序为中心的开发使开发人员能够专注于其工作负载的体系结构，而不是目标环境、基础设施或平台中的技术栈。我们用 `App` 结构定义了应用程序模型，然后使用 KCL CLI 将其翻译到多个平台，例如不同版本的 `Docker Compose` 或 `Kubernetes`。

`Docker Compose` 是一个用于定义和运行多容器 Docker 应用程序的工具。使用 Docker Compose，您可以在一个文件中定义应用程序的服务、网络和卷，然后使用它作为一个单元启动和停止应用程序。Docker Compose 通过处理网络、存储和其他基础设施问题的细节，简化了运行复杂的多容器应用程序的过程。

Kubernetes 清单是定义 Kubernete 对象（如 Pods、Deployments 和 Services）的 YAML 文件。清单提供了一种声明性的方法来定义应用程序的所需状态，包括副本数量、要使用的镜像和网络配置。Kubernetes 使用清单来创建和管理部署和运行应用程序所需的资源。

以下是一些参考资料，以了解更多关于 Docker Compose 和 Kubernetes 相关的信息：

+ [Docker Compose 文档](https://docs.docker.com/compose/)
+ [Kubernetes 对象文档](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)

该应用程序模型旨在通过只需定义一个跨多个平台工作的 KCL 文件来减少开发人员的工作量和认知负荷，并且它被设计为应用于多个环境以减少配置量。现在，让我们学习如何做到这一点。

### 1. 获取示例

首先，我们执行 git 命令获得用例

```bash
git clone https://github.com/KusionStack/kcl-lang.io.git/
cd ./kcl-lang.io/examples/abstraction
```

我们可以运行以下命令来显示配置。

```bash
cat main.k
```

输出为

```python
import .app

app.App {
    name = "ngnix"
    containers.ngnix = {
        image = name
        ports = [{containerPort = 80}]
    }
    service.ports = [{ port = 80 }]
}
```

在上面的代码中，我们使用 `App` schema 定义了一个配置，其中我们配置了一个 `ngnix` 容器，并开启 `80` 端口配置。

此外，KCL 允许开发人员以声明式的方式定义应用程序所需的资源，并与 Docker Compose 或 Kubernetes 清单等平台绑定，并允许生成特定于平台的配置文件，如 `Docker Compose.yaml` 或Kuberneses `manifests.yaml` 文件。接下来，让我们生成相应的配置。

### 2. 将应用配置转换为 Docker Compose 配置

如果我们想将应用程序配置转换为 Docker Compose 配置，我们可以简单地运行如下命令：

```shell
$ kcl main.k docker_compose_render.k
services:
  ngnix:
    image: ngnix
    ports:
      - published: 80
        target: 80
        protocol: TCP
```

### 3. 将应用配置转换为 Kubernetes Deployment and Service 资源清单

如果我们想将应用程序配置转换为 Kubernetes 清单，我们可以简单地运行如下命令：

```shell
$ kcl main.k kubernetes_render.k
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ngnix
  labels:
    app: ngnix
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ngnix
  template:
    metadata:
      labels:
        app: ngnix
    spec:
      containers:
        - name: ngnix
          image: "ngnix:v1.4.2"
          ports:
            - protocol: TCP
              containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: ngnix
  labels:
    app: ngnix
spec:
  selector:
    app: ngnix
  ports:
    - port: 80
      protocol: TCP
```

如果您想了解有关应用程序模型的更多信息，可以参考[此处](https://github.com/KusionStack/kcl-lang.io/tree/main/examples/abstraction).

## 小结

通过使用 KCL，我们能够分离模型的抽象和实现细节，允许将抽象模型映射到各种基础设施或平台。这是通过不同实现之间的灵活切换和 KCL 组合编译来实现的，屏蔽配置差异，减轻认知负担。

## 更多信息

除了手动维护配置外，我们还可以使用 KCL API 将**自动配置更改能力**集成到我们的应用程序中。有关 KCL 自动化能力的相关说明，请参阅[此处](/docs/user_docs/guides/automation)。
