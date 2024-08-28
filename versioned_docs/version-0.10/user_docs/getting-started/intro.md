---
sidebar_position: 1
---

# Introduction

## What is KCL?

[KCL](https://github.com/kcl-lang/kcl) is an open-source configuration and policy language hosted by the Cloud Native Computing Foundation (CNCF) as a Sandbox Project. Built on a foundation of constraints and functional programming principles, KCL enhances the process of writing complex configurations, particularly in cloud-native environments. By leveraging advanced programming language techniques, KCL promotes improved modularity, scalability, and stability in configuration management. It simplifies logic writing, offers easy-to-use automation APIs, and seamlessly integrates with existing systems.

## Why KCL?

KCL addresses a crucial gap in existing configuration tooling by offering a modern, declarative approach specifically designed for dynamic configurations in the lightweight client-side cloud-native environments. It tackles several key challenges:

- **Dimension explosion**: Traditional large scale static configurations, such as Kubernetes YAML, necessitate separate files for each environment. In the worst case,this can lead to difficult-to-debug errors, impacting stability and scalability.
- **Configuration drift**: Managing dynamic configurations across diverse environments often lacks standardized approaches. Utilizing ad-hoc methods like scripting increases complexity and leads to inconsistent configurations.
- **Cognitive loading**: While platforms like Kubernetes excel in low-level infrastructure management, they lack higher-level abstractions for application delivery. This burdens developers and hinders the software delivery experience.

KCL offers the following solutions:

- **API abstractions**: KCL hides infrastructure complexities, reducing developers' cognitive load by providing relevant abstractions.
- **Mutation and validation**: KCL empowers users to modify and verify existing configuration files or manifests effectively.
- **Large-scale configuration management and automation**: KCL enables seamless management and automation of extensive configuration data across teams, ensuring consistency and preventing unintended side effects.

Specifically, KCL empowers developers to:

- **Semantically validate configurations**: Ensure code-level configuration validity through features like schema definitions, attribute requirements, type checks, and range constraints.
- **Structure and abstract configurations**: Define, combine, and abstract configuration chunks using features like structure definitions, inheritance, constraint definitions, and policy merging.
- **Enhance flexibility**: Leverage modern programming language features like conditional statements, loops, functions, and package management to improve configuration reusability.
- **Utilize comprehensive tooling**: Benefit from rich IDE extensions and robust toolchains that simplify learning and enhance user experience.
- **Facilitate configuration sharing**: Share, propagate, and deliver configurations efficiently across teams using package management tools and OCI registries.
- **Leverage high-performance compilation**: Utilize a high-performance compiler designed to meet the demands of large-scale configuration scenarios, including rapid rendering for various environments and efficient configuration automation modifications.
- **Improve automation integration**: Enhance automation capabilities through multi-language SDKs, KCL language plugins, and other tools, simplifying integration while maximizing the value of KCL configurations and policies.

![](/img/docs/user_docs/intro/kcl-overview.png)

Beyond the core language, KCL offers a rich ecosystem of tools for formatting, testing, documentation, and package management. These tools empower users to write, understand, and verify configurations efficiently. IDE extensions like VS Code and playground environments, along with package management tools, further reduce the cost of configuration management and sharing. KCL's multi-language SDKs for Rust, Go, Python, Java and Node.js enable automated configuration management and execution.

KCL seamlessly integrates with various languages, formats, and cloud-native tools. For instance, the kcl vet tool validates Terraform plan files, while the import tool generates KCL schemas from diverse sources like Terraform provider schemas and Kubernetes CRDs. KCL's comprehensive integration with cloud-native tools stems from the [KRM KCL specification](https://github.com/kcl-lang/krm-kcl).

As a modern, high-level domain language, KCL employs a compiled and statically typed approach. Its record and functional paradigm allows developers to define **configurations**, **schemas**, **lambdas (functions)**, and **rules (policies)** as core elements. By embracing language features like immutability, pure functions, and attribute operators, KCL achieves a balance between configuration scalability and security.

![](/img/docs/user_docs/intro/kcl-concepts.png)

KCL prioritizes runtime-independent programmability. While it avoids system-level functions like threading and I/O, it provides specialized functions tailored for cloud-native scenarios. KCL strives to offer stable, secure, predictable, and automation-friendly programming support for solving domain-specific challenges.

In summary, KCL boasts the following characteristics:

- **Easy-to-use**: Drawing inspiration from Python and Golang, KCL incorporates functional programming principles with minimal side effects.
- **Well-designed**: KCL's syntax, semantics, runtime, and system modules adhere to a spec-driven design, ensuring consistency and clarity.
- **Quick modeling**: [Schema](https://kcl-lang.github.io/docs/reference/lang/tour#schema)-centric configuration types and modular abstraction enable rapid and efficient modeling.
- **Stability**: Configuration stability built on [static type system](https://kcl-lang.github.io/docs/reference/lang/tour/#type-system), [constraints](https://kcl-lang.github.io/docs/reference/lang/tour/#validation), and [rules](https://kcl-lang.github.io/docs/reference/lang/tour#rule).
- **Scalability**: KCL's automatic merge mechanism for isolated configuration blocks promotes high scalability.
- **Fast automation**: KCL offers a gradient automation scheme encompassing [CRUD APIs](https://kcl-lang.github.io/docs/reference/lang/tour/#kcl-cli-variable-override), [multilingual APIs](https://kcl-lang.github.io/docs/reference/xlang-api/overview), and [language plugins](https://kcl-lang.github.io/docs/reference/plugin/overview)
- **High performance**: Leveraging Rust, C, and LLVM, KCL achieves high compilation and runtime performance, supporting compilation to native code and WebAssembly.
- **API affinity**: KCL natively supports API specifications like JsonSchema, OpenAPI, Kubernetes CRDs, Kubernetes YAML, Terraform provider schema and etc.
- **Development friendly**: KCL provides a rich suite of language tools (format, lint, test, vet, doc) and [IDE extensions](https://kcl-lang.github.io/docs/tools/Ide/) for a smooth development experience.
- **Safety and maintainability**: KCL's domain-oriented nature avoids system-level functions, minimizing noise, security risks, and maintenance overhead.
- **Rich multi-language SDK**: SDKs for [Rust](https://kcl-lang.github.io/docs/reference/xlang-api/rust-api), [Go](https://kcl-lang.github.io/docs/reference/xlang-api/go-api), [Python](https://kcl-lang.github.io/docs/reference/xlang-api/python-api), [Java](https://kcl-lang.github.io/docs/reference/xlang-api/java-api), [.NET](https://kcl-lang.github.io/docs/reference/xlang-api/dotnet-api), [Node.js](https://kcl-lang.github.io/docs/reference/xlang-api/nodejs-api), [Kotlin](https://kcl-lang.github.io/docs/reference/xlang-api/kotlin-api), [Swift](https://kcl-lang.github.io/docs/reference/xlang-api/swift-api), [C](https://kcl-lang.github.io/docs/reference/xlang-api/c-api), [C++](https://kcl-lang.github.io/docs/reference/xlang-api/cpp-api), [WASM](https://www.kcl-lang.io/docs/reference/xlang-api/wasm-api) and [REST](https://www.kcl-lang.io/docs/reference/xlang-api/rest-api) APIs cater to diverse scenarios and application use cases.
- **Kubernetes integrations**: External mutation and validation plugins including [Kustomize KCL Plugin](https://github.com/kcl-lang/kustomize-kcl), [Helm KCL Plugin](https://github.com/kcl-lang/helm-kcl), [KPT KCL SDK](https://github.com/kcl-lang/kpt-kcl-sdk), [Kubectl KCL Plugin](https://github.com/kcl-lang/kubectl-kcl) or [Crossplane KCL Function](https://github.com/kcl-lang/crossplane-kcl) to separate data and logic.
- **Production-ready**: KCL has been successfully deployed in production environments at Ant Group for platform engineering and automation.

While KCL is not a general-purpose language, it excels within its specific domain. Developers can leverage KCL to write configurations, schemas, functions, and rules. Configurations define data, schemas describe data models, rules enforce data validation, and schemas and rules can be combined to comprehensively describe data models and constraints. KCL's lambda functions enable code organization, encapsulation, and reusability.

KCL's attribute configuration follows a simple pattern:

$$
k\ o \ (T) \ v
$$

where $k$ is the attribute name, $v$ is the attributes value, $o$ is the attribute operator and $T$ is the type annotation. Since KCL has the ability of the type inference, $T$ is usually omitted. `deploy = Deployment {}` is a simple example that satisfies the pattern.

This is an example of generating Kubernetes manifests.

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

We can use the KCL code to generate a Kubernetes YAML manifest.

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

## How to Choose?

Communities have been making significant efforts to improve their configuration technologies, which can be categorized into three groups:

- Low-level data format-based tools that utilize external tools for enhancing reuse and validation, specifically for templating, patching, and validation.
- Domain-Specific Languages (DSLs) and Configuration Languages (CLs), which enhance language abilities.
- General Purpose Language (GPL)-based solutions that utilize Cloud-Development Kit (CDK) or framework to define the configuration.

To simplify, here are some recommended options:

- YAML/JSON/Kustomize/Helm are recommended if you need to write structured key-value pairs, or use Kubernetes native tools.
- HCL is recommended if you want to use programming language convenience to remove boilerplate with good human readability, or if you are already a Terraform user.
- CUE is recommended if you want to use type system to improve stability and maintain scalable configurations.
- KCL is recommended if you want types and modeling like a modern language, scalable configurations, in-house pure functions and rules, and production-ready performance and automation.

### vs. YAML/JSON

YAML/JSON configurations are suitable for small-scale configuration scenarios. However, if you require frequent modifications in large-scale cloud-native configuration scenarios, KCL is more appropriate. The primary difference between the two is the abstraction of configuration data and deployment.

The advantages of using KCL for configuration are numerous. First, abstracting one layer for static data provides deployment flexibility, allowing various configuration environments, tenants, and runtime to have distinct requirements for static data. Additionally, different organizations may have different specifications and product requirements. By leveraging KCL, administrators can expose the most important and frequently modified configurations to users.

### vs. Jsonnet/GCL

GCL is a declarative configuration programming language implemented in Python, providing necessary language capabilities for template abstraction. However, the compiler itself is written in Python, and the language runs with interpretation, leading to poor performance for large template instances, such as the Kubernetes model.

On the other hand, Jsonnet is a data template language implemented in C++/Go, suitable for application and tool developers. It can generate configuration data and organize, simplify, and manage large configurations without any side effects.

Both Jsonnet and GCL are excellent at reducing boilerplate, using code to generate configuration, so engineers can write advanced GPL code instead of manually writing error-prone and difficult-to-understand server binary code. Despite reducing some of the complexities of GCL, Jsonnet largely falls into the same category. Both have runtime errors, insufficient type-checking and constraint capacity.

### vs. HCL

HCL is a configuration language implemented in Go that is structured and inspired by the syntax of libucl and nginx configurations. It is designed to be both human and machine-friendly, primarily for use in devops tools, server configurations, and resource configurations as a [Terraform language](https://www.terraform.io/language).

The user interface of HCL is not readily apparent in the Terraform provider Schema definition and can be cumbersome when defining complex object and required/optional fields. Dynamic parameters are constrained by the condition field of the variable, and resource constraints must be defined either by the provider schema or through the use of Sentinel/Rego and other policy languages. The language itself may not be self-contained.

### vs. CUE

CUE can be utilized for modeling through structures without the need for inheritance or other features. This can lead to high abstraction as long as there are no conflicts with model definitions. However, since CUE performs all constraint checks at runtime, there may be performance bottlenecks in large-scale modeling scenarios. Despite this, CUE simplifies constraint writing through various syntax options, eliminating the need for generic types and enumerations. Additionally, configuration merging is supported but is completely idempotent, which may not be suitable for complex multi-tenant and multi-environment configuration scenarios. Writing complex loop and constraint scenarios can be challenging and cumbersome for accurately modifying configurations.

On the other hand, KCL conducts modeling through the schema and achieves high model abstraction through language-level engineering and some object-oriented features, such as single inheritance. KCL is a statically compiled language with low overhead for large-scale modeling scenarios. Additionally, KCL provides a richer declarative constraint syntax, making it easier to write. Compared to CUE, KCL offers more if guard combination constraints, all/any/map/filter, and other collection constraint writing methods, which simplify configuration field combination constraints.

### vs. Dhall

Dhall is a functional, programmable configuration language that incorporates JSON, functions, types and imports. If you have experience with languages like Haskell, you may find Dhall familiar. KCL also offers similar functionality for programmability and abstraction, but has made greater advancements in areas such as modeling, constraint checking, automation and package management for sharing models. KCL's syntax and semantics are more aligned with object-oriented languages, making it more approachable than pure functional styles in some cases.

### vs. Nickel

Nickel is the cheap configuration language. Its purpose is to automate the generation of static configuration files and it is in essence JSON with functions and types.

KCL and Nickel both have a similar gradual type system (static + dynamic), merge strategy, function and constraint definition. The difference is that KCL is a Python-like language, while Nickel is a JSON-like language. In addition, KCL provides the schema keyword to distinguish between configuration definitions and configuration data to avoid mixed use.

### vs. Starlark

Starlark is the language of Bazel, which is a dialect of Python. It does not have types and recursion is forbidden.

KCL can also be regarded as a variant of Python to some extent, but it greatly enhances the design related to static typing and configuration extensibility, and is a compiled language, which is essentially different from Starlark.

### vs. Pkl

Pkl is a configuration as code language that has programmable, extensible, and secure features.

There some similarities between KCL and Pkl here:

- Language features: schema, validation, immutability, etc.
- Multi language binding, KCL provides binding for Python, Go, and Java, etc. and Pkl providers others.
- Multiple IDE plugin support: NeoVim, VS Code, etc.

Differently, KCL provides more relevant integration with cloud native tools and model code libraries.

### vs. Kustomize

The key feature of Kustomize is its ability to overlay files at a granular level. However, it faces challenges with multiple overlay chains as a specific attribute value may not be the final value, as it can be overridden by another value elsewhere. Retrieving the inheritance chain of Kustomize files can be less convenient than retrieving the inheritance chain of KCL code, particularly for complex scenarios where careful consideration of the specified configuration file overwrite order is necessary. Additionally, Kustomize does not address issues related to YAML configuration writing, constraint verification, model abstraction, and development, making it more suited for simpler configuration scenarios.

In contrast, KCL offers fine-grained configuration merge operations for each attribute in the code, with flexible merge strategy settings that are not limited to overall resources. KCL also allows for static analysis of configuration dependencies through import statements.

### vs. Helm

The idea behind Helm can be traced back to the package management system used in operating systems. It is a package management tool that relies on templated YAML files to execute and manage resources within packages.

KCL provides a greater range of capabilities than Helm, making it a viable alternative. Users who have already adopted Helm can still utilize KCL by packaging the stack compilation results in a Helm format or by using the Helm-KCL plugin to programmatically extend existing Helm charts.

### vs. CDK

CDK's high-level language integrates well into application projects, effectively becoming part of the client runtime. In contrast, KCL decouples external configurations and policies written using KCL from the client runtime.

General-purpose languages can often be over-engineered, going beyond the requirements of the problem being solved. These languages can also present various security issues, such as problems with the ability boundary, such as accessing I/O, network, code infinite looping, and other security risks. In specialized fields, such as music, there are special notes used to communicate effectively, which cannot be expressed clearly in general-purpose languages.

Furthermore, general-purpose languages come in a variety of styles, which can create challenges in terms of unified maintenance, management, and automation. These languages are generally better suited to writing the client runtime, which is a continuation of the server runtime. They are not ideal for writing configurations that are independent of the runtime, as they are compiled into binaries and started from the process, making stability and scalability challenging to control. In contrast, configuration languages are often used to write data combined with simple logic, and they describe the expected final result, which is then consumed by the compiler or engine. Besides, KCL is declarative and structured, and we can use KCL's automation API to modify and query the KCL code itself.

### vs. OPA/Rego

While not originally intended as a data definition language, Rego, the language used for Open Policy Agent (OPA), can also address the issue of adding constraints from multiple sources.

Rego has its roots in logic programming and is based on Datalog, a restricted form of Prolog. Rego excels as a query language, but it can be cumbersome for constraint enforcement, in that values must be queried before applying constraints. Besides, Rego itself does not have the ability to define a schema. You can introduce JsonSchema definitions in Rego's comments when needed.

KCL's approach to constraint validation is more conducive to finding normalized and simplified representations of constraints, making it well-suited for creating structures generated from OpenAPI.
