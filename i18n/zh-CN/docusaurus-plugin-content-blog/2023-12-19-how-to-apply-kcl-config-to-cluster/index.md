---
slug: 2023-12-19-how-to-apply-kcl-config-to-cluster
title: 如何将 KCL 代码部署到集群?
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL]
---

# 如何将 KCL 代码部署到集群?

## 什么是 KCL

[KCL](https://kcl-lang.io) 是一个 CNCF 基金会托管的面向云原生场景的配置及策略语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

## 将 KCL 配置部署到集群的几种方式

![cloud-native-tool-integration](/img/blog/2023-12-19-how-to-apply-kcl-config-to-cluster/cloud-native-tool-integration.png)

因为 KCL 本身可以输出为 YAML/JSON 文件，因此理论上支持将 YAML/JSON 配置部署到集群的方式，都可以将 KCL 配置部署到集群，通常我们将 KCL 文件放在 Git 或者 Module Registry 中保存方便与不同的角色和团队之间共享配置，但是 KCL 可以做到的远不止这些，这里将可以将 KCL 配置部署到的集群主要分为如下几种情况。

- **使用 kubectl**: 访问 Kubernetes 集群最基本的方式就是使用 Kubectl，我们可以通过 kubectl apply 命令直接将 KCL 生成的 Kubernetes YAML 配置文件部署到集群中。这种方式简单快捷，适用于单个或少量资源的部署
- **使用 CI/CD 工具**: 可以使用 CI/CD 工具（例如 Jenkins、GitLab CI、CircleCI、ArgoCD、FluxCD 等）来实现 GitOps 自动化部署 Kubernetes YAML 配置文件到集群中。通过定义 CI/CD 流程和配置文件，可以实现自动化构建和部署到集群中
- **使用支持 KRM Function 规范的工具**: KRM Function 允许用户使用其他语言包括 KCL 来提升 YAML 模版和逻辑编写能力比如编写条件、循环等，这类工具主要包括 Kustomize, KPT, Crossplane 等，虽然 Helm 并没有原生支持，但是我们可以将 Helm 和 Kustomize 结合使用来实现
- **使用客户端/运行时自定义抽象配置工具进行部署**: 如 KusionStack, KubeVela 等，当然 KCL 允许您自定义您喜欢的应用配置模型。
- **使用 KCL Operator**: 结合 Kubernetes Mutation Webhook 和 Validation Webhook 支持运行时编写配置或策略。+**使用配置管理工具**: 结合配置管理工具（例如 Puppet、Chef、Ansible 等）来自动化部署 Kubernetes YAML 配置到集群中。这些工具可以通过定义 KCL 模板和变量来实现动态配置部署

KCL 支持多种部署方式和云原生工具集成有以下几个原因：

- **灵活性**：不同的部署方式适用于不同的场景和需求，因此提供多种选择可以使用户根据其特定的情况选择最合适的方式来部署应用程序或配置。
- **工具生态系统**：Kubernetes 是一个生态系统庞大的平台，有许多工具和技术被广泛应用。支持多种部署方式可以为用户提供更多选择，满足其使用习惯和技术偏好。
- **规范和标准**：Kubernetes 社区努力推动标准和规范，例如 OAM, KRM Function 规范和 Helm Charts 等。通过统一的 KRM KCL 规范和 KCL Module 提供多种支持方式，可以满足不同规范和标准的需求。
- **自动化和集成**：一些部署方式可以通过自动化工具和 CI/CD 管道进行集成，以实现自动化的部署流程。因此，提供多种方式可以满足不同自动化和集成的需求。

综上所述，支持多种部署方式可以为用户提供更大的灵活性和选择权，用户可以根据自己的需求和偏好来部署应用程序或配置。

下面是各个部署方式的具体使用方式

### 使用 Kubectl 工具

https://kcl-lang.io/blog/2023-11-20-search-k8s-module-on-artifacthub

### 使用 CI/CD 工具

https://kcl-lang.io/blog/2023-07-31-kcl-github-argocd-gitops

### 使用 KRM Function

https://kcl-lang.io/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec

### 使用自定义抽象配置工具

https://kcl-lang.io/blog/2023-12-15-kubevela-integration

### 使用 KCL Operator

https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/mutate-manifests/kcl-operator

### 使用配置管理工具

https://github.com/kcl-lang/kcl/issues/952
