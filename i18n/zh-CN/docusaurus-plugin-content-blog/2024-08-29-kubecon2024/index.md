---
slug: 2024-08-29-kubecon2024
title: kubecon HK 2024 会议回顾
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

# kubecon 2024 活动回顾

2024 年 8 月 21 日至 23 日，为期 3 日的 KubeCon + CloudNativeCon + Open Source Summit + AI_dev China 2024 大会在香港圆满落幕。期间，众多国内外社区领袖和技术专家，共同带来了超过 140 场精彩的演讲，分享了他们在各自领域的深刻洞察和宝贵经验。KCL 社区也在这次活动中与来自各个社区的小伙伴们进行了交流与分享。

## Lighting Talk: KCL: Simplifying Kubernetes Manifests Management

Lighting Talk PPT: [下载 PDF](https://kcl-lang.io/talks/kcl-kubecon2024-lighting-talk.pdf)

![pptcover](/img/blog/2024-08-29-kubecon2024/pptcover.png)

在这次活动中，KCL 通过一场 Lighting Talk 为大家介绍了 KCL 在简化 kubernetes 项目配置管理，提升配置管理效率和稳定性方面作出的努力。

![kcllightingtalk](/img/blog/2024-08-29-kubecon2024/kcllightingtalk.png)

KCL 作为一种 IaC 领域的领域特定语言(DSL)，主要解决 IaC 领域中常见的**配置规模爆炸，认知成本过高，缺乏有效的动态配置管理，配置可靠性保证**等问题，并且能够轻松的与社区生态进行集成。

为了有效的降低配置规模，KCL 提供了 **Schema 用来抽象通用的配置结构**，**借助包管理机制支持可重用结构的分发和复用**。并且，KCL 通过**多文件的同名配置合并**能够将一份配置中的内容分隔在不同文件中编写，对不同的配置开发人员屏蔽不必要的陌生概念，降低开发人员的认知负担。同时，作为一个语言项目，**丰富的工具链和功能强大 IDE** 也极大程度上提高了开发人员开发体验。

![ppt1](/img/blog/2024-08-29-kubecon2024/ppt1.png)

KCL 支持动态配置管理，提供了**声明式**和**命令式**两种方式。开发者既可以通过 **if/for/lambda 等表达式** 在代码中编写命令式的代码生成配置。

![ppt2](/img/blog/2024-08-29-kubecon2024/ppt2.png)

也可以通过 **声明式的配置合并/覆盖运算符** 对不同的配置块和配置字段进行合并与覆盖。

![ppt3](/img/blog/2024-08-29-kubecon2024/ppt3.png)

KCL 通过**类型系统**，**测试**和**规则校验**三板斧来提高配置的可靠性。KCL 作为一种**类型安全的配置语言**，能够在编译阶段提前暴露大量类型错误，开发者在 IDE 中就能够得到错误提示。

![ppt4](/img/blog/2024-08-29-kubecon2024/ppt4.png)
![ppt5](/img/blog/2024-08-29-kubecon2024/ppt5.png)

同时，最简单也**最有效的软件可靠性保证的方法“测试”**，在 KCL 中也得到了支持，你可以通过 lambda 编写为配置内容编写单元测试。

![ppt6](/img/blog/2024-08-29-kubecon2024/ppt6.png)
![ppt7](/img/blog/2024-08-29-kubecon2024/ppt7.png)

最后，**编写验证规则对配置内容进行检查**一直是 IaC 领域一个常见的议题，KCL 支持通过**Assert/Check/Rule**等特性编写对应的配置校验规则对配置内容进行检查。

![ppt8](/img/blog/2024-08-29-kubecon2024/ppt8.png)

KCL 提供了 12 种语言的 SDK，支持与大多数项目进行集成；并且支持通过插件机制扩展 KCL 语言的能力。KCL 还提供了 KCL-Operator 支持通过 KCL 语言校验，更新和生成 kubernetes 集群中的资源。借助上述能力，KCL 能够轻松的与 Crossplane，ArgoCD 等社区工具完成集成。

## KCL & Crossplane 一次令人开心的线下交流

在这次 kubecon 活动中，KCL 也与 Crossplane 社区的伙伴进行了交流，来自 Crossplane 社区伙伴也为我们带来了精彩的分享。

Crossplane 是一个开源项目，旨在为云原生应用程序提供基础设施即代码的能力。它允许开发者和运维团队以与 Kubernetes 相似的方式管理各种云资源，支持多云环境和混合云架构。

![crossplaneppt1](/img/blog/2024-08-29-kubecon2024/crossplaneppt1.png)

在这次分享中，Crossplane 在演讲中提到了关于在软件开发的生命周期中尽早暴露问题的重要性。

![crossplaneppt2](/img/blog/2024-08-29-kubecon2024/crossplaneppt2.png)

Crossplane 在介绍他们保证配置可靠性的过程中也提到了如何使用 KCL 来提升配置的可靠性。

![crossplaneppt3](/img/blog/2024-08-29-kubecon2024/crossplaneppt3.png)

通过 KCL 来为配置编写对应的测试用例，以尽早暴露配置中出现的问题。

![crossplaneppt4](/img/blog/2024-08-29-kubecon2024/crossplaneppt4.png)

KCL 和 kusionstack 社区也同 crossplane 社区的同时进行了令人开心的线下沟通，也期待后续能够展开更加深入的合作。

![photo](/img/blog/2024-08-29-kubecon2024/photo.png)

## 其他资源

感谢所有 KCL 用户在此次版本更新过程中提出的宝贵的反馈与建议。更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [Kusion 网站](https://kusionstack.io/)
- [KCL Github 仓库](https://github.com/kcl-lang/kcl)
- [Kusion Github 仓库](https://github.com/KusionStack/kusion)
- [Konfig Github 仓库](https://github.com/KusionStack/konfig)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/kcl-lang/community](https://github.com/kcl-lang/community)