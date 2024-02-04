---
slug: 2024-01-04-biweekly-newsletter
title: KCL 社区开源双周报 (2023 12.22 - 2024.01.04) | Crossplane KCL 集成简化云资源配置与抽象
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**

## 内容概述

感谢所有贡献者过去两周 (2023 12.22 - 2024.01.04) 的杰出工作，以下是重点内容概述

**🔧 工具链更新**

- **包管理工具更新**
  - 支持带 `-` 符号的外部包自动转义为 KCL 可以识别的 `_` 符号如 `set-annotation` -> `set_annotation`
  - 修复 `kcl mod add` 在 Registry 包版本和本地已有包版本不同时引起的空指针错误

**💻 IDE 更新**

- **语义高亮**
  - KCL IDE 目前支持语义级别的高亮，避免不同 IDE 插件高亮差异
- **补全功能增强**
  - 区分 Schema 类型和实例补全符号
  - 统一 Schema 注释文档补全的格式
  - 修复不同语法补全符号类型不统一的问题

## 特别鸣谢

以下排名不分先后

- 感谢 @FLAGLORD, @YiuTerran, @flyinox, @steeling, @Anoop, @Phillip Neumann 和 @Even Solberg 在使用 KCL 过程中的交流与宝贵反馈 🙌

## 精选更新

### 使用 KCL 编写 Crossplane 函数

Crossplane 及其 Composite Function 功能被用于解耦 XR（CompositeResource）和复合资源定义。XR 允许开发者创建更高级别的抽象，这些抽象能够封装和组合来自不同提供商和服务的多种类型云资源。

使用 Crossplane 的 Composite Function 功能来渲染这些抽象能够有效增强各种提供商资源的模板能力，同时减少所需的 YAML 代码量。

将 KCL 与 Crossplane Composite Function 功能结合可以获得如下能力

- **简化复杂配置**：KCL 作为 DSL 提供了更简洁的语法和结构，可以减少配置的复杂性。当与 Crossplane 的复合资源结合时，可以创建更直观、易于理解的配置模板，比如编写循环和条件语句降低模版，编写 Schema 和 Rule 进行模型抽象和校验，使用 KCL 简化资源的定义和维护，而不是编写重复的 YAML 或者使用 Go 代码编写并部署 Crossplane Function，降低配置和策略的开发及维护成本。此外，因为 Crosssplane Composition 资源本身缺乏强大的模版能力且云 API 丰富且复杂，因此有些 Composition 资源可能需要上千行 YAML 才能完成渲染资源编写，维护成本较高，使用 KCL 可以平替 YAML 提升动态配置能力。
- **可重用和模块化**：KCL 通过 OCI Registry 支持模块化和代码复用，这意味着可以创建可重用的配置模型，为 Crossplane Composition 资源带来模块化能力，且可同时在运行时和客户端使用，方便不同的平台团队之间进行协作。
- **自动化和策略**：可以使用 KCL 的强大功能来编写策略和约束，与 Crossplane 的声明式资源管理结合使用，并且在集群中自动执行，确保云资源或者 Kubernetes 资源的合规性，而无需引入额外的策略引擎。

#### 前置工作

- 准备一个 Kubernetes 集群
- 安装 Kubectl
- 安装 [Crossplane 及 Crossplane CLI 1.14+](https://docs.crossplane.io/)
- 安装 KCL
- 安装 Go 1.21+ (可选，需要本地调试函数时才用到)

#### 快速开始

我们编写一个 `Network` 抽象模型，并使用 KCL 代码对其进行渲染得到托管资源 `VPC` 和 `InternetGateway`

##### 1. 安装 Crossplane KCL 函数

`Function` 资源会创建一个函数 Pod，当您创建一个 Crossplane Composition Resource 时，Crossplane 会向这个 Pod 发送请求，询问它要创建什么资源。

通过设置 `spec.package` 值为 `kcllang/crossplane-kcl` 表示我们这里使用 KCL 函数

```shell
kubectl apply -f- << EOF
apiVersion: pkg.crossplane.io/v1beta1
kind: Function
metadata:
  name: kcl-function
spec:
  package: docker.io/kcllang/crossplane-kcl
EOF
```

##### 2. 下发 Composition Resource

就像渲染函数一样，在这里我们指定 KCL 如何接受输入 `Network` 资源并生成 `VPC` 资源和 `InternetGateway` 资源。KCL 函数可以引用自 OCI Registry 或者 GitHub 上面的代码，当然也可以直接书写在 `Composition` 资源中。

```shell
kubectl apply -f- << EOF
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: xlabels.fn-demo.crossplane.io
  labels:
    provider: aws
spec:
  writeConnectionSecretsToNamespace: crossplane-system
  compositeTypeRef:
    apiVersion: fn-demo.crossplane.io/v1alpha1
    kind: XNetwork
  mode: Pipeline
  pipeline:
  - step: normal
    functionRef:
      name: kcl-function
    input:
      apiVersion: krm.kcl.dev/v1alpha1
      kind: KCLRun
      metadata:
        name: basic
      spec:
        # Generate new resources
        target: Resources
        # OCI, Git or inline source
        # source: oci://ghcr.io/kcl-lang/crossplane-xnetwork-kcl-function
        # source: github.com/kcl-lang/modules/crossplane-xnetwork-kcl-function
        source: |
          # Get the XR spec fields
          id = option("params")?.oxr?.spec.id or ""
          # Render XR to crossplane managed resources
          network_id_labels = {"networks.meta.fn.crossplane.io/network-id" = id} if id else {}
          vpc = {
              apiVersion = "ec2.aws.upbound.io/v1beta1"
              kind = "VPC"
              metadata.name = "vpc"
              metadata.labels = network_id_labels
              spec.forProvider = {
                  region = "eu-west-1"
                  cidrBlock = "192.168.0.0/16"
                  enableDnsSupport = True
                  enableDnsHostnames = True
              }
          }
          gateway = {
              apiVersion = "ec2.aws.upbound.io/v1beta1"
              kind = "InternetGateway"
              metadata.name = "gateway"
              metadata.labels = network_id_labels
              spec.forProvider = {
                  region = "eu-west-1"
                  vpcIdSelector.matchControllerRef = True
              }
          }
          items = [vpc, gateway]
EOF
```

##### 3. 创建输入资源类型 (Crossplane XRD)

我们使用 Crossplane XRD 为输入资源 Network 定义了一个 Schema，它有一个名为 id 的字段，表示网络 id。

```shell
kubectl apply -f- << EOF
apiVersion: apiextensions.crossplane.io/v1
kind: CompositeResourceDefinition
metadata:
  name: xnetworks.fn-demo.crossplane.io
spec:
  group: fn-demo.crossplane.io
  names:
    kind: XNetwork
    plural: xnetworks
  claimNames:
    kind: Network
    plural: networks
  versions:
    - name: v1alpha1
      served: true
      referenceable: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                id:
                  type: string
                  description: ID of this Network that other objects will use to refer to it.
              required:
                - id
EOF
```

##### 4. 下发输入资源 (Crossplane XR)

```shell
kubectl apply -f- << EOF
apiVersion: fn-demo.crossplane.io/v1alpha1
kind: Network
metadata:
  name: network-test-functions
  namespace: default
spec:
  id: network-test-functions
EOF
```

##### 5. 检查生成的托管资源

- VPC

```shell
kubectl get VPC -o yaml | grep network-id
      networks.meta.fn.crossplane.io/network-id: network-test-functions
```

- InternetGateway

```shell
kubectl get InternetGateway -o yaml | grep network-id
      networks.meta.fn.crossplane.io/network-id: network-test-functions
```

可以看到我们确实成功生成了 `VPC` 和 `InternetGateway` 资源，并且它们的字段符合预期 (接受 XR 输入的 id 字段并转换为 `VPC` 资源和 `InternetGateway` 资源的标签)。

#### 客户端渲染

可以看到，上述 KCL 抽象代码常常需要 Crossplane 作为控制平面中介，但是我们仍然可以完全摆脱 Crossplane 控制平面在客户端完成抽象，并直接生成 Crossplane 管理的资源，以减轻集群负担和操作成本的同时并获得更好的配置编写体验。

因为 KCL 模型并不局限于在客户端还是运行时进行使用，因此我们在客户端仅通过一条命令就可以完成上述所有功能:

```shell
kcl run oci://ghcr.io/kcl-lang/crossplane-xnetwork-kcl-function -S items -D params='{"oxr": {"spec": {"id": "network-test-functions"}}}'
```

输出为:

```yaml
apiVersion: ec2.aws.upbound.io/v1beta1
kind: VPC
metadata:
  name: vpc
  labels:
    networks.meta.fn.crossplane.io/network-id: network-test-functions
spec:
  forProvider:
    region: eu-west-1
    cidrBlock: 192.168.0.0/16
    enableDnsSupport: true
    enableDnsHostnames: true
---
apiVersion: ec2.aws.upbound.io/v1beta1
kind: InternetGateway
metadata:
  name: gateway
  labels:
    networks.meta.fn.crossplane.io/network-id: network-test-functions
spec:
  forProvider:
    region: eu-west-1
    vpcIdSelector:
      matchControllerRef: true
```

当然，后续我们会结合 `crossplane-provider-aws` 等模型库进一步详细介绍如何获得一个更好的客户端抽象，尽情期待!

此外，可以在这里查看到更多 Crossplane 和 KCL 结合的用例：[https://github.com/crossplane-contrib/function-kcl](https://github.com/crossplane-contrib/function-kcl)

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。后续我们会发布更多 KCL 云原生模型和工具集成文章，敬请期待! 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
