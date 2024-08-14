---
slug: 2024-07-22-jsonnet-kcl-comparison
title: Jsonnet 和 KCL 的异同
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Jsonnet, Comparison]
---

## Jsonnet 是什么

Jsonnet 是一种域特定语言（Domain Specific Language, DSL），设计用于简化 JSON 数据的创建、管理和维护。它最初由 Google 的员工 Dave Cunningham 在大约 10 年前作为 20% 项目设计并开发，其设计受到 Google 内部几种配置语言的影响，初衷是为了提高配置文件的可读性、可维护性和可编程性，同时保持与 JSON 的兼容性。Jsonnet 通过引入变量、函数、条件语句、循环以及代码注释等功能，使得编写复杂的数据结构变得更加容易和直观。

Jsonnet 代码目前仍归属 Google 所有，就在上月，因为 Jsonnet 的创始人 Dave Cunningham 离开 Google 从事新的事业，目前交由谷歌内部的 Rohit Jangid 负责继续管理项目。

## KCL 是什么

KCL 是一个开源的基于约束的记录及函数语言，作为沙盒项目托管在 CNCF 基金会。KCL 通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

## Jsonnet 和 KCL 的区别

### 设计理念

Jsonnet 致力于提升配置文件的可读性和简洁性。通过引入编程语言特性，如变量、函数、运算符和控制结构，Jsonnet 允许用户以更接近自然语言的方式编写配置，从而降低了复杂配置的管理难度，Jsonnet 保证了与 JSON 的完全兼容性。这意味着 Jsonnet 文件可以被编译成标准的 JSON 输出，无需更改即可被现有的 JSON 处理工具和系统识别和处理。但是, Jsonnet 并没有将类型和验证等特性对配置和策略领域也比较重要的特性纳入其考虑范围内，在稳定性和工程效率上的考量有所缺失。

在设计层面，KCL 更加 “通用” 和 “现代”，这不仅体现在语言设计元素上，还体现在具体的语言特性上。此外，KCL 不仅仅定位于是一个简化 JSON/YAML 数据的创建、管理和维护的工具，更聚焦在云原生领域中的具体场景问题比如复杂性和安全风险等问题，对于非领域内的问题尽可能收敛语言自身的设计。在满足功能以及开发者使用简单的基础上，尽可能参考一些使用起来比较简单的语言如 Python, Go 等语法语义风格，排除非预期的特性和副作用，比如从语言技术和 GitOps 结合两个方面加强对稳定性和一致性的保证，通过语言的自动化 API 来提升效率，通过强不可变性、冲突监测保证配置的确定性，通过代码复用和抽象结合默认值填充的方式屏蔽用户侧细节感知，通过自定义的校验表达式支持对配置数据的业务校验等，通过与更多的云原生工具或者项目集成比如 Crossplane, Helm, Kustomize 和 KPT 等项目来完成更多的场景功能支持。

### 语言特性

综合来看，KCL 和 Jsonnet 都支持变量定义、引用、函数定义，配置合并等功能，但支持程度和语法语义有差异；基本都支持支持常用的算术、逻辑、循环推导式、条件、函数、标准库和导入第三方模块等编程语言特性，支持方式及语法也各不相同，但都有从通用编程语言借鉴吸收。另外，Jsonnet 没有类型定义支持，它的值在运行时可变，可能会导致潜在的拼写错误，这带来了一定的风险，KCL 支持用户自定义类型、面向对象的特性上部分支持或混合支持、不可变性等特性在工程层面保证稳定性；在数据文件集成方面，KCL 和 Jsonnet 都可以直接导入 JSON/YAML 数据类型和 Kubernetes CRD 等类型定义。

此外，KCL 还在配置操作 Patch, 数据验证和安全合规层面内置了许多语言特性满足配置的场景需求，比如支持配置的自动合并特性以及字段范围，类型，正则表达式等检查特性，可以使得 KCL 提供更多的静态分析能力满足 IDE 或者其他工具链需要并或者组合约束检查的能力，且开发者友好，可以使用更丰富的 IDE 功能提升开发效率。

### 开发者工具

在开发者工具方面，Jsonnet 和 KCL 社区都提供了非常多的语言工具包括测试，格式化和包管理工具等支持。

由于 Jsonnet 的动态特性，IDE 支持很难做的十分全面，虽然 Grafana 社区做了很多努力，但是目前仍然只能提供基本的高亮，跳转，诊断和简单的标准库补全功能，由于语言本身缺乏了静态类型的相关特性，诸如一些高级的补全、重构和自动化分析等高级功能无法很好的完成。

KCL 提供了官方的 Language Server 支持，因此可以比较容易扩展集成到除 VS Code 的 IDE 插件支持包括 NeoVim 以及一些其他新兴的支持 LSP 的 IDE 或者编辑器。并且 KCL 基于 Language Server 提供了完整的代码高亮、补全、跳转、重构、补全和快速修复等功能，且在快速发展当中。

### 多语言 SDK

为了将配置语言更好地集成到用户的应用中，Jsonnet 目前在社区提供了具备不同的四种多语言实现，包含 C++, Go 和 Rust 以及 Python 绑定。KCL 目前具备官方的 Rust 实现，并提供了 Go, Python, Java, Node.js, C#, C++, C 和 WASM 等多种绑定，这些所有多语言绑定均基于 Rust，不会由于不同语言的实现而带来意外的结果和不确定性。

### 性能

虽然 KCL 提供了更多且对开发者更友好的功能，这并不意味着 KCL 臃肿和性能差，经过测试，在代码规模较大或者计算量较高的场景情况下 KCL 比 Jsonnet 性能更好，开发体验也更佳，比如在下面的例子中 KCL 的最新版本 (开启 KCL_FAST_EVAL 模式)性能可以超过 Jsonnet 官方所有实现，与社区早期的 Rust 实现性能基本持平，而 KCL 做了更多额外的检查来保证代码类型正确。

- KCL (test.k)

```python
a = lambda name: str {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
        name = name
        labels = {"app": "nginx"}
    }
    spec = {
        replicas = 3
        selector.matchLabels = {"app": "nginx"}
        template.metadata.labels = {"app": "nginx"}
        template.spec.containers = [
            {
                name = metadata.name
                image = "${metadata.name}:1.14.2"
                ports = [{ containerPort = 80 }]
            }
        ]
    }
}
temp = {"a${i}": a("nginx") for i in range(1000)}
```

- Jsonnet (test.jsonnet)

```jsonnet
local a(name) = {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
        name: name,
        labels: {["app"]: "nginx"}
    },
    spec: {
        replicas: 3,
        selector: {
            matchLabels: {["app"]: "nginx"}
        },
        template: {
            metadata: {
                labels: {["app"]: "nginx"}
            },
            spec: {
                containers: [
                    {
                        name: name,
                        image: name + ":1.14.2",
                        ports: [{ containerPort: 80 }]
                    }
                ]
            }
        },
    }
};
{
    temp: {["a%d" % i]: a("nginx") for i in std.range(0, 1000)},
}
```

运行时间（考虑到生产环境的实际资源开销，本次测试以单核为准）

| KCL v0.9.3          | Jsonnet v0.20.0 (C++ 版本)     | Jsonnet v0.20.0 (Go 版本)     | Jsonnet v0.5.0-pre96 (Rust 版本 jrsonnet) | Jsonnet v0.1.2 (Rust 版本 rsjsonnet) |
| ------------------- | ------------------------------ | ----------------------------- | ----------------------------------------- | ------------------------------------ |
| 155 ms (kcl test.k) | 1460 ms (jsonnet test.jsonnet) | 400 ms (jsonnet test.jsonnet) | 153 ms (rsjsonnet test.jsonnet)           | 142 ms (jrsonnet test.jsonnet)       |

## 小结

受限于篇幅，以上内容不足以描述全部的设计细节和功能对比，下面仅列出一个表格对比用于读者参考。

| 特性                     | Jsonnet                         | KCL                                         |
| ------------------------ | ------------------------------- | ------------------------------------------- |
| 开源协议                 | Apache-2.0, AGPL-3.0 license 等 | Apache-2.0                                  |
| 开发语言                 | C++, Go, Rust 等                | Rust                                        |
| 语言风格                 | 类 Json                         | 类 Python, Go                               |
| 语言功能                 | 中等                            | 强                                          |
| 运行性能                 | 中等                            | 中等                                        |
| 增量编译                 | ❌                              | ✅                                          |
| 标准库                   | ✅                              | ✅                                          |
| 包管理工具               | ✅                              | ✅                                          |
| 格式化工具               | ✅                              | ✅                                          |
| 文档工具                 | ✅                              | ✅                                          |
| 测试工具                 | ✅                              | ✅                                          |
| 调试工具                 | ✅ (简单的 ReplDebugger)        | ❌                                          |
| IDE 插件                 | IntelliJ, NeoVim, VS Code       | IntelliJ, NeoVim, VS Code                   |
| 多语言 SDK               | C++, Go, Python, Rust, WASM     | Go, Python, Java, Node.js, C#, C++, C, WASM |
| 多语言插件               | ❌                              | Go, Python, Java                            |
| Language Server          | ✅                              | ✅                                          |
| OCI Registry 支持        | ❌                              | ✅                                          |
| 社区模型库               | ✅                              | ✅                                          |
| 导出配置数据             | JSON, YAML, TOML, Ini 等        | JSON, YAML, TOML                            |
| 从其他数据或 Schema 导入 | ✅                              | ✅                                          |
| Kubernetes 配置支持      | ✅                              | ✅                                          |
| 云原生工具集成支持       | ✅                              | ✅                                          |

## 参考

- KCL 主页：[https://kcl-lang.io/](https://kcl-lang.io/)
- KCL GitHub 仓库：[https://github.com/kcl-lang/kcl](https://github.com/kcl-lang/kcl)
- Jsonnet 主页：[https://jsonnet.org/](https://jsonnet.org/)
- Jsonnet C++ 版本 GitHub 仓库：[https://github.com/google/jsonnet](https://github.com/google/jsonnet)
- Jsonnet Go 版本 GitHub 仓库：[https://github.com/google/go-jsonnet](https://github.com/google/go-jsonnet)
- Jsonnet Rust 版本 (jrsonnet) GitHub 仓库：[https://github.com/CertainLach/jrsonnet](https://github.com/CertainLach/jrsonnet)
- Jsonnet Rust 版本 (rsjsonnet) GitHub 仓库 [https://github.com/eduardosm/rsjsonnet](https://github.com/eduardosm/rsjsonnet)
