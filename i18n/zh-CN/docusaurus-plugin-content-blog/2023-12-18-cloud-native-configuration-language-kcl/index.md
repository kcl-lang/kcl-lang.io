---
slug: 2023-12-18-cloud-native-configuration-language-kcl
title: KCD 社区会议回顾 | 云原生策略配置语言 KCL
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Meeting]
---

> KusionStack 负责人李大元和云原生策略配置语言 KCL 项目的 Maintainer 宗喆在 2023 年 CNCF KCD 深圳会议的内容回顾，本文章主要是 KCL 语言部分演讲的内容回顾，活动链接: [https://community.cncf.io/events/details/cncf-kcd-hangzhou-presents-kcd-shenzhen-2023/](https://community.cncf.io/events/details/cncf-kcd-shenzhen-presents-kcd-shenzhen-2023/)

## 云原生时代，基础设施代码化是开发者体验的核心

在当今快速发展的技术世界中，基础设施代码化（IaC）已成为自动化和管理云资源的关键，IaC 也成为了开发者体验的核心部分，带来了便利和效率的同时，但它也带来了一系列挑战。

![intro-iac.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/intro-iac.png)

首先，普通的应用开发者需要面对k8s提供的复杂的基础设施和平台概念，这造成了较高的认知负担，影响了更上层应用开发者的软件交付体验。
同时，对于一些不同的动态环境下的配置管理，目前工业界缺少一套成熟标准的管理办法，往往依赖于一线人员的专业素养，采用非标准化的方法比如脚本和胶水代码的方式进行配置管理，会导致项目变得越来越复杂，难于维护并且引入了配置漂移的风险。
因此，我们迫切需要一种能够减轻开发者认知负担、提供高效动态配置管理，并且通过标准的配置测试与验证手段来保证可靠性的配置管理方式，来确保基础设施既的高效与安全。

##  KCL 云原生策略配置语言

于是，我们尝试设计了一种新的配置语言 KCL ，通过在语言语法的设计和周边工具的增强来解决上文中提到诸多问题。

![intro-kcl.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/intro-kcl.png)

KCL 语言针对前面提到的**动态配置管理**， **配置可靠性的验证与测试**和**降低开发者认知负担**的三个方面出发。提出三个主要的设计理念，**Mutation**， **Validation** 和 **Abstraction** ，我们也将这三个设计理念作为了 KCL 核心的 slogan 展示在 KCL 官网的首页。

围绕着三个设计理念，KCL 在语言语法上做了一些设计：
- 要使用 KCL 做动态的配置管理，语言侧就需要提供诸如流程控制，lambda表达式等能够描述程序行为的语法。
- 要做配置可靠性相关的验证与测试：就要通过强类型系统，assert，check 等语法，赋予这个语言能够检查配置内容的能力，来支持测试和验证过程。
- 降低开发者认知负担和开发成本：KCL 提供了 Schema 模型对数据结构进行抽象，对于开发者来说屏蔽非必要字段，并且通过包管理机制提供丰富的三方库资源，降低开发者直接编写模型的编写成本。

## KCL 语言特性

这个提到的一些语言特性的展示，我在 ppt 中列了一些小的能够反映语言特性的代码片段：

![kcl-feature.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-feature.png)

首先，最左面的图中展示的是与通用编程语言相近的流程控制，lambda 表达式的，python 风格的循环表达式。然后，中间的图中展示的是针对验证和测试过程提供的 assert 语句，schema 的 check 块，通过check 中的编写的策略可以对 Schema 中的字段进行检查。最后最右面的图是使用 Schema 定义数据结构，并且实例化配置。并且大家可以看到，在这个例子中，也已经展示出 KCL 的强类型系统对于配置类型的校验功能，如果在使用 Schema 实例化配置的过程中，某个字段类型写错了，在编译阶段，就会排查出错误。最后一张图是使用了k8s 的三方库，创建了一个 nginx 的 pod，一些不必要的字段已经被屏蔽掉了，应用开发人员只需要填充少数字段就可以完成配置的编写。

## KCL & KRM & 动态配置管理

为了解决前面提到的三个问题，KCL 提供了提到的一些动态行为，check，assert语句，类型系统，Schema 抽象等等特性。但是，当我们尝试利用上述特性进行配置管理的时候，我们发现，KCL 的语言特性仅仅作用于 KCL 语言本身是不够的。想要解决 IaC 领域的问题，就必须要考虑到存量配置，将存量配置全部推倒用 KCL 重新很明显不是一个合适的方式，也无法实现。
因此，**对于存量的一些配置，我们除了在语言机制上下功夫之外，还需要具备与社区生态集成的能力，能够将 KCL 语言特性的作用也发挥在其他的配置语言上, 使得 KCL 能够真正的解决 IaC 领域的问题**，在尽可能减少对存量配置的改动下，充分发挥 KCL 语言特性的作用，解决前面提到的动态配置，可靠性校验和降低开发者心智负担的问题。

![kcl-krm.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-krm.png)

于是，我们提出了 [KCL KRM 规范](https://github.com/kcl-lang/krm-kcl)，基于这个规范，我们可以借助 KCL 语言的能力，对 KRM 中的资源进行动态配置，模型校验和抽象。

## KCL 生态集成

基于 KCL & KRM 规范我们开发了一些周边工具来使 KCL 能够更好的与周边工具生态进行集成。

![kcl-integration.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-integration.png)

- 数据结构的导入导出：KCL 提供了如 import/export 工具，支持使用 KCL 从 JsonSchema，Terraform 等导入/导出数据结构，以减少在开发过程中对于数据重复建模的过程，使 KCL 的特性能够更加直接的作用于存量配置。	
- 提供了如 kubectl, kustomize, helm/helmfile 等工具的 KCL 插件，用户可以针对不同的场景选择合适场景的引擎比如 Kubectl, KusionStack, KubeVela 或 Helmfile 等来和 KCL 结合将配置生效到集群。
- 开发了 [KCL Operator](https://github.com/kcl-lang/kcl-operator) 与Kubernetes 集成，在运行时实现配置自动修改，无需重复开发Kubernetes Webhook 编写大量的配置处理逻辑。

KCL 建立在一个完全开放的云原生世界当中，KCL 几乎不与任何编排/引擎工具强绑定在一起，可同时为客户端或者运行时提供 API 抽象、组合和校验的能力。

## KCL 周边工具

虽然 KCL 是一个领域语言。KCL 也提供了与通用编程语言语言能力基本等同的的工具链，如格式化，测试、文档、包管理等工具帮助更好地编写、理解和检查编写的配置或策略；通过 VS Code 等 IDE 插件和 Playground 降低配置编写、分享的成本；通过 Rust, Go, 和 Python 多语言 SDK 自动化地管理和执行配置。
对于 IDE 插件，KCL 目前主要提供了 VS Code，IntelliJ 和 NeoVim三种 IDE 插件基于同样的 KCL Language Server 实现了同样的补全、跳转、悬停、代码重构和格式化等能力。

![kcl-tools.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-tools.png)

## **Artifacthub & KCL**

我们与 ArtifactHub 进行了集成，将 Artifacthub 作为 KCL 的模型市场，提供了超过 200 + 的 KCL 模型，涵盖配置编辑，校验和模型抽象等多个方面。大家如果有兴趣的话，可以来看看是否有你感兴趣的模型，或者如果您有好的想法想要与大家分享，您也可以将您的 KCL 包贡献在 ArtifactHub 中。

![kcl-ah.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-ah.png)

## 实践案例

接下来一些简单的案例，展示一些 KCL 的使用过程。

![kcl-mut.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-mut.png)

首先，如果在集群中安装了 KCL Operator，那么就可以通过左面的配置文件对右面的配置进行 mutation 操作，通过在 source 字段中用 KCL 编写行为代码，动态的为右面的配置文件中增加了 annotation。

![kcl-vet.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-vet.png)

然后，这个案例中展示了使用 KCL 提供的配置验证工具 kcl-vet 对 terraform plan 生成的配置内容进行验证。

![kcl-abs.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-abs.png)

最后这个案例中，展示了 abstraction 的内容，可以通过直接编写 KCL 程序，或者使用 KCL & KRM 的方式编写配置，然后编译成对应的 Kubernetes manifests。

## 总结

KCL 语言是一个专注于云原生配置管理的领域语言，它提供了一系列的语言特性，如强类型系统，Schema 抽象，流程控制，lambda 表达式，assert 语句，check 语句等等，来解决云原生配置管理领域的问题，如动态配置管理，配置可靠性的验证与测试，降低开发者认知负担等等。同时，KCL 也提供了一系列的周边工具，如 IDE 插件，ArtifactHub 集成，KCL Operator 等等，来提升开发者的开发体验，降低开发成本。

## 其他资源

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KCL GitHub 仓库](https://github.com/kcl-lang/)
- [KusionStack 网站](https://kusionstack.io/)
- [KusionStack GitHub 仓库](https://github.com/KusionStack/)
