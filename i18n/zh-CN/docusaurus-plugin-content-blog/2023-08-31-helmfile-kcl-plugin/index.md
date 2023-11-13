---
slug: 2023-08-31-helmfile-kcl-plugin
title: 5 分钟玩转 Helmfile KCL 插件，轻松管理 Kubernetes Helm Charts
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

## 什么是 KCL

[KCL](https://github.com/kcl-lang) 是一个开源的基于约束的记录及函数语言并通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

## 什么是 Helmfile

Helmfile 是一个是用于简化和管理 Helm Charts 的声明性规范和工具，Helmfile KCL 插件为 Helmfile 工具提供了额外的功能，使得在使用 Helmfile 时更加便捷和高效，通过 Helmfile KCL 插件您可以

- 通过无侵入的 Hook 方式在客户端直接编辑或者验证 Helm Chart 配置，将 Kubernetes 配置管理的数据部分和逻辑部分分离，无需 Fork 上游 Chart 修改内部逻辑，比如
  - 修改资源标签/注解, 注入 Sidecar 容器配置
  - 使用 KCL Schema 校验 Kubernetes 资源，定义自己的抽象模型并分享复用
- 优雅地维护多环境、多租户场景配置，而不是简单地复制粘贴

在本文中，我们将带您快速了解和入门 Helmfile KCL 插件，让您轻松管理您的 Kubernetes Helm Charts。

下面以一个简单示例进行详细说明，使用 Helmfile KCL 插件无需您安装与 KCL 任何相关的组件，只需本机具备 Helmfile 工具的最新版本（v0.156.0+）即可。

## 使用 Helmfile KCL 插件

### 1. 工具安装

首先，确保您已经安装了 Helmfile 客户端工具，可以根据下面链接中的文档提示进行安装。

https://github.com/helmfile/helmfile

### 2. 创建 Helmfile 配置文件

在您的项目根目录中创建一个名为 helmfile.yaml 的文件，并按照 Helmfile 的语法编写配置。在这个文件中，您可以指定要使用的 Helm Charts、配置值和任何其他 Helmfile 支持的功能。此外，您还可以在 helmfile.yaml 中使用 KCL 插件的功能来加载对 Helm Chart 进行原地配置修改和验证

```yaml
repositories:
  - name: prometheus-community
    url: https://prometheus-community.github.io/helm-charts

releases:
  - name: prom-norbac-ubuntu
    namespace: prometheus
    chart: prometheus-community/prometheus
    set:
      - name: rbac.create
        value: false
    transformers:
      # Use KCL Plugin to mutate or validate Kubernetes manifests.
      - apiVersion: krm.kcl.dev/v1alpha1
        kind: KCLRun
        metadata:
          name: "set-annotation"
          annotations:
            config.kubernetes.io/function: |
              container:
                image: docker.io/kcllang/kustomize-kcl:v0.2.0
        spec:
          source: |
            # 仅通过一行 KCL 代码，就可实现对 workload 配置原地修改
            items = [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "helmfile-kcl"}} for resource in option("resource_list").items]
```

在上述配置中，我们引用了 Prometheus Helm Chart, 并通过一行 KCL 代码就可以完成 Prometheus 的所有的 Deployment 资源注入标签 managed-by="helmfile-kcl"。

### 3. 运行 Helmfile 工具

一切准备就绪后，您可以运行 Helmfile 命令来部署、管理和维护您的 Helm Charts，通过如下命令我们可以将上述配置下发到集群。

```shell
helmfile apply
```

正常情况我们会看到如下面所示的输出

```shell
Adding repo prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories...

...
```

## 想要更多?

对于上述 helmfile 配置，我们可以将其封装为常用的配置修改逻辑并使用，无需不断重复编写 KCL 代码并到处复制粘贴。此外，我们在 KCL 官方 Registry 已经封装好了许多常用的 Kubernetes 配置编辑和校验代码片段 https://github.com/orgs/kcl-lang/packages

![registry](/img/blog/2023-08-31-helmfile-kcl-plugin/registry.png)

除了支持在配置文件中书写 KCL 代码，我们还支持直接引用 Registry 中的代码片段，如下所示

```yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: https-only
  annotations:
    krm.kcl.dev/version: 0.0.1
    krm.kcl.dev/type: validation
    documentation: >-
      Requires Ingress resources to be HTTPS only.  Ingress resources must
      include the `kubernetes.io/ingress.allow-http` annotation, set to `false`.
      By default a valid TLS {} configuration is required, this can be made
      optional by setting the `tlsOptional` parameter to `true`.
      More info: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
spec:
  # Use the OCI source
  source: oci://ghcr.io/kcl-lang/https-only
```

具体的示例代码在[这里](https://github.com/kcl-lang/krm-kcl/tree/main/examples)

如果您想贡献更多的 KCL 代码库，欢迎联系我们并参阅文档进行贡献 https://kcl-lang.io/zh-CN/docs/user_docs/guides/package-management/share_your_pkg/

## 小结

本文提供了一个快速入门指南，帮助您在 5 分钟内掌握 Helmfile KCL 插件的基本用法。现在，您可以开始使用这个强大的工具来简化和优化您的 Kubernetes 应用部署流程了！

## 其他资源

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)

- [KCL 2023 路线规划](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
