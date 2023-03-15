---
sidebar_position: 1
---

# Introduction

## What is KCL?

[Kusion Configuration Language (KCL)](https://github.com/KusionStack/KCLVM) is an open-source, constraint-based record and functional language. KCL improves the complexity of writing numerous complex configurations, such as cloud native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great ecological extensibility.

## What is Configuration?

When we deploy software systems, we do not think they are fixed. Evolving business requirements, infrastructure requirements, and other factors mean that systems are constantly changing. When we need to change the system behavior quickly, and the change process needs expensive and lengthy reconstruction and redeployment process, business code change is often not enough. Configuration can provide us with a low overhead way to change system functions. For example, we often write JSON or YAML files as shown below for our system configuration.

+ JSON configuration

```json
{
    "server": {
        "addr": "127.0.0.1",
        "listen": 4545
    },
    "database": {
        "enabled": true,
        "ports": [
            8000,
            8001,
            8002
        ],
    }
}
```

+ YAML configuration

```yaml
server:
  addr: 127.0.0.1
  listen: 4545
database:
  enabled: true
  ports:
  - 8000
  - 8001
  - 8002
```

We can choose to store the static configuration in JSON and YAML files as needed. In addition, the configuration can also be stored in a high-level language that allows more flexible configuration, which can be coded, rendered, and statically configured. KCL is such a configuration language. We can write KCL code to generate JSON/YAML and other configurations.

When we manage the Kubernetes resources, we often maintain it by hand, or use Helm and Kustomize tools to maintain our YAML configurations or configuration templates, and then apply the resources to the cluster through kubectl tools. However, as a "YAML engineer", maintaining YAML configuration every day is undoubtedly trivial and boring, and prone to errors. For example as follows:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: ... # Omit
spec:
  selector:
    matchlabels:
      cell: RZ00A
  replicas: 2
  template:
    metadata: ... # Omit
    spec:
      tolerations:
      - effect: NoSchedules
        key: is-over-quota
        operator: Equal
        value: 'true'
      containers:
      - name: test-app
          image: images.example/app:v1 # Wrong ident
        resources:
          limits:
            cpu: 2 # Wrong type. The type of cpu should be str
            memory: 4Gi
            # Field missing: ephemeral-storage
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: is-over-quota
                operator: In
                values:
                - 'true'
```

+ The structured data in YAML is untyped and lacks validation methods, so the validity of all data cannot be checked immediately.
+ YAML has poor programming ability. It is easy to write incorrect indents and has no common code organization methods such as logical judgment. It is easy to write a large number of repeated configurations and difficult to maintain.
+ The design of Kubernetes is complex, and it is difficult for users to understand all the details, such as the `toleration` and `affinity` fields in the above configuration. If users do not understand the scheduling logic, it may be wrongly omitted or superfluous added.

## Why Develop KCL?

In addition to the general configuration, the features of the cloud-native configuration include a large quantity and wide coverage. For example, Kubernetes provides a declarative Application Programming Interface (API) mechanism and the openness allows users to make full use of its resource management capabilities; however, this also implies error-prone behaviors.

+ Kubernetes configuration lacks user-side validation methods and cannot check the validity of the data.
+ Kubernetes exposes more than 500 models, more than 2,000 fields, and allows users to customize the model without considering the configuration reuse of multiple sites, multiple environments, and multiple deployment topologies. Fragmentation configuration brings many difficulties to the collaborative writing and automatic management of large-scale configuration.

KCL expects to solve the following problems in Kubernetes YAML resource management:

+ Hide infrastructure and platform details through **abstraction** to reduce the burden of developers.
+ **Additional capability enhancements such as configuration validation and editing** for configuration tools e.g., Helm, Kustomize.
+ Manage large-scale configuration data across teams without side effects through configuration language
  + Use **production level high-performance programming language** to **write code** to improve the flexibility of configuration, such as conditional statements, loops, functions, package management and other features to improve the ability of configuration reuse.
  + Improve the ability of **configuration semantic verification** at the code level, such as optional/required fields, types, ranges, and other configuration checks.
  + Provide the **ability to write, combine and abstract configuration blocks**, such as structure definition, structure inheritance, constraint definition, etc.

The cloud-native communities have made considerable attempts to advance their configuration technologies, which can be divided into three categories:

+ Low-level data format based tools for templating, patching, and validation, which use external tools to enhance the reuse and validation.
+ Domain-Specific Languages (DSLs) and Configuration Languages (CLs) to enhance language abilities.
+ General Purpose Language (GPL)-based solutions, using GPLs' Cloud-Development Kit (CDK) or framework to define the configuration.

Previous efforts do not meet all these needs. Some tools verify configuration based on the Kubernetes API. Although it supports checking missing attributes, the validation is generally weak and limited to Open Application Programming Interface (OpenAPI).
Some tools support custom validation rules, but the rule descriptions are cumbersome. In terms of configuration languages, focus on reducing boilerplates, and only a few focus on type checking, data validation, testing, etc.

Helm used parameterized template techniques to solve the problem of dynamic configuration. As the scale increases, parameterized templates tend to become complex and difficult to maintain; parameter substitution sites must be identified manually. However, it is tedious and error-prone, parameters will gradually erode the template, and any value in the template may gradually evolve into parameters. Compared with using the Kubernetes API directly, the readability of such a template combined with many parameters is often worse. Kustomize uses code patching to realize the reuse of the multi-environment configuration code.

## Overview

![](/img/docs/user_docs/intro/kcl-overview.png)

In addition to the language itself, KCL also provides many additional tools, such as formatting, testing, document, package management, to help users use, understand and check the configuration or policy they write. We can reduce the cost of configuration writing and sharing through IDE plug-ins such as VS Code and Playground. In addition, through KCL Rust, Go, and Python multilingual SDKs, the configuration can be automatically managed and executed.

## Why Use KCL?

KCL is a modern high-level domain language, which is a compiled, static and strongly typed language. It provides developers with the ability to write configuration (config), modeling abstraction (schema), business logic (lambda), and environmental policies (rule) as the core elements through recording and functional language design.

![](/img/docs/user_docs/intro/kcl-concepts.png)

KCL tries to provide runtime-independent programmability and does not natively provide system functions such as threads and IO, but supports functions for cloud-native operation scenarios, and tries to provide stable, secure, low-noise, low-side effect, easy-to-automate and easy-to-govern programming support for solving domain problems.

Unlike client runtime written in GPL, KCL programs usually run and generate low-level data and are integrated into the client-side runtime access tools, which can provide a left-shifted stability guarantee by testing and validation of KCL code separately before pushing to runtime. KCL code can also be compiled into a wasm module, which could be integrated into the server runtime after full testing.

![](/img/docs/user_docs/intro/kcl.png)

+ **Easy-to-use**: Originated from high-level languages ​​such as Python and Golang, incorporating functional language features with low side effects.
+ **Well-designed**: Independent Spec-driven syntax, semantics, runtime and system modules design.
+ **Quick modeling**: [Schema](https://kcl-lang.github.io/docs/reference/lang/tour#schema)-centric configuration types and modular abstraction.
+ **Rich capabilities**: Configuration with type, logic and policy based on [Config](https://kcl-lang.github.io/docs/reference/lang/codelab/simple), [Schema](https://kcl-lang.github.io/docs/reference/lang/tour/#schema), [Lambda](https://kcl-lang.github.io/docs/reference/lang/tour/#function), [Rule](https://kcl-lang.github.io/docs/reference/lang/tour/#rule).
+ **Stability**: Configuration stability built on [static type system](https://kcl-lang.github.io/docs/reference/lang/tour/#type-system), [constraints](https://kcl-lang.github.io/docs/reference/lang/tour/#validation), and [rules](https://kcl-lang.github.io/docs/reference/lang/tour#rule).
+ **Scalability**: High scalability through [automatic merge mechanism](https://kcl-lang.github.io/docs/reference/lang/tour/#-operators-1) of isolated config blocks.
+ **Fast automation**: Gradient automation scheme of [CRUD APIs](https://kcl-lang.github.io/docs/reference/lang/tour/#kcl-cli-variable-override), [multilingual SDKs](https://kcl-lang.github.io/docs/reference/xlang-api/overview), [language plugin](https://kcl-lang.github.io/docs/reference/plugin/overview)
+ **High performance**: High compile time and runtime performance using Rust & C and [LLVM](https://llvm.org/), and support compilation to native code and [WASM](https://webassembly.org/).
+ **API affinity**: Native support API ecological specifications such as [OpenAPI](https://kcl-lang.github.io/docs/tools/cli/openapi/), Kubernetes CRD, Kubernetes YAML spec.
+ **Development friendly**: Friendly development experiences with rich [language tools](https://kcl-lang.github.io/docs/tools/cli/kcl/overview) (Format, Lint, Test, Vet, Doc, etc.) and [IDE plugins](https://kcl-lang.github.io/docs/tools/Ide/).
+ **Safety & maintainable**: Domain-oriented, no system-level functions such as native threads and IO, low noise and security risk, easy maintenance and governance.
+ **Rich multi-language API**: Rich multilingual API: [Go](https://kcl-lang.io/docs/reference/xlang-api/go-api), [Python](https://kcl-lang.io/docs/reference/xlang-api/python-api) and [REST APIs](https://kcl-lang.io/docs/reference/xlang-api/rest-api) meet different scenarios and application use prelude.
+ **Production-ready**: Widely used in production practice of platform engineering and automation at Ant Group.

For more language design and capabilities, see [KCL Documents](https://kcl-lang.github.io/docs/reference/lang/tour). Although KCL is not a general language, it has corresponding application scenarios. Developers can write **config**, **schema**, **function** and **rule** through KCL, where config is used to define data, schema is used to describe the model definition of data, rule is used to validate data, and schema and rule can also be combined to use models and constraints that fully describe data, In addition, we can also use the lambda pure function in KCL to organize data code, encapsulate common code, and call it directly when needed.

## What is KCL for?

You can use KCL to

+ Generate low-level static configuration data like JSON, YAML, etc.
+ Reduce boilerplate in configuration data with the schema modeling.
+ Define schemas with rule constraints for configuration data and validate them automatically.
+ Organize, simplify, unify and manage large configurations without side effects.
+ Manage large configurations scalably with isolated configuration blocks.
+ Used as a platform engineering language to deliver modern app with [KusionStack](https://kusionstack.io/).

Through KCL compiler, language tools, IDE, and multilingual APIs, you can use KCL in the following scenarios:

+ **Configuration & Automation**: Abstract and manage configurations of different scales including small-scale configuration (application, network, micro service, database, monitoring, CI/CD pipeline and etc.), large-scale cloud native kubernetes configuration and automation. In addition, through [KCL OpenAPI tools](/docs/tools/cli/openapi/) and KCL's package management capabilities, we can fully abstract and reuse existing models.
+ **Security & Compliance**: Utilize the ability of KCL dynamic parameters to define, update, share, and execute policies using code. Manage policies by leveraging KCL code based automation rather than relying on manual processes, which allow teams to move faster and reduce the likelihood of errors due to human error.
+ **Intent Description**: KCL can be used to describe tools, scripts and workflows, and it accesses a customized engine to consume and execute intentions.

## How to Choose?

The simple answer:

+ YAML/JSON/Kustomize/Helm are recommended if you need to write structured key-value pairs, or use Kubernetes' native tools.
+ HCL is recommended if you want to use programming language convenience to remove boilerplate with good human readability, or if you are already a Terraform user.
+ CUE is recommended if you want to use type system to improve stability and maintain scalable configurations.
+ KCL is recommended if you want types and modeling like a modern language, scalable configurations, in-house pure functions and rules, and production-ready performance and automation.

### vs. YAML/JSON

YAML/JSON configurations are suitable for small-scale configuration scenarios. For large-scale cloud native configuration scenarios that need frequent modifications, they are more suitable for KCL. The main difference involved is the difference between configuration data abstraction and deployment:

The advantages of using KCL for configuration are: for static data, the advantage of abstracting one layer means that the overall system has deployment flexibility. Different configuration environments, tenants, and runtime may have different requirements for static data, and even different organizations may have different specifications and product requirements. KCL can be used to expose the most needed and frequently modified configurations to users.

### vs. Jsonnet/GCL

GCL is a declarative configuration programming language implemented in Python provides the necessary language capabilities to support template abstraction. However, the compiler itself is written in Python, and the language itself is interpreted and executed. For large template instances (such as kubernetes model), the performance is poor.

Jsonnet is a data template language implemented in C++, suitable for application and tool developers, can generate configuration data and organize, simplify and manage large configurations without side effects.

Jsonnet and GCL are great at reducing boilerplate. They can both uses code to generate configuration, just like engineers only need to write advanced GPL code, rather than manually writing error-prone and difficult-to-understand server binary code. Jsonnet reduces some of the complexities of GCL, but largely falls into the same category. The both have many runtime errors, insufficient type check and constraint capacity.

### vs. HCL

HCL is a Go implementation structured configuration language. The native syntax of HCL is inspired by libucl and nginx configurations. It is used to create a structured configuration language that is friendly to humans and machines, mainly for devops tools, server configurations, and resource configurations as a [Terraform language](https://www.terraform.io/language).

HCL has some striking similarities with GCL. It does introduce a poor man’s version of inheritance: file overlays. Fields may be defined in multiple files that get overwritten in a certain order of the file names. Although not nearly as complex as GCL, it does have some of the same issues. The mode is fixed and the capability is limited.

The user interface of HCL is not directly perceived through the Terraform provider Schema definition. In addition, the user interface is cumbersome when writing complex object and required/optional field definitions. The dynamic parameters are constrained by the condition field of the variable. The constraints of the resource itself need to be defined by provider schema or combined with Sentinel/Rego and other policy languages. The integrity of the language itself cannot be self closed, and its implementation methods are not unified.

### vs. CUE

CUE can be used as modeling through struct, no inheritance and other features, can achieve high abstraction when there is no conflict between model definitions. Because CUE performs all constraint checks at runtime, there may be performance bottlenecks in large-scale modeling scenarios. CUE combines types and values into one concept. It simplifies the writing of constraints through various syntax. For example, generic types and enumerations are not required. Summing types and null value merging are the same thing. CUE supports configuration merging but it is completely idempotent. It may not meet the requirements of complex multi-tenant and multi- environment configuration scenarios. For complex loop and constraint scenarios, it is complex to write, and it is cumbersome to write scenarios that require accurate configuration modifications.

For KCL, modeling is conducted through KCL schema, and high model abstraction can be achieved through language level engineering and some object-oriented features (such as single inheritance). KCL is a statically compiled language with low overhead for large-scale modeling scenarios. KCL provides a richer check declarative constraint syntax, which makes it easier to write. For some configuration field combination constraints, it is simpler to write (compared with CUE, KCL provides more if guard combination constraints, all/any/map/filter and other collection constraint writing methods, which makes it easier to write).

### vs. Dhall

Dhall is a programmable configuration language, it combines JSON, functions, types and imports. Its style is functional. If you have learned Haskell and other languages, you may be familiar with it. Compared with Dhall, KCL also provides a combination of similar functions, providing users with the ability to configure programmability and abstraction. However, KCL has made more improvements in modeling, constraint checking, automation, etc., and can share models through package management. In addition, the syntax and semantics of KCL are closer to the object-oriented language, and to some extent, it is more acceptable than the pure functional style.

### vs. Kustomize

The core capability of Kustomize is its file level overlay capability. However, there is a problem of multiple overlay chains, because finding the statement of a specific attribute value does not guarantee that it is the final value, because another specific value that appears elsewhere can override it. For complex scenarios, retrieval of the inheritance chain of Kustomize files is often not as convenient as retrieval of the inheritance chain of KCL code, The specified configuration file overwrite order needs to be carefully considered. In addition, Kustomize cannot solve the problems of YAML configuration writing, constraint verification, model abstraction and development, and is more suitable for simple configuration scenarios.

In KCL, the configuration merge operation can be fine-grained to each configuration attribute in the code, and the merge strategy can be flexibly set, not limited to the overall resource, and the dependency between configurations can be statically analyzed through the import statement of KCL.

### vs. Helm

The concept of Helm originates from the package management mechanism of the operating system. It is a package management tool based on templated YAML files and supports the execution and management of resources in the package.

KCL naturally provides a superset of Helm capabilities, so that you can use KCL directly as an alternative. For users who have adopted Helm, the stack compilation results in KCL can be packaged and used in Helm format.

### vs. CDK

Writing in CDK's high-level language can be well integrated into the application project, which is actually part of the client runtime. For KCL, external configurations and policies written by KCL are decoupled from the client runtime.

The general language is usually overkill, that is, it goes far beyond the problems that need to be solved. There are various security problems in the general language, such as the ability boundary problem (starting local threads, accessing IO, network, code infinitive looping and other security risks). For example, in the music field, there are special notes to express music, which is convenient for learning and communication, It can not be expressed clearly in general language.

In addition, because of its various styles of the general language, which has the cost of unified maintenance, management and automation. The general language is usually used to write the client runtime, which is a continuation of the server runtime. It is not suitable for writing configurations that are independent of the runtime, and it is compiled into binary and started from the process finally. Besides, the stability and scalability are not easy to control. However, the configuration language often be used to write data, which is combined with simple logic, and it describes the expected final result, which is then consumed by the compiler or engine.

### vs. OPA/Rego

Although not designed as a data definition language, Rego, the language used for Open Policy Agent (OPA), also solves the issue of being able to add constraints from multiple sources.

Rego has its roots in logic programming. It is based on Datalog, a restricted form of Prolog, whereas KCL is based on static type structure. Typed-feature structures were designed to deal with the shortcomings of Prolog for applications in encoding human languages. Using a Datalog variant for what is essentially a constraint validation task is somewhat curious. Datalog makes an excellent query language. But for constraint enforcement, it is a bit cumbersome as one effectively first needs to query values to which to apply the constraints.

Besides, KCL’s approach is more amenable to finding normalized and simplified representations of constraints, which makes it more suitable for creating OpenAPI for generated from OpenAPI.

## Next step

+ [Install KCL](/docs/user_docs/getting-started/install)
