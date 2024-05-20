---
sidebar_position: 1
---

# 简介

## KCL 是什么?

[KCL](https://github.com/kcl-lang/kcl) 是一个开源的基于约束的记录及函数语言，作为沙盒项目托管在 CNCF 基金会。KCL 通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

## 为什么使用 KCL?

KCL 期望通过更现代化的声明式配置语言和工具，在轻量级客户端云原生动态配置领域填补配置语言及工具的空白并解决如下问题：

- **维度爆炸**: 大多数静态配置如云原生领域的 Kubernetes YAML 配置需要为每个环境单独进行配置；在最糟糕的情况下，它可能引入涉及环境交叉链接的难以调试的错误，稳定性和扩展性都较差。
- **配置漂移**: 对于不同环境的静态管理应用程序和基础设施配置的方式，往往没有标准的方式去管理这些动态的不同环境的配置，采用非标准化的方法比如脚本和胶水代码的拼盘，会导致复杂度呈指数增长，并导致配置漂移。
- **认知负担**: Kubernetes 等作为构建平台的平台技术手段在底层统一基础架构细节方面出色，但是缺乏更上层的应用软件交付抽象，对于普通开发者认知负担较高，影响了更上层应用开发者的软件交付体验。

针对如上问题，KCL 期望提供如下能力:

- 通过**代码抽象**等手段屏蔽基础设施和平台的细节和复杂性，降低研发者**认知负担**
- **编辑**和**校验**已有的存量配置或模版，直接解决云原生小配置场景问题如 Helm Chart 配置硬编码问题，但远不止如此
- 通过配置语言无副作用地**管理跨团队的大规模配置数据**，提升团队协作效率

具体来说，KCL 可以

- 在代码层面提升**配置语义验证**的能力，比如 Schema 定义、字段可选/必选、类型、范围等配置检查校验能力
- 提供**配置分块编写、组合和抽象**的能力，比如结构定义、结构继承、约束定义和配置策略合并等能力
- 用**现代编程语言**的方式以**编写代码**的方式提升配置的灵活度，比如条件语句、循环、函数、包管理等特性提升配置重用的能力
- 提供**完备的工具链支持**，丰富的 IDE 插件、语言和生态工具链支持用以降低上手门槛，提升使用体验
- 通过**包管理工具** 和 **OCI 注册表**使得配置以更简单的方式在不同团队/角色之间分享，传播和交付
- 提供**高性能**的编译器满足规模化配置场景诉求，比如满足由一份基线配置根据部署上下文生成不同环境不同拓扑的配置的渲染性能以及配置自动化修改性能诉求
- 通过**多语言 SDK，KCL 语言插件**等手段提升其**自动化集成**能力，在发挥配置及策略编写价值的同时显著降低 KCL 的学习成本

![](/img/docs/user_docs/intro/kcl-overview.png)

除了语言自身，KCL 还提供了许多额外的工具如格式化，测试、文档、包管理等工具帮助您使用、理解和检查编写的配置或策略；通过 VS Code 等 IDE 插件和 Playground 降低配置编写、分享的成本；通过 Rust, Go, 和 Python 多语言 SDK 自动化地管理和执行配置。

KCL 本身提供了与其他语言、格式和云原生工具的许多集成。例如，我们可以使用 KCL 验证工具来验证terraform plan 文件, JSON/YAML 等格式，并使用导入工具从 terraform provider schema 和Kubernetes CRD 等直接生成 KCL Schema。此外得益于统一 [KRM KCL 规范](https://github.com/kcl-lang/krm-kcl)，KCL 提供了几乎所有您所知道的云原生工具的集成。

KCL 是一种现代高级领域编程语言，并且它是一种编译静态的强类型语言。KCL 为开发人员提供了通过记录和函数语言设计将**配置（config）**、**建模抽象（schema）**、**逻辑（lambda）**和**策略（rule）**作为核心能力。

![](/img/docs/user_docs/intro/kcl-concepts.png)

KCL 试图提供独立于运行时的可编程性，不在本地提供线程和 IO 等系统功能，并试图为解决领域问题并提供稳定、安全、低噪声、低副作用、易于自动化和易于管理的编程支持。通过不可变性、纯函数和属性运算符等语言特性，您可以在配置可扩展性和安全性方面获得一个良好的平衡。

总之，KCL 具备如下特点:

- **简单易用**：源于 Python、Golang 等高级语言，采纳函数式编程语言特性，低副作用
- **设计良好**：独立的 Spec 驱动的语法、语义、运行时和系统库设计
- **快速建模**：以 [Schema](https://kcl-lang.io/docs/reference/lang/tour#schema) 为中心的配置类型及模块化抽象
- **功能完备**：基于 [Config](https://kcl-lang.io/docs/reference/lang/tour#config-operations)、[Schema](https://kcl-lang.io/docs/reference/lang/tour#schema)、[Lambda](https://kcl-lang.io/docs/reference/lang/tour#function)、[Rule](https://kcl-lang.io/docs/reference/lang/tour#rule) 的配置及其模型、逻辑和策略编写
- **可靠稳定**：依赖[静态类型系统](https://kcl-lang.io/docs/reference/lang/tour/#type-system)、[约束](https://kcl-lang.io/docs/reference/lang/tour/#validation)和[自定义规则](https://kcl-lang.io/docs/reference/lang/tour#rule)的配置稳定性
- **强可扩展**：通过独立配置块[自动合并机制](https://kcl-lang.io/docs/reference/lang/tour/#-operators-1)保证配置编写的高可扩展性
- **易自动化**：[CRUD APIs](https://kcl-lang.io/docs/reference/lang/tour/#kcl-cli-variable-override)，[多语言 SDK](https://kcl-lang.io/docs/reference/xlang-api/overview)，[语言插件](https://github.com/kcl-lang/kcl-plugin) 构成的梯度自动化方案
- **极致性能**：使用 Rust & C，[LLVM](https://llvm.org/) 实现，支持编译到本地代码和 [WASM](https://webassembly.org/) 的高性能编译时和运行时
- **API 亲和**：原生支持 [OpenAPI](https://github.com/kcl-lang/kcl-openapi)、 Kubernetes CRD， Kubernetes YAML 等 API 生态规范
- **开发友好**：[语言工具](https://kcl-lang.io/docs/tools/cli/kcl/) (Format，Lint，Test，Vet，Doc 等)、 [IDE 插件](https://github.com/kcl-lang/vscode-kcl) 构建良好的研发体验
- **安全可控**：面向领域，不原生提供线程、IO 等系统级功能，低噪音，低安全风险，易维护，易治理
- **多语言 SDK**：[Go](https://kcl-lang.io/docs/reference/xlang-api/go-api)，[Python](https://kcl-lang.io/docs/reference/xlang-api/python-api)，[Java](https://kcl-lang.io/docs/reference/xlang-api/java-api) 和 [REST API](https://kcl-lang.io/docs/reference/xlang-api/rest-api) 满足不同场景和应用使用需求
- **生态集成**：通过 [Kustomize KCL 插件](https://github.com/kcl-lang/kustomize-kcl), [Helm KCL 插件](https://github.com/kcl-lang/helm-kcl), [KPT KCL SDK](https://github.com/kcl-lang/kpt-kcl-sdk), [Kubectl KCL 插件](https://github.com/kcl-lang/kubectl-kcl) 或者 [Crossplane KCL 函数](https://github.com/kcl-lang/crossplane-kcl) 分离数据和逻辑，并直接编辑或校验资源
- **生产可用**：广泛应用在蚂蚁集团平台工程及自动化的生产环境实践中

虽然 KCL 不是通用语言，但它有相应的应用场景。开发人员可以通过 KCL 编写**config**、**schema**、**function**和**rule**，其中 config 用于定义数据，schema 用于描述数据的模型定义，rule 用于验证数据，schema 和 rule 还可以组合使用模型和约束来充分描述数据。此外，还可以使用 KCL 中的 lambda 纯函数来组织数据代码，封装通用代码，并在需要时直接调用它。

KCL 配置通常遵循如下模式：

$$
k op (T) v
$$

其中，$k$ 是属性名称，$v$ 是属性值，$op$ 是属性运算符，$T$ 是类型注解。由于 KCL 具有类型推导的能力，因此 $T$ 通常可以省略。比如 `deploy = Deployment {}` 就是一个符合该模式的简单示例。

下面是一个用 KCL 生成 Kubernetes 资源的例子

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = name
}
spec = {
    replicas = 3
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "${metadata.name}:1.14.2"
            ports = [{ containerPort = 80 }]
        }
    ]
}
```

我们可以使用上述 KCL 代码生成一个 Kubernetes YAML 配置

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

## 如何选择

目前社区已经进行了大量的尝试来改进其配置技术，主要可分为三类：

- 用于模板、修补和验证的基于低级数据格式的工具，使用外部工具来增强重用和验证。
- 领域特定语言（DSL）和配置语言（CL），以增强语言能力。
- 基于通用语言（GPL）的解决方案，使用 GPL 的云开发工具包（CDK）或框架来定义配置。

简单的选择答案：

- 如果您需要编写结构化的静态的 K-V，或使用 Kubernetes 原生的技术工具，建议选择 YAML。
- 如果您希望引入编程语言便利性以消除文本(如 YAML、JSON) 模板，有良好的可读性，或者你已是 Terraform 的用户，建议选择 HCL。
- 如果您希望引入类型功能提升稳定性，维护可扩展的配置文件，建议选择 CUE。
- 如果您希望以现代语言方式编写复杂类型和建模，维护可扩展的配置文件，原生的纯函数和策略，和生产级的性能和自动化，建议直接选择 KCL 或将 KCL 用于对已有配置手段或工具进行增强。

### vs. YAML/JSON

YAML/JSON 适用于小型配置场景。对于需要频繁修改的大型云原生配置场景，它们更适合 KCL。所涉及的主要区别是配置数据抽象和部署之间的区别：

使用 KCL 进行配置的优点是：对于静态数据，抽象一层的优点意味着整个系统具有部署灵活性。不同的配置环境、租户和运行时可能对静态数据有不同的要求，甚至不同的组织可能有不同的规范和产品要求。KCL 可用于公开最需要的和经常修改的配置。

### vs. Jsonnet/GCL

GCL 是一种用 Python 实现的声明式配置语言，它提供了支持模板抽象的必要语言功能。然而 GCL 编译器本身是用Python编写的，且语言本身是解释执行的。对于大型模板实例（如 kubernetes 模型），性能较差。

Jsonnet 是一种用 C++ 实现的数据模板语言，适用于应用程序和工具开发人员，可以生成配置数据并通过代码组织、简化和管理大型配置，而不会产生副作用。

Jsonnet 和 GCL 非常擅长减少样板。它们都可以使用代码生成配置，就像工程师只需要编写高级 GPL 代码，而不是手动编写容易出错且难以理解的服务器二进制代码一样。Jsonnet 减少了 GCL 的一些复杂性，但在很大程度上属于同一类别。两者都有许多运行时错误，类型检查和约束能力不足。

### vs. HCL

HCL 是一种 Go 实现的结构化配置语言。HCL 的原生语法受到 libucl 和 nginx 配置的启发。它用于创建一种对人类和机器友好的结构化配置语言，作为 [Terraform 语言](https://www.terraform.io/language)主要用于 DevOps工具、服务器配置和资源配置等。

HCL 的用户界面不能通过 Terraform Provider Schema 定义直接感知。此外，在编写复杂对象和必需/可选字段定义时，用户界面很麻烦。动态参数受变量的条件字段约束。资源本身的约束需要由提供程序模式定义，或者与 Sentinel/Rego 和其他策略语言相结合。语言本身的完整性不能自我封闭，其实现方法也不统一。

### vs. CUE

CUE 可以通过结构、无继承和其他特性用作建模，当模型定义之间没有冲突时可以实现高度抽象。因为 CUE 在运行时执行所有约束检查，所以它在大规模配置建模场景中可能存在性能瓶颈。CUE 将类型和值组合为一个概念，并通过各种语法简化了约束的编写。例如，不需要泛型类型和枚举，求和类型和空值合并是一回事。CUE 支持配置合并，但它是完全幂等的。它可能无法满足复杂的多租户和多环境配置场景的要求。对于复杂的循环和约束场景，编写起来很复杂，编写需要精确配置修改或者 Patch 的场景也很麻烦。

对于 KCL，建模是通过 KCL Schema 进行的，通过语言级工程和一些面向对象的特性（如单一继承、Mixin 复用）可以实现高模型抽象。KCL 是一种静态编译语言，用于大规模建模场景是运行时开销较低 (性能更高，更低的内存消耗)。KCL 提供了更丰富的检查声明性约束语法，这使得配置和策略编写更加容易。对于一些配置字段组合约束，它更容易编写（与 CUE 相比，KCL 提供了更多的 if-guard 组合约束、all/any/map/filter 表达式和其他集合约束编写方法，这使得编写更容易）。

### vs. Dhall

Dhall 是一种可编程配置语言，它组合了 JSON、函数、类型和 imports 导入等功能, 本身风格偏向函数式，如果您学过 Haskell 等函数式风格语言，可能会对它感到熟悉的。相比于 Dhall, KCL 也提供了类似功能的组合，提供给用户配置可编程和抽象的能力，不过 KCL 在建模、约束检查、自动化等方面做了更多的改进，同时能够通过包管理手段进行模型共享。此外，KCL 的语法语义更贴近于面向对象语言，在一定程度上会比纯函数式风格接受程度更高。

### vs. Nickel

Nickel 是一种简单的配置语言。它的目的是自动生成静态配置文件，本质上是带有函数和类型的 JSON。

KCL 和 Nickel 都有类似的渐进式类型系统（静态+动态）、合并策略、函数和约束定义。不同之处在于 KCL 是一种类似 Python 的语言，而 Nickel 是一种类似 JSON 的函数式语言。此外，KCL 提供了 schema 关键字来区分配置定义和配置数据，以避免混合使用。

### vs. Starlark

Starlark 主要用作 Bazel 的配置语言并且是 Python 的一种方言。它没有类型，并且禁止递归。

KCL 一定程度上也可以看作 Python 的变种，但是它极大地增强了静态类型和配置扩展性相关的设计，并且是一个编译型语言，这与 Starlark 有着本质的不同。

### vs. Pkl

Pkl 是一门配置即代码语言，它具有可编程、可扩展和安全的特性。

KCL 和 Pkl 之间有一些相似之处：

- 语言特征：Schema 定义、验证、不变性等。
- 多语言绑定，KCL 为 Python、Go 和 Java 语言等提供了绑定，Pkl 也提供了诸如 Java, Swift 和 Kotlin 等语言绑定。
- 支持多种 IDE 插件：NeoVim、VS Code等。

不同的是，KCL 提供了更多与云原生工具和模型代码库更多的集成。

### vs. Kustomize

Kustomize 的核心功能是其文件级覆盖功能。但是它存在多个覆盖链的问题，因为找到特定属性值的语句不能保证它是最终值，因为其他地方出现的另一个特定值可以覆盖它。对于复杂的场景，Kustomize 文件的继承链的检索通常不如 KCL 代码的继承链检索方便，需要仔细考虑指定的配置文件覆盖顺序。此外，Kustomize 无法解决 YAML 配置编写、约束验证、模型抽象和开发等问题，更适合于简单的配置场景。

在 KCL 中，配置合并操作可以对代码中的每个配置属性进行细粒度处理，合并策略可以灵活设置，而不限于整体资源，配置之间的依赖关系可以通过KCL的import语句进行静态分析。

### vs. Helm

Helm 的概念源于操作系统的包管理机制。它是一个基于模板化 YAML 文件的包管理工具，支持包中资源的执行和管理。

KCL 自然提供了 Helm 功能的超集以及 Helm KCL 插件，因此您可以直接使用 KCL 作为替代。对于采用 Helm 的用户，KCL 中的堆栈编译结果可以打包并以 Helm 格式使用，通过 kpm 包管理工具进行分发复用。此外，我们还可以直接使用 Helm-KCL 插件直接对已有的 Helm Charts 进行无侵入的可编程扩展。

### vs. CDK

用 CDK 的高级语言编写可以很好地集成到应用程序项目中，这实际上是客户端运行时的一部分。对于 KCL，由 KCL 编写的外部配置和策略与客户端运行时分离。

通用语言通常远远超出了需要解决的问题，例如安全问腿、能力边界问题（启动本地线程、访问 IO、网络、代码无限循环和其他安全风险）。例如，在音乐领域，有专门的音符来表达音乐，这便于学习和交流，它不能用一般语言表达清楚。

此外，由于通用语言风格多样，需要统一维护、管理和自动化。通用语言通常用于编写客户端运行时，它是服务器运行时的延续，不适合编写独立于运行时的配置，被编译成二进制文件，并最终从进程开始运行。此外，GPL 稳定性和可扩展性不易控制。然而，KCL 配置语言通常用于编写数据，将数据与简单逻辑相结合，它描述了预期的最终结果，然后由编译器或引擎使用，既具备丰富的编程抽象能力，又具备方便的数据处理方式。此外，KCL 是声明式且结构化的，我们可以使用 KCL 的自动化 API 来对 KCL 代码本身进行修改和查询。

### vs. OPA/Rego

Rego 起源于逻辑编程，它基于 Datalog，是一种受限制的 Prolog 形式，而 KCL 基于静态类型结构，具备部分 OOP 特性。Rego 是一种优秀的查询语言。但对于约束强制执行，它有点麻烦，因为实际上首先需要查询要应用约束的值才能进行校验。此外，Rego 本身不具备定义 Schema 的能力，您可以在需要时在 Rego 的注释中引入 JsonSchema 定义。

此外，KCL 的方法更易于找到规范化、简化、面向人类易读，面向运行时性能优良的约束和校验表示，具备静态类型，并且它更适合于从 OpenAPI 生成或者创建 OpenAPI。
