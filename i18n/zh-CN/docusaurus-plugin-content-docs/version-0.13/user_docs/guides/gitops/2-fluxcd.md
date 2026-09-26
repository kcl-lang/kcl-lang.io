---
id: gitops-with-fluxcd
sidebar_label: 使用 flux-kcl-controller 支持 KCL 与 FluxCD 实现 GitOps
---

# 快速开始

## 简介

### 什么是 GitOps

GitOps 是一种实现持续交付的现代方式。它的核心思想是拥有一个包含环境和应用程序配置的 Git 存储库。通过更改应用存储库中的文件，可以自动部署应用程序。应用 GitOps 的好处包括：

- 提高生产力，持续交付可以加快部署时间。
- 降低开发人员部署的障碍。通过推送代码而不是容器配置，开发人员可以在不知道其内部实现的情况下轻松部署 Kubernetes 集群和应用。
- 追踪变更记录。使用 Git 管理配置使每一项更改都具有可跟踪性，从而增强审计跟踪。

### 将 KCL 与 FluxCD 一起使用

将 [KCL](https://github.com/kcl-lang/kcl) 与 [FluxCD](https://github.com/fluxcd/flux2) 等 GitOps 工具一起使用具有如下好处:

- 通过 KCL 语言的[抽象能力](/docs/user_docs/guides/abstraction)和可编程能力可以帮助我们**简化复杂的 Kubernetes 部署配置文件**，降低手动编写 YAML 文件的错误率，消除多余的配置模版，提升多环境多租户的配置扩展能力，同时提高配置的可读性和可维护性。
- KCL 允许开发人员以声明式的方式定义应用程序所需的资源，通过将 KCL 和 FluxCD 相结合可以帮助我们更好地实现**基础设施即代码（IaC）**，提高部署效率，简化应用程序的配置管理。
- FluxCD 可以**自动化**地实现应用程序的连续部署，并提供友好的可视化界面。

使用 GitOps，开发人员和运维团队可以通过分别修改应用和配置代码来管理应用程序的部署，GitOps 工具链将自动同步对配置的更改，从而实现持续部署并确保一致性。如果出现问题，可以使用 GitOps 工具链快速回滚。

### Flux-KCL-Controller

kcl-controller 是一个组件，用于集成 [KCL](https://github.com/kcl-lang/kcl) 和 [Flux](https://github.com/fluxcd/flux2), 主要用来根据存储在 git/oci 仓库中的 KCL 程序定义的基础设施和工作负载，通过 [source-controller](https://github.com/fluxcd/source-controller) 获取 KCL 程序，实现基础设施和工作负载的持续交付。

![](/img/docs/user_docs/guides/cd-integration/kcl-flux.png)

## 先决条件

- 安装 [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install)

## 快速开始

### 1. 安装 Kubernetes 和 GitOps 工具

#### 配置 Kubernetes 集群和 FluxCD 控制器

- 安装 [K3d](https://github.com/k3d-io/k3d) 并创建一个集群

```bash
k3d cluster create mycluster
```

> 注意：你可以在此方案中使用其他方式创建您自己的 Kubernetes 集群，如 kind, minikube 等。

- 安装 Flux KCL Controller

```bash
git clone https://github.com/kcl-lang/flux-kcl-controller.git && cd flux-kcl-controller && make deploy
```

- 通过 `kubectl get` 命令查看 fluxcd 控制器容器是否初始化完成进入运行（Running）状态。

```bash
kubectl get pod -n source-system -l app=kcl-controller
```

### 2. 编写 Flux-KCL-Controller 配置文件

以[《使用 Github、Argo CD 和 KCL 实现 GitOps 以简化 DevOps》](https://kcl-lang.io/zh-CN/blog/2023-07-31-kcl-github-argocd-gitops/) 中的 flask demo 为例，我们在 `flux-kcl-controller` 仓库中创建一个 `GitRepository` 对象，用于监控存储在 git 仓库中的 KCL 程序。将一下内容保存在文件 `gitrepo.yaml` 中。

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kcl-deployment
  namespace: default
spec:
  interval: 10s # 每隔 10 秒检查
  url: https://github.com/kcl-lang/flask-demo-kcl-manifests.git
  ref:
    branch: main # 监控 main 分支
---
apiVersion: krm.kcl.dev.fluxcd/v1alpha1
kind: KCLRun
metadata:
  name: kcl-git-controller
  namespace: default
spec:
  sourceRef:
    kind: GitRepository
    name: kcl-deployment
```

通过命令 `kubectl apply -f gitrepo.yaml` 部署对象到集群。

### 3. 查看部署结果

通过 `kubectl get deployments` 命令查看 python flask demo 部署结果。

```
kubectl get deployments
```

可以看到结果，部署成功

```
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
flask-demo   1/1     1            1           17d
```

### 4. 更多内容

- [FluxCD 官方文档](https://toolkit.fluxcd.io/)
- [Flux Source Controller 官方文档](https://fluxcd.io/flux/components/source/)
- [GitRepositrory](https://fluxcd.io/flux/components/source/gitrepositories/)
