---
slug: 2023-07-31-kcl-github-argocd-gitops
title: 使用 Github、Argo CD 和 KCL 实现 GitOps 以简化 DevOps
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Github, ArgoCD, GitOps]
---

## 前言

在现代软件开发中，GitOps 作为管理基础架构和应用程序的单一真相自动化的方法可以提高效率和减少人为错误方面发挥着关键作用，目前广泛流行于云原生等领域。但是关于 GitOps 相关的实践示例并不多见，本文将以 KCL、Github、ArgoCD 和 GitOps 作为一个使用示例来详细介绍，希望可以帮助大家实践自己的 GitOps 自动化流程并简化 DevOps。

### 什么是 GitOps

GitOps 是一种实现持续交付的现代方式。它的核心思想是拥有一个包含环境和应用程序配置的 Git 存储库。通过更改应用存储库中的文件，可以自动部署应用程序。应用 GitOps 的好处包括：

+ 提高生产力，持续交付可以加快部署时间。
+ 降低开发人员部署的障碍。通过推送代码而不是容器配置，开发人员可以在不知道其内部实现的情况下轻松部署 Kubernetes 集群和应用。
+ 追踪变更记录。使用 Git 管理配置使每一项更改都具有可跟踪性，从而增强审计跟踪。

### 将 KCL 与 GitOps 一起使用

将 KCL 与 GitOps 工具一起使用具有如下好处:

+ 通过 KCL 语言的抽象能力和可编程能力可以帮助我们**简化复杂的 Kubernetes 部署配置文件**，降低手动编写 YAML 文件的错误率，将配置约束检查控制在编译时，编写即感知错误；同时可以消除多余的配置模版，提升多环境多租户的配置扩展能力，提高配置的可读性和可维护性。
+ KCL 允许开发人员以声明式的方式定义应用程序所需的资源，通过将 KCL 和 ArgoCD 相结合可以帮助我们更好地实现**基础设施即代码（IaC）**，提高部署效率，简化应用程序的配置管理。
+ ArgoCD 可以**自动化**地实现应用程序的连续部署，并提供友好的 KCL 配置**可视化管理界面**。

使用 GitOps，开发人员和运维团队可以通过分别修改应用和配置代码来管理应用程序的部署，GitOps 工具链将自动同步对配置的更改，从而实现持续部署并确保一致性。如果出现问题，可以使用 GitOps 工具链快速回滚。

## 工作流程

在此示例中，我们使用一个 Python Flask 应用和 Github Actions 作为 CI 示例，使用 ArgoCD 作为 CD 示例，使用 KCL 定义需要部署的 Kubernetes 资源

> 注意：你可以在此方案中使用任何容器化应用以及不同的 CI 和 CD 系统如 Gitlab CI，Jenkins CI，FluxCD 等，后续我们会出更多的示例文章来进行说明

我们将 Python Flask 应用代码和配置代码分成两个仓库，*以实现不同角色如开发人员和运维团队的关注点分离*

+ 业务代码仓库: https://github.com/kcl-lang/flask-demo
+ 配置清单仓库: https://github.com/kcl-lang/flask-demo-kcl-manifests

整体工作流程如下：

![workflow](/img/blog/2023-07-31-kcl-github-argocd-gitops/workflow.jpg)

1. 从 Github 拉取应用代码
2. 应用代码开发并提交到提交到 GitHub 存储库
3. 触发 GitHub Actions 对应用代码进行编译，生成容器镜像，并将容器镜像推送到 Docker Hub 容器注册表
4. 触发 GitHub Actions 根据 docker.io 容器注册表中容器镜像的版本号并同步更新 KCL 定义的 Kubernetes 清单部署文件
5. ArgoCD 获取 KCL 定义的 Kubernetes 清单更改并更新部署至 Kubernetes 集群

## 具体步骤

### 0.先决条件

+ 熟悉 Unix/Linux 的基本命令
+ 熟悉 Git 以及 Github Action 使用
+ 了解 Kubernetes 基本知识
+ 了解 ArgoCD 等工具
+ 了解 KCL 基本知识

### 1. 配置 Kubernetes 集群

+ 安装 [K3d](https://github.com/k3d-io/k3d) 并创建一个集群

```bash
k3d cluster create mycluster
```

> 注意：你可以在此方案中使用其他方式创建您自己的 Kubernetes 集群，如 kind, minikube 等。

### 2. 配置 ArgoCD

#### 配置 ArgoCD 控制器

> 注意：你可以在此方案中使用其他方式创建您自己的 Kubernetes 集群，如 kind, minikube 等。

+ 安装 [ArgoCD](https://github.com/argoproj/argo-cd/releases/).

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

+ 安装 ArgoCD KCL 插件

```bash
git clone https://github.com/kcl-lang/kcl-lang.io.git/ && cd ./kcl-lang.io/examples/gitops
kubectl apply -f ./install/kcl-cmp.yaml && kubectl -n argocd patch deploy/argocd-repo-server -p "$(cat ./install/patch-argocd-repo-server.yaml)"
```

+ 通过 `kubectl get` 命令查看 argocd 控制器容器是否初始化完成进入运行（Running）状态。

```bash
kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-repo-server
```

+ 通过如下命令打开 ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

+ 打开浏览器 `https://localhost:8080` 输入用户名 "admin" 和密码登陆 ArgoCD UI，密码可以通过如下命令得到:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### 配置 ArgoCD 客户端工具

+ 安装 [ArgoCD 客户端工具](https://github.com/argoproj/argo-cd/releases)

+ 使用用户名 "admin" 和刚才得到的密码登陆

```bash
argocd login localhost:8080
```

通过如下命令创建一个 ArgoCD KCL 应用

```bash
argocd app create flaskdemo \
--repo https://github.com/kcl-lang/flask-demo-kcl-manifests \
--path . \
--dest-namespace default \
--dest-server https://kubernetes.default.svc \
--config-management-plugin kcl-v1.0
```

如果创建成功，您可以看到如下输出:

```bash
application 'flaskdemo' created
```

> 如果您使用的是私有存储库，则在执行 create 命令之前，需要使用私钥凭据配置专用私有存储库访问权限。请参阅[这里](https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/)以获取更多详细信息。

通过 ArgoCD UI，您可以看到创建的应用程序尚未同步，您可以手动进行配置同步或设置为自动同步。

![](/img/docs/user_docs/guides/gitops/argocd-kcl-app.jpg)

有关同步策略的更多信息，可以请参阅[这里](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/)

![](/img/docs/user_docs/guides/gitops/argocd-kcl-app-dashboard.jpg)

### 3. 获得业务代码

```shell
git clone https://github.com/kcl-lang/flask-demo.git/
cd flask-demo
```

这是一个使用 Python 编写的 Web 应用，我们可以使用应用目录的 `Dockerfile` 来生成这个应用的容器镜像，同时可以通过 Github CI 自动构建 `flask_demo` 镜像，CI 配置如下

```yaml
# This is a basic workflow to help you get started with Actions

name: CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v2
      
      - name: Docker Login
        uses: docker/login-action@v1.10.0
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
          logout: true

      # Runs a set of commands using the runners shell
      - name: build image
        run: |
          make image
          docker tag flask_demo:latest ${{ secrets.DOCKER_USERNAME }}/flask_demo:${{ github.sha }}
          docker push ${{ secrets.DOCKER_USERNAME }}/flask_demo:${{ github.sha }}

      # Trigger KCL manifest
      - name: Trigger CI
        uses: InformaticsMatters/trigger-ci-action@1.0.1
        with:
          ci-owner: kcl-lang
          ci-repository: flask-demo-kcl-manifests
          ci-ref: refs/heads/main
          ci-user: kcl-bot
          ci-user-token: ${{ secrets.DEPLOY_ACCESS_TOKEN }}
          ci-name: CI
          ci-inputs: >-
            image=${{ secrets.DOCKER_USERNAME }}/flask_demo
            sha-tag=${{ github.sha }}
```

我们需要源码仓库的工作流自动触发部署清单仓库中的工作流，此时需要创建具有 Github CI 操作权限的 `secrets.DEPLOY_ACCESS_TOKEN` 以及 Docker Hub 镜像推送的账号信息 `secrets.DOCKER_USERNAME` 和 `secrets.DOCKER_PASSWORD`, 这些可以在 Github 仓库的 `Secrets and variables` 设置中进行配置，如下图所示

![](/img/docs/user_docs/guides/ci-integration/github-secrets.png)

### 4. 提交应用代码

flask-demo 仓库提交代码后，Github 会自动构建容器镜像，并将制品推送到 Docker hub 中，会再触发 flask-demo-kcl-manifests 仓库的 Action，[通过 KCL 自动化 API](/docs/user_docs/guides/automation) 修改部署清单仓库中的镜像地址。现在让我们为 flask-demo 仓库创建一个提交，我们可以看到代码提交后触发业务仓库 Github CI 流程

![](/img/docs/user_docs/guides/ci-integration/app-ci.png)

### 5. 配置自动更新

当业务仓库 Github CI 流程执行完成后，会自动在存放 KCL 资源配置的仓库触发一个 CI 自动更新配置并提交到 flask-demo-kcl-manifests main 分支，commit 信息如下

![](/img/docs/user_docs/guides/ci-integration/image-auto-update.png)

+ 我们可以获得部署清单源码进行编译验证

```shell
git clone https://github.com/kcl-lang/flask-demo-kcl-manifests.git/
cd flask-demo-kcl-manifests
git checkout main && git pull && kcl
```

输出 YAML 为

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask_demo
  labels:
    app: flask_demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask_demo
  template:
    metadata:
      labels:
        app: flask_demo
    spec:
      containers:
        - name: flask_demo
          image: "kcllang/flask_demo:6428cff4309afc8c1c40ad180bb9cfd82546be3e"
          ports:
            - protocol: TCP
              containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flask_demo
  labels:
    app: flask_demo
spec:
  type: NodePort
  selector:
    app: flask_demo
  ports:
    - port: 5000
      protocol: TCP
      targetPort: 5000
```

从上述配置可以看出资源的镜像确实自动更新为了新构建的镜像内容。

此外，我们可以在 ArgoCD UI 界面中将同步策略设置为自动同步，这样就可以实现业务代码提交并部署 Kubernetes 的 e2e 完整自动化流程。

## 结论

通过本篇文章，我们可以使用 Github, ArgoCD 和 KCL 等创建 GitOps 自动化流水线，可以高效稳定地构建容器化应用，同时自动化更新最新的 Dcoker 镜像标签，并保持 Git 配置与集群配置一致。此外，通过将 KCL 和 ArgoCD 相结合可以帮助我们更好地实现基础设施即代码（IaC），提高部署效率，实现不同角色的关注点分离并简化应用程序的配置管理。
