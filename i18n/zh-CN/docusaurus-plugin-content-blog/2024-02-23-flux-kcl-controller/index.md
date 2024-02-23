---
slug: 2024-02-23-flux-kcl-controller
title: flux-kcl-controller 助力 KCL & FluxCD 实现 GitOps
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Github, FluxCD, GitOps]
---

## 前言

在现代软件开发实践中，GitOps 已成为管理基础架构和应用程序的一种关键技术。能够显著提升自动化水平，减少人为干预，从而降低错误的发生率，并提高整体的操作效率。这种方法已在云原生等领域获得广泛应用。

在之前的文章中：我们分享了借助 ArgoCD，KCL 和 Github 实践 GitOps 的自动化流程。

- [使用 Github、Argo CD 和 KCL 实现 GitOps 以简化 DevOps](https://kcl-lang.io/zh-CN/blog/2023-07-31-kcl-github-argocd-gitops)

本文将继续扩展 KCL 在 GitOps 领域的实践，与持续集成工具 FluxCD 进行集成，并借助 KCL、GitHub 和 FluxCD 来提供一个具体的实践示例，详细阐述如何搭建和运行一个GitOps 自动化流程。

### 什么是 GitOps

GitOps 是一种基于 Git 的软件部署和操作模型，旨在利用 Git 的版本控制能力来管理和自动化基础设施及应用程序的部署。在 GitOps 中，Git 仓库不仅是代码的存储地，也是真实环境状态的反映。任何更改都通过对 Git 仓库的提交来实施，这些更改随后会被自动同步到生产环境中。

通过 GitOps, 可以有效
- 增强开发和运维的协作：通过统一的 Git 工作流，开发人员和运维人员可以更协调地合作。
- 提升部署的速度与安全性：GitOps通过自动化流程简化了部署，同时提供了必要的审计和回滚机制。
- 提高系统的可追溯性：Git作为配置的单一来源，确保了每一次更改都被记录和追踪，便于监控和回顾。

### KCL & FluxCD

FluxCD 是一个实现 GitOps 模型的自动化工具，专门用于 Kubernetes 集群。它负责监控 Git 仓库中的变化，并确保 Kubernetes 集群的状态与仓库中定义的状态保持一致。FluxCD 的关键特点包括：

- 自动化同步：自动将Git仓库中的变更同步到 Kubernetes，实现配置的持续部署。
- 声明式基础设施：通过声明式的配置文件来管理集群，使基础设施的版本控制更加直观。
- 安全性与合规性：通过 Git 的分支和 PR 机制提供更安全的更改管理和审计跟踪。

KCL 通过其抽象和可编程特性能够显著简化复杂的 Kubernetes 部署配置。它将错误几率最小化，允许开发人员在编写阶段及时发现潜在问题，而非等到运行时。这意味着更少的配置模板和更强的多环境以及多租户配置能力，从而提升配置的可读性和可维护性。

利用 KCL，开发人员能够以声明式的手段精确定义所需的资源，结合 FluxCD，这种声明式的基础可以促进基础设施即代码（IaC）的实施，进而提高部署效率并且优化应用程序的配置管理。FluxCD 作为一个自动化的持续部署工具，加上对 KCL 的支持，为配置提供了一个易于管理的可视化界面。

在采用 GitOps 的流程中，开发人员和运维团队可以各司其职，通过修改应用和配置代码来管理应用程序的部署。GitOps 工具链，如 FluxCD，将自动同步这些更改，确保持续部署的同时保持环境状态的一致性。在部署过程中遇到任何问题，也可以便捷地利用 GitOps 工具链进行快速回滚，确保系统稳定性和业务连续性。

### Flux KCL Controller

Flux KCL Controller 是我们为 KCL 开发的一个 FluxCD Controller, 负责监控存储 KCL 程序的 Git 仓库。通过这个控制器，FluxCD 能够扩展其自动化部署的能力，实现对 KCL 语言编写的配置文件的持续监控和应用。

![flux-cd](/img/blog/2024-02-23-flux-kcl-controller/fluxcontroller.jpg)

借助 FluxCD 官方提供的 Source Controller ,Flux KCL Controller 可以定期检查与之关联的 Git 仓库中的 KCL 文件，一旦检测到仓库中有新的提交或更新，它便会自动触发配置的同步过程。这意味着，任何对 KCL 配置的更改都将被检测到，并自动反映到 Kubernetes 集群的状态中，从而维护配置的最新状态和一致性。

- [更多内容关于 Flux KCL Controller](https://github.com/kcl-lang/flux-kcl-controller)

## 案例介绍

我们仍然使用一个 Python Flask 应用和 Github Actions 作为 CI 示例，使用 Flux KCL Controller 来集成 FluxCD 的功能进行持续集成。

我们将 Python Flask 应用代码和配置代码分成两个仓库，以实现不同角色如开发人员和运维团队的关注点分离。

- 业务代码仓库: https://github.com/kcl-lang/flask-demo
- 配置清单仓库: https://github.com/kcl-lang/flask-demo-kcl-manifests

整体工作流程如下：

![workflow](/img/blog/2024-02-23-flux-kcl-controller/workflow.jpg)

- 从 Github 拉取应用代码
- 应用代码开发并提交到提交到 GitHub 存储库
- 触发 GitHub Actions 对应用代码进行编译，生成容器镜像，并将容器镜像推送到 Docker Hub 容器注册表
- 触发 GitHub Actions 根据 docker.io 容器注册表中容器镜像的版本号并同步更新 KCL 定义的 Kubernetes 清单部署文件
- Flux KCL Controller 根据 Git 仓库的变更，获取 KCL 定义的 Kubernetes 清单更改并更新部署至 Kubernetes 集群。

## 具体步骤

### 0. 先决条件

- 熟悉 Unix/Linux 的基本命令
- 熟悉 Git 以及 Github Action 使用
- 了解 Kubernetes 基本知识
- 了解 KCL 基本知识

### 1. 配置 Kubernetes 集群

- 安装 [K3d](https://github.com/k3d-io/k3d) 并创建一个集群

```bash
k3d cluster create mycluster
```

> 注意：你可以在此方案中使用其他方式创建您自己的 Kubernetes 集群，如 kind, minikube 等。

### 2. 安装和配置 Flux KCL Controller

- 通过以下命令在集群中安装 Flux KCL Controller

```bash
git clone https://github.com/kcl-lang/flux-kcl-controller.git/ && cd flux-kcl-controller && make deploy
```

更多详细内容关于 Flux-KCL-Controller 的安装和使用，请参考 [Flux-KCL-Controller](https://github.com/kcl-lang/flux-kcl-controller/blob/main/README-zh.md).

### 3. 获得业务代码

```shell
git clone https://github.com/kcl-lang/flask-demo.git/
cd flask-demo
```

这是一个使用 Python 编写的 Web 应用，我们可以使用应用目录的 `Dockerfile` 来生成这个应用的容器镜像，同时可以通过 Github CI 自动构建 `flask_demo` 镜像。

在之前的文章中，我们已经完成了这部分的工作，这里就不再重复描述。[更多细节](https://kcl-lang.io/zh-CN/blog/2023-07-31-kcl-github-argocd-gitops/#3-%E8%8E%B7%E5%BE%97%E4%B8%9A%E5%8A%A1%E4%BB%A3%E7%A0%81)。


### 4. 提交应用代码

flask-demo 仓库提交代码后，Github 会自动构建容器镜像，并将制品推送到 Docker hub 中，会再触发 flask-demo-kcl-manifests 仓库的 Action，[通过 KCL 自动化 API](/docs/user_docs/guides/automation) 修改部署清单仓库中的镜像地址。现在让我们为 flask-demo 仓库创建一个提交，我们可以看到代码提交后触发业务仓库 Github CI 流程

![](/img/docs/user_docs/guides/ci-integration/app-ci.png)

### 5. 配置自动更新

当业务仓库 Github CI 流程执行完成后，会自动在存放 KCL 资源配置的仓库触发一个 CI 自动更新配置并提交到 flask-demo-kcl-manifests main 分支。

在之前的文章中，我们已经完成了这部分的工作，因此在这里我们就不再重复，[更多细节](https://kcl-lang.io/zh-CN/blog/2023-07-31-kcl-github-argocd-gitops/#5-%E9%85%8D%E7%BD%AE%E8%87%AA%E5%8A%A8%E6%9B%B4%E6%96%B0)。

### 6. 使用 Flux KCL Controller 监控配置仓库

完成安装后，我们可以通过以下命令设置 Flux KCL Controller 监控配置仓库的地址，并根据配置内容自动更新 Kubernetes 集群中的资源。

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kcl-deployment
  namespace: default
spec:
  interval: 10s # 每隔 10s 检查一次仓库
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

### 7. 通过 kubectl 查看资源

通过以下命令，可以查看 Kubernetes 集群中的资源。

```shell
kubectl get deplopments
```

从输出中可以看到部署的资源已经更新为最新的镜像

```shell
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
flask-demo   1/1     1            1           16d
```

## 结论

通过本篇文章，我们探索了如何利用 Flux KCL Controller 和 FluxCD 集成 KCL 来创建 GitOps 自动化流水线，实现了对容器化应用的高效和稳定构建。结合使用 Flux KCL Controller 和 FluxCD 自动更新 Docker 镜像标签，并确保 Git 中的配置与集群状态保持同步，优化了部署流程，实现了开发和运维之间的职责分离，并简化了应用程序配置的管理过程。这个集成方案为我们提供了一种透明、可追踪和可重现的方式来持续交付软件，确保了开发的灵活性和生产环境的稳定性。
