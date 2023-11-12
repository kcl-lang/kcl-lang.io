---
slug: 2023-09-06-dcm-using-kcl
title: "动态配置管理新范式: KRM KCL 规范"
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Kubernetes Resource Model, Dynamic Configuration Management]
---

## 前言

> 随着云原生技术的发展，我们更多地转向云基础设施，Kubernetes 和 Terraform 等 IaC 工具已成为越来越流行的管理和部署基于云 API 的应用程序的工具。但是随之而来衍生出的复杂性问题和认知负担问题在近几年达到了高峰。

![cognitive-loading](/img/blog/2023-09-08-dcm-using-kcl/cognitive-loading.png)

Kubernetes 和云 API 越来越复杂的原因主要有以下几点：

+ **不断增加的功能和能力**：Kubernetes 和云 API 都是为了应对不断增长的应用需求和云计算的发展而不断演进。为了满足用户的需求，它们不断引入新的功能和能力，如自动扩展、服务发现、负载均衡、权限管理等。这些新功能的引入增加了系统的复杂性。虽然我们已经有了各式各样的自动化手段，随着时间的推移，因为不同资源类型的数量、这些资源类型的潜在设置数量以及这些资源类型之间的复杂关系呈指数级增长
+ **复杂的配置和管理需求**：随着应用规模的增长，配置和管理 Kubernetes 和云 API 变得越来越复杂。例如，需要管理大量的容器实例和资源、配置复杂的网络和存储、实现高可用性和负载均衡，需要针对不同的环境和拓扑重复的进行配置等。这些复杂的配置和管理需求增加了 Kubernetes 和云 API 的复杂性，开玩笑的说甚至在 Kubernetes 领域常常伴随催生了一批 YAML 工程师。

尽管 Kubernetes 和云 API 的复杂性愈发增加，但它们提供了强大的功能和灵活性，可以帮助组织更好地管理和扩展其应用程序。通过使用适当的工具、工程实践和方法，可以减轻这种复杂性，并更有效地利用这些技术来满足业务需求。动态配置管理技术便是其中之一可以一定程度帮助解决 Kubernetes 和云 API 的复杂性。

## 什么是动态配置管理

我们遵循动态配置管理的创建者 Chris Stephenson 的[原始定义](https://humanitec.com/blog/what-is-dynamic-configuration-management)并进行一定程度的延伸

> 动态配置管理（DCM）是一种用于构建计算工作负载配置的方法。开发人员创建工作负载规范，描述成功运行工作负载所需的一切。该规范用于动态创建配置，以便在特定环境中部署工作负载。使用 DCM，开发人员不需要为其工作负载定义或维护任何特定于环境的配置。

动态配置管理意味着开发人员以**抽象的**、**与环境无关**的方式描述他们的工作负载与资源的关系。他们描述这种关系的格式称为**工作负载规范**或者**以应用为中心的规范**。该规范是通用的并且跨环境工作，这意味着它没有提供足够的信息来配置工作负载和资源本身。为了获得可以执行的配置，我们需要将规范应用于配置基线（对于应用程序和基础设施配置），并根据部署的上下文生成它们。对于开发人员来说，动态配置管理需要提供开发者可以理解的以应用为中心的配置界面；对于平台工程师来说，动态配置管理可以帮助定义如何处理配置资源和工作负载规范；这有助于提高组织的一致性和合规性。它还使得提供自助式内部开发者平台 (IDP) 变得更加容易。

与动态配置管理相对应的方式是静态配置管理，静态配置会带来一系列问题

+ **维度爆炸**: 大多数静态配置需要为每个环境单独进行配置；在最糟糕的情况下，它可能引入涉及环境交叉链接的难以调试的错误，稳定性和扩展性都较差。
+ **配置漂移**: 对于不同环境的静态管理应用程序和基础设施配置的方式，往往没有标准的方式去管理这些动态的不同环境的配置，采用非标准化的方法会导致复杂度呈指数增长，并导致配置漂移。

## 为什么需要一种新范式

正如记录音乐有五线谱，存储时间序列数据有时序数据库一样，在平台工程的特定问题域内，一批配置和策略语言用于编写和管理规模化复杂配置及策略。不同于混合编写范式、混合工程能力的高级通用语言，这类专用语言的核心逻辑是以收敛的有限的语法、语义集合解决领域问题近乎无限的变化和复杂性，将复杂配置和策略编写思路和方式沉淀到语言特性中。

对于云 API, 我们借助 Terraform 等 IaC 工具可以获得大量的已经编写好的 Module 配置，但是对于 Kubernetes 仍然缺乏客户端的轻量级的配置组合和抽象解决方案，现有的方案或者规范难以在抽象能力和扩展性获得平衡，甚至对于一些极端场景，开发者往往编写许多胶水代码和脚本对配置进行处理逻辑，稳定性和效率都受到一定桎梏。比如 Helm Chart 等工具虽然提供了模版编程方式，但编程体验和效率均不佳，此外当用户需要动态调整 Helm Chart 的 `values.yaml` 参数依赖或者遇到需要设置的参数上游的 Helm Chart 不支持时，往往需要以侵入的方式 Fork 维护上游 Helm Chart 或者辅以 Kustomize 等工具，这带来的额外的维护成本和复杂性。

于是我们思考需要有一个统一规范描述来同时承载配置语言能力，并且可以尽可能无副作用地同时满足规模化配置场景下的稳定性、扩展性、效率等特性，并且解决静态配置管理的问题

+ **抽象和组合能力**：通过可编程 Schema 的方式提供给平台人员屏蔽底层底层基础设施细节和平台，并提供给开发人员一个更好更稳定的 API 抽象。
+ **稳定性**：通过语言内置开箱提供的稳定特性如规则编写，静态类型等特性，使得风险尽可能左移，在 VCS 中编写实时发现错误，可审计可追溯可回滚，易于自动化。
+ **可复用扩展性**：就像应用软件供应链那样，应当将基础设施配置也视为软件供应链中的一环，用户可以通过标准的方式分发复用配置，对于常用的配置用户可以在开源世界中轻易获得它，对于内部平台，我们可以轻易编写和扩展配置代码。
+ **高性能**：由于动态配置管理提倡由一份基线配置根据部署上下文生成不同环境不同拓扑的配置，对于配置代码本身的执行渲染性能有较高的要求，开发者通常不希望花费数十分钟才看到真实配置输出而影响软件迭代升级的效率

## KRM KCL 规范

[KRM KCL 规范](https://github.com/kcl-lang/krm-kcl)是基于 Kubernetes Resource Model（KRM）的一种配置规范。KRM 是一个通用的配置模型，用于描述和管理各种云原生资源，如容器、Pod、服务等。KRM 提供了一种统一的方式来定义和管理这些资源，使得它们可以在不同的环境中进行移植和复用。它建立在一个完全开放的 Kubernetes 世界当中，几乎不与任何编排/引擎工具或者 Kubernetes 控制器绑定，它在关注点分离的基础上允许平台人员扩展自己的抽象，配置编辑和验证逻辑，并且对于社区中已有的模型抽象如 Open Application Model (OAM) 等，可以直接进行复用，因为 OAM 配置本身也满足 KRM 规范。

[KCL 配置语言](https://github.com/kcl-lang)是 KRM KCL 规范 的核心组成部分。KCL 是一种声明性的配置语言，它允许用户描述应用程序的配置需求，并将其与底层基础设施进行关联。KCL 具有丰富的语法和语义，可以灵活地描述各种配置需求，如环境变量、资源限制、依赖关系等。KCL 旨在通过定义 API 抽象来隐藏基础设施和平台的详细信息，以减轻负担，并通过配置语言无副作用地管理跨团队的大规模配置，并提供编写、组合和抽象配置块的能力，如结构定义、约束和逻辑等。在平台工程实践中 KCL 不是一种仅用于编写 K-V 对的语言，而是一种面向平台工程领域的专用语言

KRM KCL 规范的另一个重要特性是其对动态配置管理的支持。传统的配置管理工具往往依赖于静态配置文件，需要手动修改和部署。而 KRM KCL 规范天然提供了配置自动修改的方式，可以单独在客户端使用也可以通过 [KCL Operator](https://github.com/kcl-lang/kcl-operator) 与 Kubernetes 集成，在运行时实现配置自动修改，无需重复开发 Kubernetes Webhook 编写大量的配置处理逻辑。

除了动态配置管理，KRM KCL 规范 还具有一些其他的优势。首先，它基于 Kubernetes，可以与现有的 Kubernetes 生态系统进行无缝集成。其次，KRM KCL 规范提供了丰富的工具和库，使得开发人员可以轻松地创建、测试和维护配置。最后，KRM KCL 规范采用了开放的标准，可以与其他的配置管理工具如 Kubectl, Helm, Kustomize 等进行互操作，并且具备如下特点

+ **声明式**：配置描述以代码方式抽象和组织，用户可以通过编辑器或 IDE 查看、编辑，代码中清晰描述了资源、服务、网络等多方面的配置。
+ **面向终态**：面向终态且实现无关，通过高度抽象并内置特定领域的基础能力，具象的业务由使用者编写声明。使用者通过统一的描述代码和 GitOps 流程避免人工操作及私有脚本的非统一模式和引入的安全问题。
+ **稳定性**：任何配置代码的修改都可能造成非预期的结果，甚至异常或故障发生。结合版本控制和语言本身的稳定性特性。不同版本的配置代码可以通过 Git 按需切换，可审计性，以满足研发、测试、生产阶段的需求，如异常后回滚到某个验证可用的版本。结合版本控制的代码化可以有效避免配置漂移。
+ **可复用扩展**：配置代码往往有 “一次编写，多次使用” 的特点，结合动态参数化的配置代码往往使差异环境、差异用户等多维度的配置复用需求变得简单。通过与 OCI 等标准软件供应链的方式集成，将配置代码与业务代码同等对待，更好地实现基础设施即代码 (IaC)

总而言之，KRM KCL 规范是一种全新的动态配置管理范式，它以 KRM 和 KCL 为基础，为现代软件开发提供了更高效、更可靠的配置解决方案。它的动态配置管理能力、灵活的语法和语义以及与 Kubernetes 的集成，无论是在云原生应用开发还是在微服务架构中，KRM KCL 规范都将为开发人员带来更好的配置管理体验。

## 如何使用 KRM KCL 规范

![krm-kcl-form](/img/blog/2023-09-08-dcm-using-kcl/krm-kcl-form.png)

在 KRM KCL 规范，我们将 KCL 配置模型的行为主要分成三类

+ **Mutation**: 输入 KCL 参数 `params` 和 KRM 列表并输出修改后 KRM 列表。
+ **Validation**: 输入 KCL 参数 `params` 和 KRM 列表并输出 KRM 列表和资源验证结果。
+ **Abstraction**: 输入 KCL 参数 `params` 并输出 KRM 列表

我们可以使用 KCL 以可编程的方式实现如下能力:

+ 使用 KCL 对资源进行修改，如根据某个条件添加/修改 label 标签或 annotation 注释或在包含 PodTemplate 的所有 Kubernetes Resource Model (KRM) 资源中注入 Sidecar 容器配置等。
+ 使用 KCL Schema 验证所有 KRM 资源，如约束只能以 Root 方式启动容器等。
+ 使用抽象模型生成 KRM 资源或者对不同的 KRM API 进行组合并使用。

此外配置模型 `source` 可以引用自 OCI，Git, Filesystem, 和原始 KCL 代码，我们可以借助 KCL IDE 和 KPM 包管理工具编写模型并上传到 OCI Registry 以实现模型复用，并且这些模型可以根据场景需求分别用在客户端或者运行时。

### 客户端

我们以一个经典的工作负载 Web 服务作为例子演示 KRM KCL 规范在客户端使用的例子。

此外，我们以统一的编程界面方式为 Kubernetes 社区的 Kubectl, Helm, Kustomize, KPT 等配置管理工具提供了插件支持，编写几行配置代码即可无侵入地完成对存量 Kustomize YAML，Helm Charts 的编辑和校验以及定义自己的抽象模型并分享复用。

下面以 Kubectl 工具对 KCL 的集成为例进行详细说明。您可以在[这里](https://github.com/kcl-lang/kubectl-kcl)获取 Kubectl KCL 插件的安装方式

首先执行如下命令获取一个配置示例

```shell
git clone https://github.com/kcl-lang/kubectl-kcl.git && cd ./kubectl-kcl/examples/
```

然后执行如下命令显示配置

```shell
$ cat krm-kcl-abstraction.yaml

apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: web-service
spec:
  params:
    name: app
    containers:
      nginx:
        image: nginx
        ports:
        - containerPort: 80
    service:
      ports:
      - port: 80
  source: oci://ghcr.io/kcl-lang/web-service
```

在上述配置中，我们使用了在 OCI 上已经预定好的一个 Kubernetes Web 服务应用抽象模型 `oci://ghcr.io/kcl-lang/web-service`, 并通过 `params` 字段配置了该模型所需的配置字段。通过执行如下命令可以获得原始的 Kubernetes YAML 输出并下发到集群:

```shell
$ kubectl kcl apply -f krm-kcl-abstraction.yaml

deployment.apps/app created
service/app created
```

除了使用 YAML 作为用户的输入界面，KCL 作为一个编写配置和策略的 DSL，它还允许开发者和平台人员在客户端以统一的 KCL 编写方式编写和维护大规模配置

![standalone-kcl-form](/img/blog/2023-09-08-dcm-using-kcl/standalone-kcl-form.png)

### 运行时

在运行时，我们通过 KCL Operator 提供了 Kubernetes 集群集成，允许您在将资源应用到集群时使用 Access Webhook 根据 KCL 配置生成、变异或验证资源。Webhook 将捕获创建、应用和编辑操作，并通过 `KCLRun` 在与每个操作关联的配置上执行资源。使用 KCL Operator, 通过几个步骤您就可以在 Kubernetes 集群内部以很轻量的方式地通过 KCL 代码自动化地完成资源配置的管理和安全验证，无需重复开发 Webhook Server 在运行时动态修改和验证配置。

此外借助 KCL 良好的建模和抽象能力，我们可以为不同的资源 API 定义进行功能抽象/组合并以 KCL Schema 的形式对外透出，并且可以由 KCL Schema 进一步自动生成 OpenAPI Schema 定义供集群其他客户端调用，而无需为 API 抽象/组合手动维护复杂的 OpenAPI Schema 定义。

下面以一个简单的资源 annotation 注解修改示例介绍 KCL Operator 的使用方式

安装 KCL Operator

```shell
kubectl apply -f https://raw.githubusercontent.com/kcl-lang/kcl-operator/main/config/all.yaml
```

使用以下命令观察并等待 pod 状态为 `Running`。

```shell
kubectl get po
```

部署注解修改模型

```shell
kubectl apply -f- << EOF
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
spec:
  params:
    annotations:
      managed-by: kcl-operator
  source: oci://ghcr.io/kcl-lang/set-annotation
EOF
```

部署一个 Pod 资源验证模型结果

```shell
kubectl apply -f- << EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  annotations:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
EOF
kubectl get po nginx -o yaml | grep kcl-operator
```

我们可以看到如下输出

```shell
    managed-by: kcl-operator
```

可以发现 Nginx Pod 上自动添加了 managed-by=kcl-operator 注解

## 小结

通过动态配置管理的方式可以降低现代云原生配置的复杂性，通过 KRM KCL 规范以及标准的 OCI 模型，我们可以实现动态配置管理，并使平台人员和应用开发人员都可以轻松地使用这些设置，降低认知负担。

## 更多资源

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)

## 参考

+ Declarative Application Management in Kubernetes: https://docs.google.com/document/d/1cLPGweVEYrVqQvBLJg6sxV-TrE5Rm2MNOBA_cxZP2WU/edit#
+ CNCF Platforms White Paper: https://tag-app-delivery.cncf.io/whitepapers/platforms/
+ Google SRE Workbook: https://sre.google/workbook/configuration-specifics/
+ What is Dynamic Configuration Management: https://humanitec.com/blog/what-is-dynamic-configuration-management
+ Implementing Dynamic Configuration Management with Score and Humanitec: https://humanitec.com/blog/implementing-dynamic-configuration-management-with-score-and-humanitec
+ What is Platform Engineering: https://platformengineering.org/blog/what-is-platform-engineering
+ What is Internal Developer Platform: https://internaldeveloperplatform.org/what-is-an-internal-developer-platform/
+ What Team Structure is Right for DevOps to Flourish: https://web.devopstopologies.com/#anti-types
