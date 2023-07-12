---
id: github-actions
sidebar_label: Github Actions
---
# Github Actions 集成

## 简介

在 GitOps 章节，我们介绍了如何将 KCL 与 GitOps 进行集成。在本文中，我们将继续提供 KCL 和 CI 集成的示例方案，希望通过使用容器、用于生成的持续集成 (CI) 和用于持续部署 (CD) 的 GitOps 来实现端到端应用程序开发流程。在此方案中，我们使用一个 Flask 应用和 Github Actions 将用作示例。

> 注意：你可以在此方案中使用任何容器化应用以及不同的 CI 系统如 Gitlab CI，Jenkins CI 等。

整体工作流程如下：

+ 应用代码开发并提交到提交到 GitHub 存储库
+ GitHub Actions 从应用代码生成容器镜像，并将容器镜像推送到 docker.io 容器注册表
+ GitHub Actions 根据 docker.io 容器注册表中容器镜像的版本号并同步更新 KCL 清单部署文件

## 具体步骤

### 1. 获得示例

我们将业务源码和部署清单放在不同仓库，可以分不同角色进行分别维护，实现关注点分离。

+ 获得业务源码

```shell
git clone https://github.com/kcl-lang/flask-demo.io.git/
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

### 2. 提交应用代码

flask-demo 仓库提交代码后，Github 会自动构建容器镜像，并将制品推送到 Docker hub 中，会再触发 flask-demo-kcl-manifests 仓库的 Action，[通过 KCL 自动化 API](/docs/user_docs/guides/automation) 修改部署清单仓库中的镜像地址。现在让我们为 flask-demo 仓库创建一个提交，我们可以看到代码提交后触发业务仓库 Github CI 流程

![](/img/docs/user_docs/guides/ci-integration/app-ci.png)

### 3. 配置自动更新

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

从上述配置可以看出资源的镜像确实自动更新为了新构建的镜像内容。此外，我们还可以使用 Argo CD KCL 插件 自动从 Git 存储库同步或从中拉取数据并将应用部署到 Kubernetes 集群。

## 小结

通过将 KCL 和 Github CI 集成，我们能够将任意的业务代码的产出容器化镜像进行自动化修改并部署配置，以实现端到端应用程序开发流程并提升研发部署效率。
