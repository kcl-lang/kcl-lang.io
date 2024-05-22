---
sidebar_position: 1
---

# Introduction

## What is KCL?

[KCL](https://github.com/kcl-lang/kcl) is an open-source, constraint-based record and functional language that enhances the writing of complex configurations, including those for cloud-native scenarios. It is hosted by the Cloud Native Computing Foundation (CNCF) as a Sandbox Project. With advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

## Why Use KCL?

KCL aims to fill the gap in configuration languages and tools in the lightweight client-side cloud-native dynamic configuration domain through a more modern declarative configuration language and tools. It aims to address the following problems:

- **Dimension explosion**: Most static configurations, such as Kubernetes YAML configurations in the cloud-native domain, require separate configurations for each environment. In the worst case, this can introduce difficult-to-debug errors involving cross-environment links, resulting in poor stability and scalability.
- **Configuration drift**: There is often no standardized way to manage the dynamic configurations of applications and infrastructure for different environments, leading to configuration drift. Using non-standardized methods, such as scripting and piecing together glue code, can exponentially increase complexity and lead to configuration drift.
- **Cognitive loading**: Platform technologies such as Kubernetes excel in unifying infrastructure details at the lower level, but lack higher-level application software delivery abstractions. This creates a higher cognitive loading for regular developers and affects the software delivery experience for developers at higher levels.

To address these problems, KCL aims to provide the following capabilities:

- Hide infrastructure and platform details by defining more appropriate **API abstractions** to reduce the burden of developers.
- **Mutate** and **validate** existing config files or manifests.
- **Manage large-scale configuration data** across teams without side effects through configuration language.

Specifically, KCL can

- Improve the ability to **semantically validate configurations** at the code level, such as schema definitions, required/optional attribute requirements, types, range constraints, and etc.
- Provide capabilities for **writing, combining, and abstracting configuration chunks**, such as structure definitions, structure inheritance, constraint definitions, and configuration policy merging.
- Enhance configuration flexibility by adopting **modern programming language** features, such as conditional statements, loops, functions, and package management, to improve configuration reusability.
- Provide **comprehensive toolchain support**, including rich IDE extensions and toolchains support to reduce the learning curve and enhance the user experience.
- Enable easier sharing, propagation, and delivery of configurations between different teams/roles through **package management tools** and **OCI registries**.
- Offer a **high-performance** compiler to meet the demands of scalable configuration scenarios, such as rendering performance for generating configurations for different environments and topologies based on a baseline configuration and configuration automation modification performance requirements.
- Improve **automation integration** capabilities through **multi-language SDKs**, **KCL language plugins**, and other means, significantly reducing the learning curve while leveraging the value of configuration and policy writing with KCL.

![](/img/docs/user_docs/intro/kcl-overview.png)

In addition to the language itself, KCL also provides many additional tools, such as formatting, testing, document, package management, to help users use, understand and check the configuration or policy they write. We can reduce the cost of configuration writing and sharing through IDE extensions such as VS Code, playground and package manage tools. In addition, through KCL Rust, Go, and Python multilingual SDKs, the configuration can be automatically managed and executed.

Besides, KCL is a modern high-level domain language, which is a compiled, static and strongly typed language. It provides developers with the ability to write **configuration (config)**, **modeling abstraction (schema)**, **logic (lambda)**, and **policies (rule)** as the core elements through recording and functional language design.

![](/img/docs/user_docs/intro/kcl-concepts.png)

KCL tries to provide runtime-independent programmability and does not natively provide system functions such as threads and IO, but supports functions for cloud-native operation scenarios, and tries to provide stable, secure, low-noise, low-side effect, easy-to-automate and easy-to-govern programming support for solving domain problems.

In summary, KCL has the following characteristics:

- **Easy-to-use**: Originated from high-level languages ​​such as Python and Golang, incorporating functional language features with low side effects.
- **Well-designed**: Independent Spec-driven syntax, semantics, runtime and system modules design.
- **Quick modeling**: [Schema](https://kcl-lang.github.io/docs/reference/lang/tour#schema)-centric configuration types and modular abstraction.
- **Rich capabilities**: Configuration with type, logic and policy based on [Config](https://kcl-lang.github.io/docs/reference/lang/codelab/simple), [Schema](https://kcl-lang.github.io/docs/reference/lang/tour/#schema), [Lambda](https://kcl-lang.github.io/docs/reference/lang/tour/#function), [Rule](https://kcl-lang.github.io/docs/reference/lang/tour/#rule).
- **Stability**: Configuration stability built on [static type system](https://kcl-lang.github.io/docs/reference/lang/tour/#type-system), [constraints](https://kcl-lang.github.io/docs/reference/lang/tour/#validation), and [rules](https://kcl-lang.github.io/docs/reference/lang/tour#rule).
- **Scalability**: High scalability through [automatic merge mechanism](https://kcl-lang.github.io/docs/reference/lang/tour/#-operators-1) of isolated config blocks.
- **Fast automation**: Gradient automation scheme of [CRUD APIs](https://kcl-lang.github.io/docs/reference/lang/tour/#kcl-cli-variable-override), [multilingual SDKs](https://kcl-lang.github.io/docs/reference/xlang-api/overview), [language plugin](https://kcl-lang.github.io/docs/reference/plugin/overview)
- **High performance**: High compile time and runtime performance using Rust & C and [LLVM](https://llvm.org/), and support compilation to native code and [WASM](https://webassembly.org/).
- **API affinity**: Native support API ecological specifications such as [OpenAPI](https://kcl-lang.github.io/docs/tools/cli/openapi/), Kubernetes CRD, Kubernetes YAML spec.
- **Development friendly**: Friendly development experiences with rich [language tools](https://kcl-lang.github.io/docs/tools/cli/kcl/overview) (Format, Lint, Test, Vet, Doc, etc.) and [IDE extensions](https://kcl-lang.github.io/docs/tools/Ide/).
- **Safety & maintainable**: Domain-oriented, no system-level functions such as native threads and IO, low noise and security risk, easy maintenance and governance.
- **Rich multi-language SDK**: [Go](https://kcl-lang.io/docs/reference/xlang-api/go-api), [Python](https://kcl-lang.io/docs/reference/xlang-api/python-api), [Java](https://kcl-lang.io/docs/reference/xlang-api/java-api) and [REST APIs](https://kcl-lang.io/docs/reference/xlang-api/rest-api) meet different scenarios and application use prelude.
- **Kubernetes Integrations**: External mutation and validation plugins including [Kustomize KCL Plugin](https://github.com/kcl-lang/kustomize-kcl), [Helm KCL Plugin](https://github.com/kcl-lang/helm-kcl), [KPT KCL SDK](https://github.com/kcl-lang/kpt-kcl-sdk), [Kubectl KCL Plugin](https://github.com/kcl-lang/kubectl-kcl) to separate data and logic.
- **Production-ready**: Widely used in production practice of platform engineering and automation at Ant Group.

Although KCL is not a general language, it has corresponding application scenarios. Developers can write **config**, **schema**, **function** and **rule** through KCL, where config is used to define data, schema is used to describe the model definition of data, rule is used to validate data, and schema and rule can also be combined to use models and constraints that fully describe data, In addition, we can also use the lambda pure function in KCL to organize data code, encapsulate common code, and call it directly when needed.

The configuration of attributes in KCL usually meets the simple pattern:

$$
k\ o \ (T) \ v
$$

where $k$ is the attribute name, $v$ is the attributes value, and $T$ is the type annotation. Since KCL has the ability of the type inference, $T$ is usually omitted.

This is an example of generating kubernetes manifests.

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

### vs. Kustomize

The key feature of Kustomize is its ability to overlay files at a granular level. However, it faces challenges with multiple overlay chains as a specific attribute value may not be the final value, as it can be overridden by another value elsewhere. Retrieving the inheritance chain of Kustomize files can be less convenient than retrieving the inheritance chain of KCL code, particularly for complex scenarios where careful consideration of the specified configuration file overwrite order is necessary. Additionally, Kustomize does not address issues related to YAML configuration writing, constraint verification, model abstraction, and development, making it more suited for simpler configuration scenarios.

In contrast, KCL offers fine-grained configuration merge operations for each attribute in the code, with flexible merge strategy settings that are not limited to overall resources. KCL also allows for static analysis of configuration dependencies through import statements.

### vs. Helm

The idea behind Helm can be traced back to the package management system used in operating systems. It is a package management tool that relies on templated YAML files to execute and manage resources within packages.

KCL provides a greater range of capabilities than Helm, making it a viable alternative. Users who have already adopted Helm can still utilize KCL by packaging the stack compilation results in a Helm format or by using the Helm-KCL plugin to programmatically extend existing Helm charts.

### vs. CDK

CDK's high-level language integrates well into application projects, effectively becoming part of the client runtime. In contrast, KCL decouples external configurations and policies written using KCL from the client runtime.

General-purpose languages can often be over-engineered, going beyond the requirements of the problem being solved. These languages can also present various security issues, such as problems with the ability boundary, such as accessing I/O, network, code infinite looping, and other security risks. In specialized fields, such as music, there are special notes used to communicate effectively, which cannot be expressed clearly in general-purpose languages.

Furthermore, general-purpose languages come in a variety of styles, which can create challenges in terms of unified maintenance, management, and automation. These languages are generally better suited to writing the client runtime, which is a continuation of the server runtime. They are not ideal for writing configurations that are independent of the runtime, as they are compiled into binaries and started from the process, making stability and scalability challenging to control. In contrast, configuration languages are often used to write data combined with simple logic, and they describe the expected final result, which is then consumed by the compiler or engine.

### vs. OPA/Rego

While not originally intended as a data definition language, Rego, the language used for Open Policy Agent (OPA), can also address the issue of adding constraints from multiple sources.

Rego has its roots in logic programming and is based on Datalog, a restricted form of Prolog. Rego excels as a query language, but it can be cumbersome for constraint enforcement, in that values must be queried before applying constraints. Besides, Rego itself does not have the ability to define a schema. You can introduce JsonSchema definitions in Rego's comments when needed.

KCL's approach to constraint validation is more conducive to finding normalized and simplified representations of constraints, making it well-suited for creating structures generated from OpenAPI.
