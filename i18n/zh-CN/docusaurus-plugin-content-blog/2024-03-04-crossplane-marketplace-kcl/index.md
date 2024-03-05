---
slug: 2024-03-04-crossplane-marketplace-kcl
title: 官宣！知名 IaC 工具 Crossplane 宣布 KCL 登陆其官方函数市场！
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Crossplane]
---

> _内容转载整理自 Crossplane 官网博客原文：[https://blog.crossplane.io/function-kcl](https://blog.crossplane.io/function-kcl)_

## 内容简介

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

**自 Crossplane v1.14 中的组合函数 Beta 版发布以来**，使用 Crossplane 构建云原生平台的可能体验范围一直在迅速扩大。KCL 团队在第一时间进行跟进并主动构建了一个可重用的函数，**整个 Crossplane 生态系统现在可以利用 KCL 提供的高水平经验和能力来构建自己的云原生平台**。

同时 Crossplane 宣布 KCL 函数成为**第一个发布到 Upbound 市场的第三方函数组件**，地址为 *[https://marketplace.upbound.io/providers/crossplane-contrib/function-kcl](https://marketplace.upbound.io/providers/crossplane-contrib/function-kcl)* 。源代码可以在 *[https://github.com/crossplane-contrib/function-kcl](https://github.com/crossplane-contrib/function-kcl)* 找到，欢迎贡献和反馈。

您可以通过使用以下一行命令安装 function-kcl 并开始在整个 Crossplane 控制平面中使用：

```shell
crossplane xpkg install function xpkg.upbound.io/crossplane-contrib/function-kcl:v0.2.0
```

**Crossplane 团队和社区感谢 KCL 团队的这笔巨大捐赠，以及对不断发展的 Functions for Crossplane 生态系统的巨大补充**！

![crossplane-announcing](/img/blog/2024-03-04-crossplane-marketplace-kcl/crossplane-announcing.png)

Crossplane 及其组合模型允许开发人员创建更高级别的抽象，这些抽象可以封装和组合跨不同提供商和服务的多种类型的云资源。使用组合函数来渲染这些抽象可以有效增强各种提供者资源的模板功能，同时减少所需的 YAML 代码量。

将 KCL 与 Crossplane 组合函数结合起来有几个好处：

- **简化复杂配置**：KCL 提供了比一般 DSL 更简洁的语法和结构，降低了配置的复杂性。与 Crossplane 的复合资源结合时，您可以创建更直观且易于理解的具有循环和条件功能的配置模板对接到不同的云平台，从而简化资源的定义和维护，而不是编写重复的 YAML 模版。
- **可重用性和模块化**：KCL 通过 OCI Registry 支持模块化和代码重用，这意味着您可以创建可重用的配置组件。与 Crossplane 结合，可以促进复合资源的模块化，提高配置的重用性，并减少错误。
- **自动化和策略支持**：您可以使用 KCL 的强大功能来编写策略和约束，这些策略和约束与 Crossplane 的声明性资源管理相结合，且可以自动实施，从而确保云环境中的合规性，进一步提升效率和稳定性。

## 快速开始

有两种将 KCL 和 Crossplane 结合使用的方式

- 一种是使用 KCL 编写 Crossplane 组合函数并安装到集群使用，仍然采用 YAML 来定义 App Team 所需的 Schema 和输入，使用 KCL 撰写渲染逻辑到 Crossplane Manged Resource 的逻辑以对接不同的云平台或者 Kubernetes 集群。**需要注意的是：这种方式既可以将 KCL 函数安装到集群中使用，也可以使用 crossplane beta render 命令直接在客户端完成 Manged Resource 的渲染。**

![crossplane-kcl-func](/img/blog/2024-03-04-crossplane-marketplace-kcl/crossplane-kcl-func.png)

- 另外一种是使用 KCL 完全在客户端提供面向应用开发者的抽象并生成 Crossplane 托管资源下发到集群，提供 Kubernetes 的统一可编程接入层，具体使用 KCL Schema 规定 App Team 所需的 Schema 输入，并撰写渲染到 Crossplane Manged Resource 的逻辑以对接不同的云平台或者 Kubernetes 集群

![kcl-on-crossplane](/img/blog/2024-03-04-crossplane-marketplace-kcl/kcl-on-crossplane.png)

**两种方法的具体操作方式可以查看 Crossplane 官方博客内容：*https://blog.crossplane.io/function-kcl***

![crossplane-kcl-blog](/img/blog/2024-03-04-crossplane-marketplace-kcl/crossplane-kcl-blog.png)

此外，这两种方式都需要 Registry 来协助完成工作。它们之间的最终选择可能取决于您的操作习惯和环境成本。无论选择哪种方法，**我们都建议在 Git 中维护 KCL 代码，以便更好地实施 GitOps 并获得更好的 IDE 体验和可重用模块**，例如使用 Crossplane AWS Module: *https://github.com/kcl-lang/modules/tree/main/crossplane-provider-aws*

## 小结

现在 function-kcl 项目已捐赠给 Crossplane 社区，我们鼓励整个社区对其进行测试，并尝试使用 KCL（Crossplane Functions 提供的最新高级语言体验）构建云原生控制平面。我们非常欢迎社区在GitHub 上的存储库中提供贡献和反馈。让我们知道您的想法！*https://github.com/crossplane-contrib/function-kcl*

更多其他资源请参考：

- _KCL 网站: https://kcl-lang.io/_
- _KusionStack 网站: https://kusionstack.io/_
- _KCL v0.9.0 Milestone: https://github.com/kcl-lang/kcl/milestone/9_
