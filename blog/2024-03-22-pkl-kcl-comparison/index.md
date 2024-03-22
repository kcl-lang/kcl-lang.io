---
slug: 2024-03-22-pkl-kcl-comparison
title: Comparison between Pkl and KCL
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
---

## What is Pkl

Pkl is a domain-specific programming language aimed at addressing the **complexity of configurations** such as repeated configurations and error verification. It is mainly targeted at cloud-native and application configuration scenarios. The primary goals of its technical product as a whole can be summarized as follows:

- **Safety**: Provide safety by capturing validation errors before deployment.
- **Scalability**: The language can be used in both simple and complex scenarios.
- **Programmability**: Improve the experience of writing configuration code with first-class IDE support.

## What is KCL

KCL is an open-source, constraint-based record and functional language that enhances the writing of complex configurations, including those for cloud-native scenarios. It is hosted by the Cloud Native Computing Foundation (CNCF) as a Sandbox Project. With advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

## Differences between Pkl and KCL

### Design Philosophy

The design philosophy of the two languages can be glimpsed from their respective official slogans. Pkl's slogan is Programmable, Scalable, and Safe, while KCL's slogan is Mutation, Validation, and Abstraction. It can be understood that KCL, compared to Pkl, is more focused on specific cloud-native domain issues such as complexity and security, and is closer to the cloud-native description method (Mutation and Validation are derived from Kubernetes' MutationWebhook and ValidationWebhook, using Abstraction to combat complexity). KCL converges the language's design for specific domains, reduces unnecessary designs, and enhances functionality and developer usability. It tries to reference simpler language styles such as Python and Go, excluding unexpected features and side effects. It strengthens stability and consistency by combining language technology and GitOps, ensures configuration determinism by enforcing strong immutability and conflict detection, shields user-side details through code reuse and abstraction combining default value filling, and supports business validation of configuration data through custom validation expressions. It also integrates with more cloud-native tools or projects such as Kustomize, Helm, and Crossplane to provide more scenario functionality.

In contrast, Pkl is more "general" and "modern" in design compared to KCL, not only in its language design elements but also in its specific language features. Pkl is designed to be Turing complete and its overall language design is more like Swift and Kotlin, implying that it can be used for more than just "configuration" scenarios. It features object-oriented keywords similar to Java and pipeline operators such as |>, not commonly found in other common programming languages. Moreover, many of Pkl's features and tools are implemented by Pkl itself, to a certain extent demonstrating Pkl's capabilities. There are many use cases for Pkl, which cannot be exhaustively listed here.

I personally am very fond of Pkl's modern language features, signifying its powerful functionality and the ease of acceptance for developers writing libraries. However, from a negative perspective, this undoubtedly brings additional complexity and learning thresholds for a domain-specific language. KCL, on the other hand, strikes a balance between configuration data and powerful general language features. For example, KCL does not have procedural for loops like Pkl, and while it provides language features with a partial object-oriented focus, it does not introduce complex inheritance chains and polymorphism like Pkl. Additionally, KCL adopts some functional language features, and its functions are designed to be "pure" without extra side effects. This allows KCL to integrate with upper-level business systems for more automation while avoiding the most complex extreme scenarios, offering many built-in library functions for common scenarios.

### Language Features

Overall, KCL and Pkl both support variable definition, references, and type definition, but there are differences in the degree of support and syntax semantics. They both support common programming language features such as arithmetic, logic, list comprehensions, conditions, functions, standard libraries, and importing third-party modules. However, the support methods and syntax are different, but they have drawn inspiration from general-purpose programming languages. Both partially or mixingly support user-defined types and object-oriented features. In terms of data file integration, KCL and Pkl can directly import JSON/YAML data types, JSON Schema, Kubernetes CRD, and other type definitions.

Additionally, KCL and Pkl both have many built-in language features for configuration operations, data validation, and security compliance to meet the needs of configuration scenarios. For example, they support configuration auto-merge features, field range checks, type checks, regular expressions, and more. The difference is that KCL adopts partial object-oriented features by separating data type checks and constraint checks, allowing KCL to provide more static analysis capabilities to meet the needs of IDEs or other toolchains. In contrast, Pkl requires constraint definitions to be written together with type definitions and performs type checks and constraint validation uniformly at runtime.

### Developer Tools

In terms of developer tools, both Pkl and KCL prioritize developer productivity, providing a wide range of language tools and IDE plugin support. In addition to basic language tools, the Pkl website primarily offers support for three IDE plugins: IntelliJ, NeoVim, and VS Code. Interestingly, KCL currently also provides support for these three IDE plugins, although their functions and focuses are slightly different.

Due to Pkl being developed in Java and Kotlin, it can be easily adapted to the JetBrains IDE plugin ecosystem. As a result, the IntelliJ plugin support for Pkl is the most comprehensive. However, since Pkl itself does not provide a Language Server, the NeoVim and VS Code plugins are based on the Tree Sitter parser generator, offering only basic highlighting and code folding, without more advanced features such as definition navigation, code refactoring, and autocompletion. Although Pkl is an Apple project, it is not developed in Swift, and there are no IDE plugins for XCode.

Conversely, KCL, being developed in Rust, provides Language Server support, enabling easy integration with IDE plugins other than VS Code, including NeoVim and some emerging LSP-supporting IDEs or editors. KCL's Language Server offers complete features such as code highlighting, autocompletion, navigation, refactoring, and quick fixes. Since IntelliJ provides limited LSP support only in its professional version, we have supplemented the IntelliJ plugin with corresponding Java implementation support. However, compared to the VS Code KCL plugin, the functionality of the IntelliJ plugin currently has room for improvement and enhancement.

In conclusion, both Pkl and KCL have room for improvement in terms of developer productivity. Due to differences in the implementation of IDE plugins, there is a need for further improvement of the IDE experience and workflow through greater collaboration with the open-source community.

### Multiple Language Bindings

In order to better integrate the configuration language into user applications, Pkl provides bindings for four different languages: Java, Kotlin, Swift, and Go. Interestingly, KCL also offers four SDKs, including Go, Python, Java, and Rust.

Prior to Pkl's open-source release, KCL was one of the few, if not the only, projects to officially provide multiple language bindings and IDE plugins. This accomplishment was the result of the joint efforts and accumulated contributions from the community users and developers. Despite having few core maintainers, Pkl, upon its open-source release, provided many features that could be compared to those of KCL. This suggests that a considerable amount of effort and time went into its development, and it is commendable.

### Summary

The comparison table below summarizes the features of Pkl and KCL for reference.

| Features                              | Pkl                           | KCL                       |
| ------------------------------------- | ----------------------------- | ------------------------- |
| Open Source License                   | Apache-2.0                    | Apache-2.0                |
| Programming Language                  | Java, Kotlin                  | Rust                      |
| Language Style                        | Similar to Swift, Kotlin      | Similar to Python, Go     |
| Language Functionality                | Strong                        | Medium                    |
| Compilation Execution Method          | JIT                           | AOT                       |
| Runtime Performance                   | Medium                        | Medium                    |
| Incremental Compilation               | ✅                            | ✅                        |
| Standard Library                      | ✅                            | ✅                        |
| Package Management Tool               | ✅                            | ✅                        |
| Formatting Tool                       | ❌                            | ✅                        |
| Documentation Tool                    | ❌                            | ✅                        |
| Testing Tool                          | ✅                            | ✅                        |
| Debugging Tool                        | ❌                            | ❌                        |
| IDE Plugins                           | IntelliJ, NeoVim, VS Code     | IntelliJ, NeoVim, VS Code |
| Multi-language SDKs                   | Java, Kotlin, Swift, Go       | Go, Python, Java, Rust    |
| Multi-language Plugins                | ❌                            | Go, Python                |
| Language Server                       | ❌                            | ✅                        |
| Spring Framework Support              | ✅                            | ❌                        |
| OCI Registry Support                  | ❌                            | ✅                        |
| Community Model Library               | ✅                            | ✅                        |
| REST Server Support                   | ✅                            | ✅                        |
| Export Configuration Data             | JSON, YAML, TOML, plist, etc. | JSON, YAML                |
| Import from Other Data or Schema      | ✅                            | ✅                        |
| Kubernetes Configuration Support      | ✅                            | ✅                        |
| Cloud-native Tool Integration Support | ❌                            | ✅                        |

## References

- KCL Website: https://kcl-lang.io/
- KCL GitHub Repository: https://github.com/kcl-lang/kcl
- Pkl Website: https://pkl-lang.org/
- Pkl GitHub Repository: https://github.com/apple/pkl
