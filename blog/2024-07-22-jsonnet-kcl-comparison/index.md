---
slug: 2024-07-22-jsonnet-kcl-comparison
title: A Comparative Overview of Jsonnet and KCL
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
---

## What is Jsonnet

Jsonnet is a Domain Specific Language (DSL) designed to simplify the creation, management, and maintenance of JSON data. It was originally designed and developed by Google employee Dave Cunningham as a 20% project around 10 years ago. The design of Jsonnet was influenced by several configuration languages used internally at Google, with the aim of improving the readability, maintainability, and programmability of configuration files while remaining compatible with JSON. It introduces features such as variables, functions, conditionals, loops, and code comments, making it easier and more intuitive to write complex data structures.

Jsonnet code is currently owned by Google. However, last month, due to the departure of Jsonnet's founder Dave Cunningham from Google for a new venture, the project is now managed by Rohit Jangid within Google.

## What is KCL

KCL is an open-source, constraint-based record and functional language that enhances the writing of complex configurations, including those for cloud-native scenarios. It is hosted by the Cloud Native Computing Foundation (CNCF) as a Sandbox Project. With advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

## Differences Between Jsonnet and KCL

### Design Philosophy

Jsonnet aims to enhance the readability and conciseness of configuration files through the introduction of programming language features such as variables, functions, operators, and control structures. This approach lowers the management complexity of complex configurations with guaranteed full compatibility with JSON. However, Jsonnet does not address important features such as types and validation, leading to a lack of consideration for stability and engineering efficiency in the configuration and policy domain.

At a design level, KCL is more "universal" and "modern", not only in its language design elements but also in its specific language features. Additionally, KCL focuses not only on simplifying the creation, management, and maintenance of JSON/YAML data, but also addresses specific cloud-native complexities and security risks. It converges language design towards problems specific to the cloud-native domain, aiming to converge its design around language technology and GitOps integration to strengthen stability and consistency guarantees. It achieves this through automated API, strong immutability, conflict detection, and support for custom validation expressions, among other capabilities.

### Language Features

Both KCL and Jsonnet support variable definition, references, function definitions, and configuration merging, although their degrees of support and syntax semantics differ. They both support common programming language features such as arithmetic, logical operations, comprehensions, conditions, functions, standard libraries, and importing third-party modules, although in different manners. Unlike Jsonnet, KCL provides support for user-defined types, limited or mixed support for object-oriented features, and immutability, ensuring stability at an engineering level. Both KCL and Jsonnet can directly import JSON/YAML data types and Kubernetes CRDs.

Moreover, KCL integrates many built-in language features to fulfill configuration scenarios, such as configuration patching, data validation, and security compliance. This provides KCL with more static analysis capabilities to meet IDE or other tool chain needs and combine constraint checking.

### Developer Tools

Both Jsonnet and KCL communities provide a wide range of language tools, including testing, formatting, and package management support. While Jsonnet's dynamic nature makes comprehensive IDE support difficult, KCL offers official Language Server support, which can be easily extended and integrated into IDE plugins, including NeoVim and other emerging LSP-supported IDEs or editors. KCL's Language Server provides complete features such as syntax highlighting, autocompletion, navigation, refactoring, and quick fixes, and is growing rapidly.

### Multiple Language Bindings

For better integration of configuration language into users' applications, Jsonnet currently provides four different multi-language implementations in the community, including C++, Go, Rust, and Python bindings. KCL currently offers an official Rust implementation and provides various bindings such as Go, Python, Java, Node.js, C#, C++, C, and WASM, all based on Rust, ensuring predictable and consistent results regardless of the language used.

### Performance

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

Run time (considering actual resource expenditure in production environments, this test is based on a single core):

| KCL v0.9.3          | Jsonnet v0.20.0 (C++ version)  | Jsonnet v0.20.0 (Go version)  | Jsonnet v0.5.0-pre96 (Rust version jrsonnet) | Jsonnet v0.1.2 (Rust version rsjsonnet) |
| ------------------- | ------------------------------ | ----------------------------- | -------------------------------------------- | --------------------------------------- |
| 155 ms (kcl test.k) | 1480 ms (jsonnet test.jsonnet) | 400 ms (jsonnet test.jsonnet) | 153 ms (rsjsonnet test.jsonnet)              | 142 ms (jrsonnet test.jsonnet)          |

## Summary

The comparison table below summarizes the features of Jsonnet and KCL for reference.

| Features                              | Jsonnet                     | KCL                                         |
| ------------------------------------- | --------------------------- | ------------------------------------------- |
| Open Source License                   | Apache-2.0                  | Apache-2.0                                  |
| Development Language                  | C++, Go, Rust, etc          | Rust                                        |
| Language Style                        | JSON-like                   | Python-like, Go-like                        |
| Language Functionality                | Medium                      | High                                        |
| Runtime Performance                   | Medium                      | Medium                                      |
| Incremental Compilation               | ❌                          | ✅                                          |
| Standard Library                      | ✅                          | ✅                                          |
| Package Management Tool               | ✅                          | ✅                                          |
| Formatting Tool                       | ✅                          | ✅                                          |
| Documentation Tool                    | ✅                          | ✅                                          |
| Testing Tool                          | ✅                          | ✅                                          |
| Debugging Tool                        | ✅ (Simple ReplDebugger)    | ❌                                          |
| IDE Plugins                           | IntelliJ, NeoVim, VS Code   | IntelliJ, NeoVim, VS Code                   |
| Multi-language SDKs                   | C++, Go, Python, Rust       | Go, Python, Java, Node.js, C#, C++, C, WASM |
| Multi-language Plugins                | ❌                          | Go, Python, Java                            |
| Language Server                       | ✅                          | ✅                                          |
| OCI Registry Support                  | ❌                          | ✅                                          |
| Community Model Library               | ✅                          | ✅                                          |
| REST Server Support                   | ❌                          | ✅                                          |
| Export Configuration Data             | JSON, YAML, TOML, ini, etc. | JSON, YAML, TOML                            |
| Import from Other Data or Schema      | ✅                          | ✅                                          |
| Kubernetes Configuration Support      | ✅                          | ✅                                          |
| Cloud-native Tool Integration Support | ❌                          | ✅                                          |

## References

- KCL Website: https://kcl-lang.io/
- KCL GitHub Repository: https://github.com/kcl-lang/kcl
- Jsonnet Website: https://jsonnet.org/
- Jsonnet C++ Version GitHub Repository: https://github.com/google/jsonnet
- Jsonnet Go Version GitHub Repository: https://github.com/google/go-jsonnet
- Jsonnet Rust Version (jrsonnet) GitHub Repository: https://github.com/CertainLach/jrsonnet
- Jsonnet Rust Version (rsjsonnet) GitHub Repository https://github.com/eduardosm/rsjsonnet
