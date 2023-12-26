---
slug: 2023-12-25-ten-ways-for-kubernetes-config-management
title: 10 种 Kubernetes 声明式配置管理的方式
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Configuration, Landscape]
---

![](/img/blog/2023-12-25-ten-ways-for-kubernetes-config-management/cover.png)

Kubernetes 已经成为管理容器化应用程序的事实标准，但随着其普及，管理其配置的复杂性也随之增加。为了应对这种复杂性，Kubernetes 声明式配置管理模型应运而生，以简化这一流程。在本文中，我们将探讨什么是 Kubernetes 声明式配置，为什么它是必需的，以及可以通过哪些不同的方式来管理它。

## 什么是 Kubernetes 声明式配置

Kubernetes 声明式配置是指在 Kubernetes 清单文件中声明应用程序及其资源所期望的状态的做法，与其发布命令式指令来改变集群的状态，不如简单地描述预期的状态，让 Kubernetes 去努力使实际状态与声明的状态相匹配。具体来说，在声明式 API 中，你描述你想要的“什么”（例如，我想要一个运行特定镜像的 Pod），而不是你想要进行的一系列操作来实现某个目标状态（即“如何”实现）。这种模型简化了系统交互，因为用户只需关注最终目标，而不必处理达到该目标的具体步骤。

Kubernetes 的声明式 API 通常是通过 YAML 或 JSON 格式的清单（Manifests）文件来使用的。这些文件定义了 Kubernetes 资源（如 Pods, Services, Deployments, ConfigMaps 等）的期望状态。用户将这些清单文件提交给 Kubernetes API 服务器，然后 Kubernetes 的控制平面组件（如控制器和调度器）负责实施这些规范，并确保集群的实际状态与这些规范相匹配。

声明式 API 支持版本控制、自动化部署、回滚、扩展和自我修复等特性，这大大提升了管理大规模、分布式系统的能力。例如，如果你想要部署一个应用程序，你不必告诉 Kubernetes 如何创建每一个 Pod、如何调度它们到节点上，或者如何管理它们的生命周期。相反，你只需要创建一个如 Deployment 这样的资源对象，定义你想要的副本数（replicas）和应用程序容器的其他属性，然后交给 Kubernetes 来处理。Kubernetes 会监控这个 Deployment 的状态，并采取必要的措施来维护或恢复期望的状态。

这种声明式模型提高了系统的抽象层次，使开发者和运维人员能够专注于应用程序本身的行为和需求，而不是底层的运维命令和过程。随着组织采用 Kubernetes 来大规模部署应用程序，管理复杂的配置和清单变得至关重要。

## Kubernetes 声明式配置管理的方式有哪些

### 结构化 (Structured) 的 KV

结构化的 KV 可以满足最小化数据声明需求，比如数字、字符串、列表和字典等数据类型，并且随着云原生技术快速发展应用，声明式 API 可以满足 X as Data 发展的诉求，并且面向机器可读可写，面向人类可读。其优劣如下:

- 优势
  - 语法简单，易于编写和阅读
  - 多语言 API 丰富
  - 有各种 Path 工具方便数据查询，如 XPath, JsonPath 等
- 痛点
  - 冗余信息多：当配置规模较大时，维护和阅读配置很困难，因为重要的配置信息被淹没在了大量不相关的重复细节中
  - 功能性不足
    - 约束校验能力
    - 复杂逻辑编写能力
    - 测试、调试能力
    - 不易抽象和复用
    - Kustomize 的 Patch 比较定制，基本是通过固定几种 Patch Merge 策略

结构化 KV 的代表技术有

- JSON/YAML：非常方便阅读，以及自动化处理，不同的语言均具有丰富的 API 支持。
- [Kustomize](https://kustomize.io/)：提供了一种无需**模板**和 **DSL** 即可自定义 Kubernetes 资源基础配置和差异化配置的解决方案，本身不解决约束的问题，需要配合大量的额外工具进行约束检查如 [Kube-linter](https://github.com/stackrox/kube-linter)、[Checkov](https://github.com/bridgecrewio/checkov) 和 [kubescape](https://github.com/kubescape/kubescape) 等检查工具。

### 模版化 (Templated) 的 KV

模版化 (Templated) 的 KV 赋予静态配置数据动态参数的能力，可以做到一份模版+动态参数输出不同的静态配置数据。其优劣如下:

- 优势
  - 简单的配置逻辑，循环支持
  - 支持外部动态参数输入模版
- 痛点
  - 容易落入所有配置参数都是模版参数的陷阱
  - 当配置规模变大时，开发者和工具都难以维护和分析它们

模版化代表技术有:

- [Helm](https://helm.sh/)：Kubernetes 资源的包管理工具，通过配置模版管理 Kubernetes 资源配置。

### 代码化 (Programmable) 的 KV

Configuration as Code (CaC), 使用代码产生配置，就像工程师们只需要写高级 GPL 代码，而不是手工编写容易出错而且难以理解的服务器二进制代码一样。配置变更同代码变更同样严肃地对待，同样可以执行单元测试、集成测试等。代码模块化和重用是维护配置代码比手动编辑 JSON/YAML 等配置文件更容易的一个关键原因。其优劣如下:

- 优势
  - 必要的编程能力（变量定义、逻辑判断、循环、断言等）
  - 代码模块化与抽象（支持定义数据模版，并用模版得到新的配置数据）
  - 可以抽象配置模版+并使用配置覆盖
- 痛点
  - 类型检查不足
  - 运行时错误
  - 约束能力不足

代码化 KV 的代表技术有:

- [GCL](https://github.com/rix0rrr/gcl)：一种 Python 实现的声明式配置编程语言，提供了必要的言能力支持模版抽象，但编译器本身是 Python 编写，且语言本身是解释执行，对于大的模版实例 (比如 K8s 型) 性能较差。
- [HCL](https://github.com/hashicorp/hcl)：一种 Go 实现结构化配置语言，原生语法受到 libuclnginx 配置等的启发，用于创建对人类和机器都友好的结构化配置语言，主要针对 devops 工具、服务器配置及 Terraform 中定义资源配置等。除此之外，可以使用 Terraform 以及 Terraform Kubernetes Provider 等来管理 Kubernetes 资源。
- [Jsonnet](https://github.com/google/jsonnet)：一种 C++ 实现的数据模板语言，适用于应用程序工具开发人员，可以生成配置数据并且无副作用组织、简化、统一管理庞大的配置。
- [OPA](https://github.com/open-policy-agent/opa)：虽然是一种开源通用策略引擎，可在整个堆栈中实现统一的、上下文感知的策略实施。但是 OPA 可以接受 JSON 等数据进行输入并输出 JSON 等数据格式，实际上也可以作为配置生成或者配置修改工具使用，但是本身没有提供开箱的 Schema 定义支持，但是可以引入 JsonSchema 定义。
- [Starlark](https://github.com/bazelbuild/starlark)：Starlark 是一种受 Python 启发的构建转换描述语言，但具有适合嵌入到如 Bazel 这样的软件中的特性。它可以用于配置生成，因为它具有确定性评估和表达复杂构建转换的能力。
- [CEL](https://kubernetes.io/docs/reference/using-api/cel/)：CEL 是一种旨在简单、快速、可移植和安全的表达式语言。虽然它并不直接是一种配置语言，但 Kubernetes 使用 CEL 作为其 API 中复杂字段选择和过滤操作的基础。CEL 可以作为一种基于特定表达式验证和约束配置的工具。

### 类型化 (Typed) 的 KV

类型化的 KV，基于代码化 KV，多了类型检查和约束的能力，其优劣如下:

- 优势
  - 配置合并完全幂等，天然防止配置冲突
  - 丰富的配置约束语法用于编写约束
  - 将类型和值约束编写抽象为同一种形式，编写简单
  - 配置顺序无关
- 痛点
  - 图合并和幂等合并等概念复杂，用户理解成本较高
  - 类型和值混合定义提高抽象程度的同时提升了用户的理解成本，并且所有约束在运行时进行检查，大规模配置代码下有性能瓶颈
  - 对于想要配置覆盖、修改的多租户、多环境场景难以实现
  - 对于带条件的约束场景，定义和校验混合定义编写用户界面不友好

类型化 KV 的代表技术有:

- [CUE](https://github.com/cue-lang/cue)：CUE 解决的核心问题是“类型检查”，主要应用于配置约束校验场景及简单的云原生配置场景
- [Dhall](https://github.com/dhall-lang/dhall-lang)：Dhall 是一种可编程配置语言，它组合了 JSON、函数、类型和 imports 导入等功能, 本身风格偏向函数式，如果您学过 haskell 等函数式风格语言，可能会对它感到熟悉的。

### 模型化 (Modeled) 的 KV

模型化的 KV 在代码化和类型化 KV 的基础上以高级语言建模能力为核心描述，期望做到模型的快速编写与分发，其优劣如下:

- 优势
  - 引入可分块、可扩展的 KV 配置块编写方式
  - 类高级编程语言的编写、测试方式
  - 语言内置的强校验、强约束支持
  - 面向人类可读可写，面向机器部分可读可写
- 不足
  - 扩展新模型及生态构建需要一定的研发成本，或者使用工具对社区中已有的 JsonSchema 和 OpenAPI 模型进行模型转换、迁移和集成，通过包管理工具和 Registry 等。

模型化 KV 的代表技术有:

- [KCL](https://github.com/kcl-lang/kcl)：一种 Rust 实现的声明式配置策略编程语言，把运维类研发统一为一种声明式的代码编写，可以针对差异化应用交付场景抽象出用户模型并添加相应的约束能力，期望借助可编程 DevOps 理念解决规模化运维场景中的配置策略编写的效率和可扩展性等问题。
- [Nickel](https://github.com/tweag/nickel)：Nickel 是一种简单的配置语言。它的目的是自动生成静态配置文件，本质上是带有函数和类型的 JSON。

此外，KCL 和 Nickel 都有类似的渐进式类型系统（静态+动态）、合并策略、函数和约束定义。不同之处在于 KCL 是一种类似 Python 的语言，而 Nickel 是一种类似 JSON 的语言。此外，KCL 提供了 schema 关键字来区分配置定义和配置数据，以避免混合使用。此外使用 KCL 和 KCL 的模型库还可以与 [KusionStack](https://www.kusionstack.io/), [KubeVela](https://kubevela.net/) 等引擎更好地集成。

### 通用语言和 CDKs

除了使用 DSL 来定义 Kubernetes 资源，我们还可以使用通用语言来定义。不过通用语言一般是 Overkill 的，即远远超过了需要解决的问题，通用语言存在各式各样的安全问题，比如能力边界问题 (启动本地线程、访问 IO, 网络，代码死循环等不安全隐患)，比如像音乐领域就有专门的音符去表示音乐，方便学习与交流，不是一般文字语言可以表述清楚的。

此外，通用语言因为本身就样式繁多，存在统一维护、管理和自动化的成本，通用语言一般用来编写客户端运行时，是服务端运行时的一个延续，不适合编写与运行时无关的配置，最终被编译为二进制从进程启动，稳定性和扩展性不好控制，而配置语言往往编写的是数据，再搭配以简单的逻辑，描述的是期望的最终结果，然后由编译器或者引擎来消费这个期望结果。

通用语言和 CDK 的代表技术有:

- [Pulumi](https://www.pulumi.com/docs/)：Pulumi 允许使用常见的编程语言（如 TypeScript, Python, Go, 和 .NET 等）来编写代码，定义和部署云基础设施以及应用服务。当然 Pulumi 也支持使用 YAML 或者可以编译为 YAML 的 DSL 如 KCL 等。
- [CDK8s](https://cdk8s.io/)：CDK8s 可以用于定义Kubernetes资源和应用程序。CDK8s 使用一种称为构造（constructs）的高级抽象概念来表示Kubernetes的各种资源，例如部署、服务和配置。开发人员可以使用 TypeScript、Python和Java等编程语言来编写代码，CDK8s 会将这些代码转换为标准的Kubernetes YAML清单，这些清单可以直接应用到Kubernetes集群上。

### 结构化和代码化混合型 KV

有些工具虽然常用方式是定义结构化 KV 来实现配置管理，但是仍然提供了额外的扩展方式来应对复杂的场景，消除更多 YAML 模版。比如一些云原生工具提供了函数扩展方式，这些函数可以使用 Go, Typescript 等通用语言或者 KCL 等 DSL 来实现。

- [KPT](https://kpt.dev/)：使用 KPT 和 KPT Function 可以解耦数据和逻辑定义，以 Git 仓库作为配置源的真实来源，通过声明式方式管理 Kubernetes 配置的同时不失扩展性。
- [Kustomize](https://kustomize.io/)：类似 KPT，使用 Kustomize 和 Kustomize Function 也可以解耦数据和逻辑定义。
- [Crossplane](https://www.crossplane.io/)：使用 Crossplane 和 Crossplane Composite Function 解耦 XR 和 Composite 资源定义。XR 复合资源允许开发人员创建更高级别的抽象，这些抽象可以封装和组合多个不同类型的云资源（可能跨越不同的云提供商和服务）。使用 Crossplane Composite Function 渲染这些抽象能够很好为不同的供应商资源提供循环或者条件等功能提升模版能力的同时地减少 YAML 代码编写量。

### Operators 和 Kubernetes CRDs

Kubernetes 提供了 Mutation Webhook 和 Validation Webhook 可以在运行时修改或验证 Kubernetes 资源对象在被持久化之前的请求。

Operators 和 Kubernetes CRDs 的代表技术有

- [KubeVela](https://kubevela.io/docs/)：KubeVela 是一个现代化的应用交付系统，它基于 Open Application Model（OAM）规范构建，为开发者和运维团队提供了一套简化和统一的方式来部署、管理和运维应用。
- [Crossplane](https://www.crossplane.io/)：Crossplane 是一个开源的多云控制平面，它在 Kubernetes 上提供了基础设施即代码的能力。Crossplane 允许你定义 XRD 和 XR 来管理和组合云资源（如数据库、存储和计算资源）直接从 Kubernetes API。
- [KCL Operator](https://github.com/kcl-lang/kcl-operator)：KCL Operator 基于 KCL 语言在运行时为 Kubernetes 资源配置带来编程能力，使用 DSL 的灵活性来避免繁琐的 Webhook 的开发并接入 KCL 已有的[生态模型](https://github.com/kcl-lang/modules)。

### GitOps 工具

GitOps 是一种使用 Git 作为真实来源的系统管理方法，它将应用程序部署和基础设施配置的声明性描述存储在 Git 仓库中。GitOps 工具通常提供了自动化的连续部署能力，并确保 Kubernetes 集群的实时状态匹配 Git 仓库中的配置。通常 GitOps 工具都原生提供或者通过插件支持与各种 Kubernetes 配置定义方式进行集成 (结构化，模版化，代码化 KV 等如 Kustomize, Helm, Jsonnet, KCL 等)

GitOps 的代表技术有

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)：ArgoCD 是一个声明性的、GitOps 持续交付工具，用于自动化 Kubernetes 配置、监控和管理。它通过追踪配置信息在 Git 仓库中的变化来自动部署和更新应用程序和配置。ArgoCD 提供了可视化的界面以及详尽的控制和安全性特性，它支持多种配置管理工具，如 Helm、Kustomize、Jsonnet 等。
- [FluxCD](https://fluxcd.io/)：FluxCD 是另一款流行的 GitOps 工具，它也允许开发人员以 Git 仓库作为单一的配置源。Flux 自动确保 Kubernetes 集群的状态与 Git 仓库中的配置同步。它支持自动更新，这意味着 Flux 可以监控 Docker 镜像仓库的新镜像，并将更新推送到集群中。

### Infra from Code (IfC) 工具

Infra from Code (IfC) 是一种管理基础设施的方法，类似于 IaC (Infrastructure as Code)，它通过代码来定义和管理底层基础设施，通常通过代码意图推导的形式而不是显式定义基础设施代码。

- [Winglang](https://github.com/winglang/wing)：Winglang 是面向云的新的编程语言，将基础设施和运行时代码结合在一种语言中，并同时支持 AWS, Kubernetes 多种构建目标。此外，Winglang 还提供了直接操作容器和 Helm Chart 配置的内置库。
- [Plutolang](https://github.com/pluto-lang/pluto)：Pluto 是一种新型开源编程语言，旨在帮助开发者编写云应用程序，降低云服务的使用难度。开发者可以根据业务需求，在代码中直接使用所需资源，例如 KV 数据库、消息队列等。Pluto 通过**静态分析代码**获取应用依赖的基础设施资源拓扑，并在指定的云平台或者 Kubernetes 上部署相应的资源实例和应用程序。

### 总结

每种管理方式都有其特定的优势和用途。对于简单的项目，可能只需要使用原生的 Kubernetes YAML 文件和 ConfigMaps。对于需要更强大的模板功能和包管理的复杂项目，可以选择 Helm 或 Kustomize。如果你需要以编程方式处理配置或需要将 Kubernetes 集成到更广泛的云基础设施管理中，那么像 Terraform 和 Pulumi 这样的 IaC 工具或者 KCL 和 CUE 等 DSL 来描述可能更加适合。

GitOps 工具提供了一种以 Git 为核心的持续部署方法。而 Operators 和 CRDs 则允许用户定制扩展 Kubernetes 本身的功能，以适应特定应用的需求。这些管理方式不是相互排斥的，实际上，在实际的配置管理工作中，它们往往是互补的，团队可以根据具体需求选择和组合最适合自己的工具和方法。

除此之外，您还知道怎样的方式? 欢迎补充。❤️

## 参考

- Terraform Language: [https://www.terraform.io/language](https://www.terraform.io/language)
- Terraform Kubernetes Provider: [https://github.com/hashicorp/terraform-provider-kubernetes](https://github.com/hashicorp/terraform-provider-kubernetes)
- Terraform Provider AWS: [https://github.com/hashicorp/terraform-provider-aws](https://github.com/hashicorp/terraform-provider-aws)
- Pulumi: [https://www.pulumi.com/docs/](https://www.pulumi.com/docs/)
- Pulumi vs. Terraform: [https://www.pulumi.com/docs/intro/vs/terraform/](https://www.pulumi.com/docs/intro/vs/terraform/)
- Google SRE Work Book Configuration Design: [https://sre.google/workbook/configuration-design/](https://sre.google/workbook/configuration-design/)
- Google Borg Paper: [https://storage.googleapis.com/pub-tools-public-publication-data/pdf/43438.pdf](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/43438.pdf)
- Holistic Configuration Management at Facebook: [https://sigops.org/s/conferences/sosp/2015/current/2015-Monterey/printable/008-tang.pdf](https://sigops.org/s/conferences/sosp/2015/current/2015-Monterey/printable/008-tang.pdf)
- JSON Spec: [https://www.json.org/json-en.html](https://www.json.org/json-en.html)
- YAML Spec: [https://yaml.org/spec/](https://yaml.org/spec/)
- GCL: [https://github.com/rix0rrr/gcl](https://github.com/rix0rrr/gcl)
- HCL: [https://github.com/hashicorp/hcl](https://github.com/hashicorp/hcl)
- CUE: [https://github.com/cue-lang/cue](https://github.com/cue-lang/cue)
- KCL: [https://github.com/kcl-lang/kcl](https://github.com/kcl-lang/kcl)
- Nickel: [https://github.com/tweag/nickel](https://github.com/tweag/nickel)
- Jsonnet: [https://github.com/google/jsonnet](https://github.com/google/jsonnet)
- Dhall: [https://github.com/dhall-lang/dhall-lang](https://github.com/dhall-lang/dhall-lang)
- Starlark: [https://github.com/bazelbuild/starlark](https://github.com/bazelbuild/starlark)
- CEL: [https://kubernetes.io/docs/reference/using-api/cel/](https://kubernetes.io/docs/reference/using-api/cel/)
- Thrift: [https://github.com/Thriftpy/thriftpy2](https://github.com/Thriftpy/thriftpy2)
- Kustomize: [https://kustomize.io/](https://kustomize.io/)
- KPT: [https://kpt.dev/](https://kpt.dev/)
- Kube-linter: [https://github.com/stackrox/kube-linter](https://github.com/stackrox/kube-linter)
- Checkov: [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- How Terraform Works: A Visual Intro: [https://betterprogramming.pub/how-terraform-works-a-visual-intro-6328cddbe067](https://betterprogramming.pub/how-terraform-works-a-visual-intro-6328cddbe067)
- How Terraform Works: Modules Illustrated: [https://awstip.com/terraform-modules-illustrate-26cbc48be83a](https://awstip.com/terraform-modules-illustrate-26cbc48be83a)
- TFLint: [https://github.com/terraform-linters/tflint](https://github.com/terraform-linters/tflint)
- Helm: [https://helm.sh/](https://helm.sh/)
- Helm vs. Kustomize: [https://harness.io/blog/helm-vs-kustomize](https://harness.io/blog/helm-vs-kustomize)
- KubeVela: [https://kubevela.io/docs/](https://kubevela.io/docs/)
- KusionStack: [https://kusionstack.io](https://kusionstack.io)
- Crossplane: [https://www.crossplane.io/](https://www.crossplane.io/)
- ArgoCD: [https://argo-cd.readthedocs.io/en/stable/](https://argo-cd.readthedocs.io/en/stable/)
- FluxCD: [https://fluxcd.io/](https://fluxcd.io/)
- Helmfile: [https://helmfile.readthedocs.io/en/latest/](https://helmfile.readthedocs.io/en/latest/)
- CDK8s: [https://cdk8s.io/](https://cdk8s.io/)
- [Helm vs. Kustomize in Kubernetes](https://medium.com/@sushantkapare1717/helm-vs-kustomize-in-kubernetes-cc063bbb4b0e)
- Winglang: [https://github.com/winglang/wing](https://github.com/winglang/wing)
- Plutolang: [https://github.com/pluto-lang/pluto](https://github.com/pluto-lang/pluto)
- [Infrastructure as Code Landscape in 2023](https://blog.terramate.io/infrastructure-as-code-landscape-in-2023-e2dad4fb87d3)
