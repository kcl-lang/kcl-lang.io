---
slug: 2023-10-23-cloud-native-supply-chain-krm-kcl-spec
title: KCD 社区会议回顾 | 基于云原生供应链的配置策略管理新范式 - KRM KCL 规范
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Meeting]
---

> 本篇文章是 2023 年 CNCF KCD 杭州会议 KCL 演讲部分内容回顾，活动链接: [https://community.cncf.io/events/details/cncf-kcd-hangzhou-presents-kcd-hangzhou-2023/](https://community.cncf.io/events/details/cncf-kcd-hangzhou-presents-kcd-hangzhou-2023/)

## 背景

> 随着云原生技术的发展，我们更多地转向云基础设施，Kubernetes 和 Terraform 等基础设施即代码 (IaC) 工具已成为越来越流行的管理和部署基于云 API 的应用程序的工具。但是随之而来衍生出的复杂性问题和认知负担问题在近几年达到了高峰。

![cognitive-loading](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/cognitive-loading.png)

对于 Kubernetes，作为使用最广泛的容器编排系统，Gartner 预测，到 2022 年，全球超过 75% 的组织将在生产中运行容器化应用程序。如今，容器管理市场估计约为 3 亿美元，预计到 2025 年将突破 10 亿美元，并且 Kubernetes 正稳步走出麻烦的低谷，走向成熟和更广泛的采用<sup>[1]</sup>。

对于 Terraform，作为使用最广泛的 IaC 工具，截止本文撰写时，Terraform VS Code 插件安装量有 3.2M 左右，相当于 Go VS Code 插件安装量的三分之一 (10M 左右)，甚至超过很多通用编程语言的安装量，比如 Rust VS Code 插件在 2.3M 左右, 并且 HCL 是 GitHub 2022 年度增长最快的编程语言，超过了其他所有通用编程语言和领域编程语言，形成了广泛的研发者生态<sup>[2]</sup>。

由此可以看出，Kubernetes 和 Terraform 正在成为云原生领域中不可或缺的基础设施项目并且在未来几年将会持续增长，虽然它们两者的项目性质并不完全相同，但是殊途同归，它们正在变得越来越复杂。

![issues](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/issues.png)

Kubernetes 和 Terraform 背后所代表的云 API 越来越复杂的原因主要有以下几点<sup>[3]</sup><sup>[4]</sup><sup>[5]</sup>：

- **不断增加的功能和能力**：Kubernetes 和云 API 都是为了应对不断增长的应用需求和云计算的发展而不断演进。为了满足用户的需求，它们不断引入新的功能和能力，如自动扩展、服务发现、负载均衡、权限管理等。这些新功能的引入增加了系统的复杂性。虽然我们已经有了各式各样的自动化手段，随着时间的推移，因为不同资源类型的数量、这些资源类型的潜在设置数量以及这些资源类型之间的复杂关系呈指数级增长。
- **复杂的配置和管理需求**：随着应用规模的增长，配置和管理 Kubernetes 和云 API 变得越来越复杂。例如，需要管理大量的容器实例和资源、配置复杂的网络和存储、实现高可用性和负载均衡，需要针对不同的环境和拓扑重复地进行配置等。这些复杂的配置和管理需求增加了 Kubernetes 和云 API 的复杂性，开玩笑的说甚至在 Kubernetes 领域常常伴随催生了一批 YAML 工程师或标记语言人肉编辑工程师。

对于云 API, 我们借助 Terraform 等 IaC 工具可以获得大量的已经编写好的 Module 配置和 Provider 等，但是对于 Kubernetes 仍然缺乏客户端的轻量级的配置组合和抽象解决方案，现有的方案或者规范难以在抽象能力和扩展性获得平衡，甚至对于一些极端场景，开发者往往编写许多胶水代码和脚本对配置进行处理逻辑，稳定性和效率都受到一定桎梏。

于是我们思考需要有一个统一规范描述来同时承载配置语言能力，并且可以尽可能无副作用地同时满足云原生供应链和规模化配置等场景下的稳定性、扩展性和效率等特性，减轻基础设施对开发人员的认知负担，提高配置管理效率。

因此，我们提出了 KCL 项目以及 KRM KCL 规范期望通过更现代化的声明式配置语言和工具，在轻量级客户端云原生动态配置领域填补配置语言及工具的空白并解决如下问题：

- **维度爆炸**: 大多数静态配置如云原生领域的 Kubernetes YAML 配置需要为每个环境单独进行配置；在最糟糕的情况下，它可能引入涉及环境交叉链接的难以调试的错误，稳定性和扩展性都较差。
- **配置漂移**: 对于不同环境的静态管理应用程序和基础设施配置的方式，往往没有标准的方式去管理这些动态的不同环境的配置，采用非标准化的方法比如脚本和胶水代码的拼盘，会导致复杂度呈指数增长，并导致配置漂移。
- **认知负担**: Kubernetes 等作为构建平台的平台技术手段在底层统一基础架构细节方面出色，但是缺乏更上层的应用软件交付抽象，对于普通开发者认知负担较高，影响了更上层应用开发者的软件交付体验。

## 概念

![kcl-intro](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/kcl-intro.png)

KCL 是一款面向云原生领域的专用配置策略语言，2022 年 6 月 开源，2023 年 9 月成为 CNCF 基金会托管的 Sandbox 项目，致力于改进编写云原生配置策略和 Kubernetes API 层可编程性编写的用户体验。KCL 项目目前位于 CNCF 基金会全景图 Automation & Configuration Landscape 中，KCL 中的 C 是 Configuration 的缩写，L 是 Language 的缩写，K 取自 Kubernetes 的首字母 K <sup>[6]</sup>。

与通用编程语言不同，KCL 作为一款领域特定的编程语言，是以收敛有限的语法、语义集合解决近乎无限变化的业务场景和复杂性 (比如仅 Kubernetes 领域中就有成千上万种资源以及社区中多到数不清且碎片化的 Operator 生态)，将复杂配置和策略编写思路和方式沉淀到语言特性中，避免使用通用语言等配置带来安全隐患等副作用。

作为一种配置语言，KCL 为应用程序和平台开发人员/SRE 提供的最重要的功能是动态配置管理。通过代码抽象，我们可以构建以应用为中心的模型屏蔽复杂的基础设施和平台概念，为开发人员提供一个以应用程序为中心且易于理解的界面。此外，KCL 还允许平台人员快速扩展和定义自己的模型，并且提供丰富的可管理能力包括开箱即用的 KCL 代码库、语义版本化管理、OCI Registry，语言工具链和自动化支持。

此外，KCL 建立在一个完全开放的云原生世界当中，几乎不与任何编排/引擎工具或者 Kubernetes 控制器绑定，在云原生供应链场景和规模化运维场景中，可同时为客户端和运行时提供 API 抽象、组合和校验的能力，用户可以选择合适场景的引擎比如 Kubectl<sup>[7]</sup>, KusionStack<sup>[8]</sup>, KubeVela<sup>[9]</sup> 或 Helmfile<sup>[10]</sup> 等来和 KCL 结合将配置生效到集群。

![kcl-concept](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/kcl-concept.png)

此外，KCL 语言本身是一种现代化的高级领域编程语言，它是一种编译静态的强类型语言。KCL 为开发人员提供了通过记录和函数语言设计将**配置（config）**、**建模抽象（schema）**、**逻辑（lambda）**和**策略（rule）**作为核心能力。

KCL 试图提供独立于运行时的可编程性，不在本地提供线程和 IO 等系统功能，并试图为解决领域问题并提供稳定、安全、低噪声、低副作用、高性能、易于自动化和易于管理的编程支持。

![krm-kcl](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/krm-kcl.png)

KRM KCL 规范是基于 Kubernetes Resource Model（KRM）的一种配置规范。KRM 是一个通用的配置模型，用于描述和管理各种云原生资源，如容器、Pod、服务等。KRM 提供了一种统一的方式来定义和管理这些资源，使得它们可以在不同的环境中进行移植和复用<sup>[11]</sup>。

KRM 规范作为 Kubernetes 官方的规范之一，其核心概念是 KRM 函数，KRM 函数的输入是一系列 Kubernetes 资源以及 KRM 函数的配置，输出也是一系列 Kubernetes 资源加上函数运行的结果比如报错、调试信息等。而 KRM KCL 是将 KRM Function 使用 KCL 代码实现，并在其基础上扩展了多种代码源支持比如 OCI Registry, Git 和 Https 等。

在 KRM KCL 规范中，我们将 KCL 配置模型的行为主要分成三类

- **Mutation**: 输入 KCL 参数 `params` 和 KRM 列表并输出修改后 KRM 列表。
- **Validation**: 输入 KCL 参数 `params` 和 KRM 列表并输出 KRM 列表和资源验证结果。
- **Abstraction**: 输入 KCL 参数 `params` 并输出 KRM 列表。

我们可以使用 KCL 以可编程的方式实现如下能力:

- 使用 KCL 对资源进行修改，如根据某个条件添加/修改 label 标签或 annotation 注释或在包含 PodTemplate 的所有 Kubernetes Resource Model (KRM) 资源中注入 Sidecar 容器配置等。
- 使用 KCL Schema 验证所有 KRM 资源，如约束只能以 Root 方式启动容器等。
- 使用抽象模型生成 KRM 资源或者对不同的 Kubernetes API 进行抽象/组合并使用，比如使用 `web-service` 模型实例化一个 Web 应用配置。

我们可以借助 KCL IDE 和 KCL 包管理工具编写模型并上传到 OCI Registry 以实现模型复用，对 KRM KCL 规范进行可编程扩展支持，并且这些模型可以根据场景需求分别用在客户端或者运行时。

## 用户体验

针对上述提到到领域中的问题以及 KCL 相关概念，我们主要为用户提供了三方面的支持：语言、工具链、云原生集成。

![workspace](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/workspace.png)

虽然 KCL 是一个领域语言，但是麻雀虽小，五脏俱全。KCL 提供了与通用语言能力基本等同的的工具链如格式化，测试、文档、包管理等工具帮助更好地编写、理解和检查编写的配置或策略；通过 VS Code 等 IDE 插件和 Playground 降低配置编写、分享的成本；通过 Rust, Go, 和 Python 多语言 SDK 自动化地管理和执行配置。

![ide](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/ide.png)

对于 IDE 插件，KCL 目前主要提供了 VS Code，IntelliJ 和 NeoVim 三种 IDE 插件基于同样的 KCL Language Server 实现了同样的补全、跳转、悬停、代码重构和格式化等能力<sup>[12]</sup>。

![integration](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/integration.png)

作为 CNCF 的项目，KCL 还与 CNCF 其他众多生态项目进行了集成，比如为现有的 CNCF 生态配置管理工具项目如 Kubectl, Helm、Kustomize、kpt、helmfile 等提供 KCL 插件，在运行时提供 KCL Kubernetes Operator，以满足不同场景的配置管理需求等。此外我们还提供如下集成支持：

- **多语言支持**：我们提供了多语言 SDK，帮助用户以不同的语言操作 KCL，并将其集成到自己的应用程序中。
- **包管理支持**：我们提供了 KCL 包管理工具可以将配置和策略代码通过 Harbor, Docker Hub, GitHub Packages 等标准的 OCI 供应链方式进行分发和复用。
- **Schema 和数据迁移支持**：我们支持其他生态系统的 Schema 和数据一键迁移到 KCL Schema，如 Go/Rust 结构定义、JsonSchema、Protobuf、OpenAPI、Terraform Provider Schema、JSON 和 YAML 等。

![artifact-hub](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/artifact-hub.png)

![artifact-hub-k8s](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/artifact-hub-k8s.png)

此外，KCL 还支持与 ArtifactHub 的集成，您可以通过向 `kcl-lang/artifacthub` 仓库提交 PR 的方式将您的 KCL 包发布到 ArtifactHub，然后可以在 ArtifactHub 页面看到上传的 KCL 包的效果比如 k8s 包<sup>[13]</sup>。

![registry](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/registry.png)

在此基础上，KCL 提供了许多开箱即用的云原生模型主要涵盖 Kubernetes 和 Terraform 模型，可以通过一行 KCL 命令添加相应的配置模型依赖或者查看 KCL 源代码。

![performance](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/performance.png)

除了与用户直接相关的语言、工具链和云原生集成的外表工作，我们还在 KCL 的稳定性、性能等内在方面做了许多工作。在代码规模较大或者计算量较高的场景情况下 KCL 比 CUE/Jsonnet/HCL 等语言性能更好，且由于 KCL 的渐进式静态类型系统、不可变性、Schema、校验规则等特性，能够进一步保障配置的稳定性。

## 实践

### Kubernetes

KCL 目前聚焦在云原生领域特别是 Kubernetes 场景模型。

![k8s-mutation](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/k8s-mutation.png)

作为云原生领域内的一个小语言，KCL 可以直接被用于解决场景中简单的小问题，如通过 `append-env` 模型直接为 Kubernetes 资源注入环境变量等配置而不是编写脚本，并且这些模型是可以分享复用并且经过了代码测试，在工程性、稳定性和扩展性上均有保障。

![k8s-validation](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/k8s-validation.png)

除了 Kubernetes 配置原地编辑，KCL 还在 Kubernetes 配置校验方面提供了许多开箱即用的模型比如容器服务校验模型、镜像准入模型、Pod Container Policy (PSP) 模型等来解决云原生供应链当中的安全和合规问题。比如可以通过 `disallow-svc-lb` 模型来验证 `Service` 资源中是否错误地设置了 `LoadBalancer` 类型；通过 `https-only` 模型来验证 `Ingress` 资源中是否包含了显示设置为 https 的 label 注解。

相比于其他策略工具或引擎，使用 KCL 的好处是一份校验模型可以同时在客户端和运行时使用，并且可以同时在编程语言界面同时定义 Schema 和约束条件，无需额外配合 OpenAPI Schema 或者 JSON Schema 使用。

![kcl-operator](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/kcl-operator.png)

除了在客户端完成配置的抽象、编辑和校验，KCL 还提供了运行时支持。KCL Operator 提供了 Kubernetes 集群集成，允许在将 Kubernetes 资源应用到集群时使用 Access Webhook 根据 KCL 配置生成、变异或验证资源。Webhook 将捕获创建、应用和编辑操作，并 `KCLRun` 在与每个操作关联的配置上执行资源<sup>[14]</sup>。

使用 KCL Operator, 通过几个步骤就可以在 Kubernetes 集群内部以很轻量的方式地通过 KCL 代码自动化地完成资源配置的管理和安全验证，无需重复开发 Webhook Server 在运行时动态修改和验证配置。

### Terraform

另外一个 KCL 聚焦的场景是 Terraform 的生态模型。

![tf-validation](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/tf-validation.png)

在云原生供应链场景中，除了用户的业务代码，往往也需要验证 IaC 代码的安全性，因此 KCL 也提供了与 Terraform 相关的验证模型。比如图中的示例仅需要编写几行 KCL 代码就可以完成在 AWS 资源组的自动扩缩操作中禁止删除资源的需求<sup>[15]</sup>。

相比于其他策略引擎或工具，KCL 支持一键从 Terraform Provider Schema 转换为 KCL Schema, 可以很好地降低策略编写的难度。

### IaC & GitOps

![gitops](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/gitops.png)

无论是 Kubernetes 模型还是 Terraform 模型，不论是使用独立的 KCL 还是 KRM KCL 配置形式，KCL 都支持与各种以及 CI/CD 和 GitOps 工具的集成，KCL 允许开发人员以声明式的方式定义应用程序所需的资源，通过将 KCL 和 GitOps 工具相结合可以帮助我们更好地实现 IaC，提高部署效率，简化应用程序的配置管理<sup>[16]</sup>。

使用 GitOps，开发人员和运维团队可以通过分别修改应用和配置代码来管理应用程序的部署，GitOps 工具链可以基于 KCL 的自动化能力实现对配置的自动更改，从而实现持续部署并确保一致性。如果出现问题，可以使用 GitOps 工具链快速回滚。

![app-delivery](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/app-delivery.png)

KCL 也可以被用于企业内部与各种 CI/CD 和应用配置交付引擎比如 KusionStack 等相配合，实现关注点分离、以应用为中心的可编程模型界面和 GitOps 流程，以简化当今混合多云环境中规模化应用的部署和运维操作，提升发布运维效率和开发者体验。

![k8s-abstraction](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/k8s-abstraction.png)

此外，使用 KCL 的 Schema 结构和 自动化 API，我们可以在外部系统中集成 KCL 并使用 CLI/API/UI 形式实现对 KCL 配置的自动增删改查，在实现 GitOps & IaC 的基础上，同时为研发人员提供一个良好的配置管理界面，支持以 UI 表单形式实现对 KCL 代码的变更，提升配置管理和应用交付的效率，避免配置漂移等问题。

## 小结

![summary](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/summary.png)

本篇文章主要回顾了 CNCF KCD 社区会议 KCL 演讲内容，讲述了云原生领域特别是 Kubernetes 和 Terraform 生态中遇到的问题以及 KRM KCL 规范的概念、用户体验和实践。

当然，KCL 能够解决的问题和实践的场景远不止如此，受限于本文篇幅，我们后续会陆续分享社区中采用者的最佳实践，也欢迎大家加入我们的社区进行进一步交流和讨论 ❤️。https://github.com/kcl-lang/community

## 其他资源

更多其他资源请参考:

- [KCL 网站](https://kcl-lang.io/)
- [KCL GitHub 仓库](https://github.com/kcl-lang/)
- [KusionStack 网站](https://kusionstack.io/)
- [KusionStack GitHub 仓库](https://github.com/KusionStack/)

## 参考

- [1] Forecast Analysis: Container Management (Software and Services), Worldwide: https://www.gartner.com/en/documents/3985796
- [2] The top programming languages: https://octoverse.github.com/2022/top-programming-languages
- [3] Kubernetes 中的声明式应用管理: [https://docs.google.com/document/d/1cLPGweVEYrVqQvBLJg6sxV-TrE5Rm2MNOBA_cxZP2WU/edit#](https://docs.google.com/document/d/1cLPGweVEYrVqQvBLJg6sxV-TrE5Rm2MNOBA_cxZP2WU/edit#)
- [4] CNCF 平台工程白皮书: [https://tag-app-delivery.cncf.io/whitepapers/platforms/](https://tag-app-delivery.cncf.io/whitepapers/platforms/)
- [5] Google SRE 工作手册: [https://sre.google/workbook/configuration-specifics/](https://sre.google/workbook/configuration-specifics/)
- [6] KCL 官方网站: [https://kcl-lang.io/](https://kcl-lang.io/)
- [7] Kubectl: [https://kubernetes.io/docs/reference/kubectl/](https://kubernetes.io/docs/reference/kubectl/)
- [8] KusionStack: [https://kusionstack.io](https://kusionstack.io)
- [9] KubeVela: [https://kubevela.net](https://kubevela.net)
- [10] Helmfile: [https://github.com/helmfile/helmfile](https://github.com/helmfile/helmfile)
- [11] KRM KCL 规范: [https://github.com/kcl-lang/krm-kcl](https://github.com/kcl-lang/krm-kcl)
- [12] KCL IDE 插件: [https://kcl-lang.io/docs/tools/Ide/](https://kcl-lang.io/docs/tools/Ide/)
- [13] ArtifactHub KCL 集成: [https://artifacthub.io/](https://artifacthub.io/)
- [14] KCL Operator: [https://github.com/kcl-lang/kcl-operator](https://github.com/kcl-lang/kcl-operator)
- [15] Terraform KCL 策略代码化: [https://kcl-lang.io/docs/user_docs/guides/working-with-terraform/validation](https://kcl-lang.io/docs/user_docs/guides/[]working-with-terraform/validation)
- [16] 使用 KCL 进行 GitOps: [https://kcl-lang.io/docs/user_docs/guides/gitops/gitops-quick-start](https://kcl-lang.io/docs/user_docs/guides/gitops/gitops-quick-start)
