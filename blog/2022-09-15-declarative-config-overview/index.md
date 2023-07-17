---
slug: 2022-declarative-config-overview
title: The Landscape of Declarative Configuration
authors:
  name: Pengfei, Xu
  title: KCL Team Member
tags: [KCL, Configuration]
---

The blog is only used to clarify the landscape of declarative configuration, [KCL](https://github.com/kcl-lang/kcl) core concept and features, as well as the comparison with other configuration languages.

## 1. The Landscape of Declarative Configuration

### 1.1 Importance of Configuration

- There are thousands of configuration updates every day because the software development and the configuration itself are gradually evolving, which has a high demand for large-scale efficiency.
  - **The configuration is updated more frequently**: The evolving business requirements, infrastructure requirements and other factors mean that the system needs to change constantly, and the configuration provides a low-cost way to change the system functions.
  - **The configuration scale is getting larger**: A configuration is often distributed to different cloud sites, different tenants, different environments, etc.
  - **Wide configuration scenarios**: Application, database, network, monitoring, etc.
  - **Various configuration formats**: JSON, YAML, XML, TOML, various configuration templates such as Java Velocity, Go Template, etc.
- The stability of the configuration is crucial. One of the main reasons for system errors is that a large number of engineers frequently update the configuration. Table 1 shows several system error events caused by configuration.

| Time | Event |
| --- | --- |
| 2021.07 | The Bilibili website in China went down because SLB Lua configuration code fell into an infinite loop with calculation errors |
| 2021.10 | KT Company in South Korea suffers major network interruption nationwide due to wrong routing configuration |

Table 1 System error events caused by configuration.

### 1.2 Classification of Declarative Configuration

The cloud-native era has brought about rapid technological development, with a large number of declarative configurations. As shown in Fig. 1, declarative configuration can be generally divided into the following ways.

![](/img/blog/2022-09-15-declarative-config-overview/01-declarative-config.png)

Fig. 1: Classification of declarative configuration.

#### 1.2.1 Structured K-V

Structured K-V meets the minimum data declaration requirements (int, string, list, dict, etc.). Declarative API meets the development demands of X as Data with the rapid development and application of cloud-native technology. Machine-readable and writable, human-readable.

- Pros.
  - Simple syntax, easy to write and read.
  - Rich multilingual APIs.
  - Various path tools for data query, such as XPath, JsonPath, etc.
- Cons.
  - Too much redundant information: when the configuration scale is large, it is difficult to maintain the configuration, because important configuration information is hidden in a large number of irrelevant repetitive data details.
  - Lack of functionality: constraint, complex logic, test, debug, abstraction, etc.
  - [Kustomize](https://kustomize.io/)'s patches are basically by fixing several patch merge strategies

Representative technologies of structured KV include:

- JSON/YAML: It is very convenient for reading and automation, and has different languages API support.
- [Kustomize](https://kustomize.io/): It provides a solution to customize the Kubernetes resource base configuration and differential configuration without **template** and **DSL**. It does not solve the constraint problem itself, but needs to cooperate with a large number of additional tools to check constraints, such as [Kube-linter](https://github.com/stackrox/kube-linter)、[Checkov](https://github.com/bridgecrewio/checkov). Fig. 2shows the typical working mode of Kustomize.

![](/img/blog/2022-09-15-declarative-config-overview/02-kustomize.png)

Fig. 2: Typical working mode of Kustomize.

#### 1.2.3 Templated K-V

The Templated KV has the capability of static configuration data and dynamic parameters, and can output different static configuration data with one template+dynamic parameters. The advantages and disadvantages are as follows:

- Pros.
  - Simple configuration logic and loop support.
  - External dynamic parameter support.
- Cons.
  - It is easy to fall into the trap that all configurations are template parameters.
  - When the configuration scale becomes larger, it is difficult for developers and tools to maintain and analyze them.

Representative technologies of templated KV include:

- [Helm](https://helm.sh/): The package management tool of Kubernetesresources, which manages the configuration of Kubernetes resources through the configuration template. Fig. 3 shows a Helm Jenkins Package ConfigMap configuration template. It can be seen that these templates are very short with simple logic. A series of resource configurations suitable forKubernetes basic components are installed through package management and additional configuration parameters. Compared with the simply templatedK-V, Helm provides template storage, reference and semantic version management capabilities. Compared with Kustomize, Helm is more suitable for managing external Charts but is not good at multi-environment and multi-tenant configuration management.
- Other configuration templates: Java Velocity, Go Template and other text template engines are very suitable for HTML writing templates. However,when used in configuration scenarios, they are difficult for developers and tools to maintain and analyze.

![](/img/blog/2022-09-15-declarative-config-overview/03-helm.png)

Fig. 3: Helm Jenkins Package ConfigMap configuration template.

#### 1.2.3 Programmable K-V

`Configuration as Code (CaC)` uses code to generate configuration, just like engineers only need to write advanced GPL code, rather than manually writing error-prone and difficult-to-understand server binary code.

- Configuration changes are treated as seriously as code changes, and unit tests and integration tests can also be executed.
- Code modularization is a key reason why maintaining configuration code is easier than manually editing configuration files such as JSON/YAML.

- Capability
  - Necessary programming language abilities (variable definitions, logical judgments, loops, assertions, etc.).
  - Necessary template capability, which supports the definition of data templates and the use of templates to obtain new configuration data.
  - Code modularity: structure definition and package management.
  - Machine-readable and writable, human-readable and writable.
- Pros.
  - Necessary programming ability.
  - Code modularization and abstraction.
  - Configuration template and override ability.
- Cons.
  - Insufficient type check.
  - Insufficient constraint capacity.
  - Many runtime errors.

Representative technologies of programmable KV include:

- [GCL](https://github.com/rix0rrr/gcl): A declarative configuration programming language implemented in Python provides the necessary language capabilities to support template abstraction. However, the compiler itself is written in Python, and the language itself is interpreted and executed. For large template instances (such as Kubernetes models), the performance is poor.
- [HCL](https://github.com/hashicorp/hcl): A Go implementation structured configuration language. The native syntax of HCL is inspired by libucl and nginx configurations. It is used to create a structured configuration language that is friendly to humans and machines, mainly for DevOps tools, server configurations, and resource configurations as a [Terraform language](https://www.terraform.io/language).
- [Jsonnet](https://github.com/google/jsonnet): A data template language implemented in C++, suitable for application and tool developers, can generate configuration data and organize, simplify and manage large configurations without side effects.

#### 1.2.4 Typed K-V

- Capability
  - Based on programmable K-V, typed K-V has more capabilities of type constraints.
- Pros.
  - The configuration merge is completely idempotent, which naturally prevents configuration conflicts.
  - Rich constraint syntax for writing configuration.
  - Abstract the type and value constraints into the same form, which is simple to write.
  - Configuration order independent.
- Cons.
  - The concepts of graph merging and idempotent merging are complex, and the understanding cost is high.
  - The mixed definition of type and value improves the degree of abstraction and the cost of understanding. All constraints are checked at runtime, and there is a performance bottleneck for the large-scale configuration code.
  - It is difficult to implement multi-tenant and multi-environment scenarios that want to configure coverage and modification.
  - For constrained scenarios with conditions, the user interface for writing hybrid definitions of definition and verification is unfriendly.

Representative technologies of typed KV include:

- [CUE](https://github.com/cue-lang/cue): The core problem CUE solves is "type checking", which is mainly used in configuration constraint verification scenarios and simple cloud native configuration scenarios.

#### 1.2.5 Modeled K-V

- Pros.
  - High-level language modeling capability as the core description
    - Modeling
    - Immutability
    - Constraints
  - High scalability through automatic merge mechanism of isolated config blocks.
  - Writing and testing methods like a high-level programming language.
  - Machine-readable and writable, human-readable and writable.
- Cons.
  - The expansion of new models and ecological construction requires certain R&D costs

Representative technologies of modeled KV include:

- [KCL](https://github.com/kcl-lang/kcl): A declarative configuration and policy programming language implemented by Rust, which improves the writing of a large number of complex configurations through mature programming language technology and practice, and is committed to building better modularity, scalability and stability around configuration, simpler logic writing, fast automation and good ecological extensionally. Fig. 4 shows a typical scenario of KCL writing application delivery configuration code.

![](/img/blog/2022-09-15-declarative-config-overview/04-kcl-app-code.png)

Fig. 4: A typical scenario of KCL writing application delivery configuration code.

### 1.3 Guidelines and Best Practices for Different Declarative Configurations

- Configuration scale: For small-scale configuration scenarios, we can use YAML/JSON and other configurations, such as the simple configuration of the application itself and CI/CD configuration. In addition, for the requirements of multi-environment and multi-tenant in small-scale configuration scenarios, Kustomize's overlay capability can be used to implement operations such as merging and covering simple configurations.

- The necessity of model abstraction and constraint: For large-scale configuration scenarios, especially for those with urgent needs for configuration model and O&M feature R&D and precipitation of multi-tenant and multi-environment, the K-V method of coding, typing and modeling can be used.

In addition, consider the use scenarios of different declarative configurations:

- YAML is recommended if you need to write structured static K-V or use Kubernetes' native tools.
- HCL is recommended if you want to use programming language convenience to remove boilerplate with good human readability, or if you are already a Terraform user.
- CUE is recommended if you want to use a type system to improve stability and maintain scalable configurations.
- KCL is recommended if you want types and modelings like a modern language, scalable configurations, in-house pure functions and rules, and production-ready performance and automation.

Different from other languages of the same type in the community, KCL is a static strongly typed compilation language for application developers and adopts modern language design and technology.

> Note that this blog will not discuss the general language used for writing configuration. The general language is usually overkill, that is, it goes far beyond the problems that need to be solved. There are various security problems in the general language, such as the ability boundary problem (starting local threads, accessing IO, network, code infinitive looping and other security risks). For example, in the music field, there are special notes to express music, which is convenient for learning and communication, It can not be expressed clearly in general language.
>
> In addition, because of its various styles of the general language, which has the cost of unified maintenance, management and automation. The general language is usually used to write the client runtime, which is a continuation of the server runtime. It is not suitable for writing configurations that are independent of the runtime, and it is compiled into binary and started from the process finally. Besides, the stability and scalability are not easy to control. However, the configuration language often be used to write data, which is combined with simple logic, and it describes the expected final result, which is then consumed by the compiler or engine.

## 2. KCL Core Features and Use Cases

The core features of KCL are its **modeling** and **constraint** capabilities, and the basic functions of KCL revolve around the two core features. In addition, KCL follows the user-centric configuration concept to design its basic functions, which can be understood from two aspects:

- **Domain model-centric configuration view**: With the rich features of KCL language and [KCL OpenAPI](https://kcl-lang.io/docs/tools/cli/openapi/) tools, we can directly integrate a wide range of well-designed models in the community into KCL (such as the K8s resource model). We can also design and implement our own KCL models or libraries according to different scenarios, forming a complete set of domain models for other configuration end users to use.
- **End user-centric configuration view**: With KCL's code encapsulation, abstraction and reuse capabilities, the model architecture can be further abstracted and simplified (for example, the K8s resource model is abstracted into an application-centered server model) to **minimize the end user configuration input**, simplify the user's configuration interface, and facilitate manual or automatic API modification.

No matter what configuration view is centered on, for configuration code, there are requirements for configuration data constraints, such as type constraints, required/optional constraints on configuration attributes, range constraints, and immutability constraints. This is also one of the core issues KCL is committed to solving. KCL mainly contains the core features shown in Fig. 5.

![](/img/blog/2022-09-15-declarative-config-overview/05-kcl-core-feature.png)

Fig. 5: KCL core features.

- **Easy-to-use**: Originated from high-level languages ​​such as Python and Golang, incorporating functional language features with low side effects.
- **Well-designed**: Independent Spec-driven syntax, semantics, runtime and system modules design.
- **Quick modeling**: [Schema](https://kcl-lang.io/docs/reference/lang/tour#schema)-centric configuration types and modular abstraction.
- **Rich capabilities**: Configuration with type, logic and policy based on [Config](https://kcl-lang.io/docs/reference/lang/tour#config-operations), [Schema](https://kcl-lang.io/docs/reference/lang/tour#schema), [Lambda](https://kcl-lang.io/docs/reference/lang/tour#function), [Rule](https://kcl-lang.io/docs/reference/lang/tour#rule).
- **Stability**: Configuration stability built on [static type system](https://kcl-lang.io/docs/reference/lang/tour/#type-system), [constraints](https://kcl-lang.io/docs/reference/lang/tour/#validation), and [rules](https://kcl-lang.io/docs/reference/lang/tour#rule).
- **Scalability**: High scalability through [automatic merge mechanism](https://kcl-lang.io/docs/reference/lang/tour/#-operators-1) of isolated config blocks.
- **Fast automation**: Gradient automation scheme of [CRUD APIs](https://kcl-lang.io/docs/reference/lang/tour/#kcl-cli-variable-override), [multilingual SDKs](https://kcl-lang.io/docs/reference/xlang-api/overview), [language plugin](https://github.com/kcl-lang/kcl-plugin)
- **High performance**: High compile time and runtime performance using Rust & C and [LLVM](https://llvm.org/), and support compilation to native code and [WASM](https://webassembly.org/).
- **API affinity**: Native support API ecological specifications such as [OpenAPI](https://github.com/kcl-lang/kcl-openapi), Kubernetes CRD, Kubernetes YAML spec.
- **Development friendly**: Friendly development experiences with rich [language tools](https://kcl-lang.io/docs/tools/cli/kcl/) (Format, Lint, Test, Vet, Doc, etc.) and [IDE plugins](https://github.com/kcl-lang/vscode-kcl).
- **Safety & maintainable**: Domain-oriented, no system-level functions such as native threads and IO, low noise and security risk, easy maintenance and governance.
- **Rich multi-language SDK**: [Go](https://kcl-lang.io/docs/reference/xlang-api/go-api), [Python](https://kcl-lang.io/docs/reference/xlang-api/python-api) and [REST APIs](https://kcl-lang.io/docs/reference/xlang-api/rest-api) meet different scenarios and application use prelude.
- **Production-ready**: Widely used in production practice of platform engineering and automation at Ant Group.

![](/img/blog/2022-09-15-declarative-config-overview/06-kcl-code-design.png)

Fig. 6: KCL core design.

For more language design and capabilities, see [KCL Documents](https://kcl-lang.io/docs/reference/lang/tour). Although KCL is not a general language, it has corresponding application scenarios. As shown in Fig. 6, developers can write **config**, **schema**, **function** and **rule** through KCL, where config is used to define data, schema is used to describe the model definition of data, rule is used to validate data, and schema and rule can also be combined to use models and constraints that fully describe data, In addition, we can also use the lambda pure function in KCL to organize data code, encapsulate common code, and call it directly when needed.

For use cases, KCL can perform structured K-V data validation complex configuration model definition and abstraction, strong constraint verification to avoid configuration errors, automation integration and engineering expansion. These features and use cases are described below.

### 2.1 Validation of Structured Data

As shown in Fig 7, KCL supports format validation of JSON/YAML data. As a configuration language, KCL covers almost all features of OpenAPI in terms of validation. In KCL, the configuration data can be constrained by a structure definition. At the same time, it supports user-defined constraint rules through check blocks, and writing validation expressions in the schema to verify and constrain the attributes defined in the schema. The check expression can be used to clearly and simply verify whether the input JSON/YAML meets the corresponding schema structure definition and check constraints.

![](/img/blog/2022-09-15-declarative-config-overview/07-kcl-validation.png)

Fig. 7: Validation of structured data in KCL.

Based on this, KCL provides the corresponding [Validation Tool](https://kcl-lang.io/docs/tools/cli/kcl/vet) to validate JSON/YAML data directly. In addition, based on this capability, we can build a K-V validation visualization product as shown in Fig. 8.

![](/img/blog/2022-09-15-declarative-config-overview/08-kcl-validation-ui.png)

Fig. 8: A K-V validation visualization product based on KCL.

### 2.2 Definition and Abstraction of Complex Configuration Model

As shown in Fig 9, with the help of the [KCL OpenAPI](https://kcl-lang.io/docs/tools/cli/openapi/) tool, we can directly integrate a wide range of well-designed models.

![](/img/blog/2022-09-15-declarative-config-overview/09-kcl-modeling.png)

Fig. 9: General way of KCL complex configuration modeling.

As shown in Figure 10, [Konfig](https://github.com/KusionStack/konfig) is used to manage all KCL configuration codes, the business configuration code and basic configuration code are stored in a mono repo, which facilitates the version dependency management between codes, and the automatic system processing is relatively simple. It is sufficient to locate the directory and files of the unique code base. The codes are interconnected, managed uniformly, and easy to find, modify, and maintain. Besides, the unified CI/CD process can be used for configuration management.

![](/img/blog/2022-09-15-declarative-config-overview/10-kcl-konfig.png)

Fig. 10: Using KCL's language capabilities to integrate domain models and user models.

### 2.3 Strong Constraint to Avoid Errors

As shown in Fig. 11, configuration errors can be avoided through strong constraint-checking methods in KCL.

![](/img/blog/2022-09-15-declarative-config-overview/11-kcl-constraint.png)

Fig. 11: Strong constraint checking methods in KCL.

- The KCL language's type system is designed to be static. Type and value definitions are separated. Type derivation and type checking at compile time are supported. Static types can not only analyze most type errors at compile time in advance, but also reduce the performance loss of dynamic type checking at runtime. In addition, the attributes of the KCL schema are forced to be not null, which can effectively avoid configuration omissions.
- When KCL configurations to be exported are declared, their types and values cannot change. This static feature ensures that the configuration will not be tampered with at will.
- KCL supports further ensuring stability through the built-in validation rules of the structure. For example, Fig. 12 shows that the KCL code defines the constraints for `containerPort`, `services`, and `volumes` in `App`.

![](/img/blog/2022-09-15-declarative-config-overview/12-kcl-app-schema.png)

Fig. 12: KCL code validation with constraint rules.

### 2.4 Isolated Configuration Block Merging

KCL provides the ability to write isolated configuration blocks and automatically merge them, and supports idempotent merge, patch merge, and other strategies. Multiple configurations in idempotent merging need to meet the exchange law, and developers need to manually handle configuration conflicts between base and different environments. The patch merging includes overlay, deletion and addition. KCL simplifies the collaborative development on the user side and reduces the coupling between configurations through multiple merging strategies.

![](/img/blog/2022-09-15-declarative-config-overview/13-kcl-isolated-config.png)

Fig. 13: Multi-environment scenario configuration block writing.

### 2.5 Automation

KCL provides many automation-related capabilities, mainly including tools and multilingual APIs. Via `package_identifier : key_identifier` mode, KCL supports the indexing of any configured key value, thus completing the addition, deletion, modification and query of any key value. For example, Fig 14. shows that we can directly execute the following command to modify the image. The code diff before and after modification is also shown in Fig. 14.

![](/img/blog/2022-09-15-declarative-config-overview/14-kcl-image-update.png)

Fig. 14: Automatic modification of application configuration image via KCL CLI/API.

In addition, the automation capability of KCL can be realized and integrated into CI/CD as shown in Fig. 15.

![](/img/blog/2022-09-15-declarative-config-overview/15-kcl-automation.png)

Fig. 15: Typical KCL automation integration.

## 3. Comparison between KCL and Other Declarative Configurations

### 3.1 vs. JSON/YAML

YAML/JSON configurations are suitable for small-scale configuration scenarios. For large-scale cloud native configuration scenarios that need frequent modifications, they are more suitable for KCL. The main difference involved is the difference between configuration data abstraction and deployment:

The advantages of using KCL for configuration are: for static data, the advantage of abstracting one layer means that the overall system has **deployment flexibility**. Different configuration environments, tenants, and runtime may have different requirements for static data, and even different organizations may have different specifications and product requirements. KCL can be used to expose the most needed and frequently modified configurations to users.

### 3.2 vs. Kustomize

The core capability of Kustomize is its file-level overlay capability. However, there is a problem with multiple overlay chains, because finding the statement of a specific attribute value does not guarantee that it is the final value, because another specific value that appears elsewhere can override it. For complex scenarios, retrieval of the inheritance chain of Kustomize files is often not as convenient as retrieval of the inheritance chain of KCL code, The specified configuration file overwrite order needs to be carefully considered. In addition, Kustomize cannot solve the problems of YAML configuration writing, constraint verification, model abstraction and development, and is more suitable for simple configuration scenarios.

In KCL, the configuration merge operation can be fine-grained to each configuration attribute in the code, and the merge strategy can be flexibly set, not limited to the overall resource, and the dependency between configurations can be statically analyzed through the import statement of KCL.

### 3.3 vs. HCL

#### 3.3.1 Features

|  | HCL | KCL |
| --- | --- | --- |
| Modeling | The user interface is not directly perceived through the Terraform provider Schema definition. In addition, the user interface is cumbersome when writing complex object and required/optional field definitions. | Modeling through KCL schema, and achieve high model abstraction through language level engineering and some object-oriented features. |
| Constraint | The dynamic parameters are constrained by the condition field of the variable. The constraints of the resource itself need to be defined by provider schema or combined with Sentinel/Rego and other policy languages. The integrity of the language itself cannot be self closed, and its implementation methods are not unified | Define structures and constraints in a unified way. |
| Scalability | Terraform HCL overrides by file. The mode is fixed and the capability is limited. | KCL can customize the configuration block writing method and multiple strategies to meet the requirements of complex multi-tenant and multi-environment configuration scenarios. |
| Code writing | The user interface is complicated when writing complex object definitions and required/optional field definitions. | Complex structure definitions and constraint are easy to write without using other GPLs or tools. |

#### 3.3.2 Examples

**Terraform HCL variable vs. KCL schema**

- HCL

```python
variable "subnet_delegations" {
  type = list(object({
    name               = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))
  default     = null
  validation {
    condition = var.subnet_delegations == null ? true : alltrue([for d in var.subnet_delegations : (d != null)])
  }
  validation {
    condition = var.subnet_delegations == null ? true : alltrue([for n in var.subnet_delegations.*.name : (n != null)])
  }
  validation {
    condition = var.subnet_delegations == null ? true : alltrue([for d in var.subnet_delegations.*.service_delegation : (d != null)])
  }
  validation {
    condition = var.subnet_delegations == null ? true : alltrue([for n in var.subnet_delegations.*.service_delegation.name : (n != null)])
  }
}
```

- KCL

```python
schema SubnetDelegation:
    name: str
    service_delegation: ServiceDelegation

schema ServiceDelegation:
    name: str  # Required attributes
    actions?: [str]  # Optional attributes

subnet_delegations: [SubnetDelegation] = option("subnet_delegations")
```

**Terraform HCL Function vs. KCL Lambda**

- As shown in [https://www.terraform.io/language/functions](https://www.terraform.io/language/functions) and [https://github.com/hashicorp/terraform/issues/27696](https://github.com/hashicorp/terraform/issues/27696)，Terraform HCL provides rich built-in functions, but it does not support users to define functions in Terraform (or need to write complex Go providers to simulate local user-defined functions); KCL not only supports users to use the lambda keyword to directly define functions in KCL code, but also supports the use of Python, Go and other languages to write [plugins](https://kcl-lang.io/docs/reference/plugin/overview).

- Defining functions and calling them in KCL

```python
add_func = lambda x: int, y: int -> int {
    x + y
}
two = add_func(1, 1)  # 2
```

**Remove null values in HCL vs. Remove null values in KCL**

- HCL

```python
variable "conf" {
  type = object({
    description = string
    name        = string
    namespace   = string
    params = list(object({
      default     = optional(string)
      description = string
      name        = string
      type        = string
    }))
    resources = optional(object({
      inputs = optional(list(object({
        name = string
        type = string
      })))
      outputs = optional(list(object({
        name = string
        type = string
      })))
    }))
    results = optional(list(object({
      name        = string
      description = string
    })))
    steps = list(object({
      args    = optional(list(string))
      command = optional(list(string))
      env = optional(list(object({
        name  = string
        value = string
      })))
      image = string
      name  = string
      resources = optional(object({
        limits = optional(object({
          cpu    = string
          memory = string
        }))
        requests = optional(object({
          cpu    = string
          memory = string
        }))
      }))
      script     = optional(string)
      workingDir = string
    }))
  })
}

locals {
  conf = merge(
    defaults(var.conf, {}),
    { for k, v in var.conf : k => v if v != null },
    { resources = { for k, v in var.conf.resources : k => v if v != null } },
    { steps = [for step in var.conf.steps : merge(
      { resources = {} },
      { for k, v in step : k => v if v != null },
    )] },
  )
}
```

- KCL (using `-n` flag)

```python
schema Param:
    default?: str
    name: str

schema Resource:
    cpu: str
    memory: str

schema Step:
    args?: [str]
    command?: [str]
    env?: {str:str}
    image: str
    name: str
    resources?: {"limits" | "requests": Resource}
    script?: str
    workingDir: str

schema K8sManifest:
    name: str
    namespace: str
    params: [Param]
    results?: [str]
    steps: [Step]

conf: K8sManifest = option("conf")
```

To sum up, in KCL, its types and constraints are defined in a declarative way through schema. It can be seen that compared with Terraform HCL, KCL constraints can be written more simply when the same functions are implemented (validation and condition fields do not need to be written repeatedly like Terraform), In addition, it provides the ability to set fields as optional (unlike the Terraform configuration field, which can be null by default).

### 3.4 vs. CUE

#### 3.4.1 Features

|  | CUE | KCL |
| --- | --- | --- |
| Modeling | Modeling through struct, no inheritance and other features, can achieve high abstraction when there is no conflict between model definitions. Because CUE performs all constraint checks at runtime, there may be performance bottlenecks in large-scale modeling scenarios. | Modeling is conducted through KCL schema, and high model abstraction can be achieved through language level engineering and some object-oriented features (such as single inheritance). KCL is a statically compiled language with low overhead for large-scale modeling scenarios. |
| Constraint | CUE combines types and values into one concept. It simplifies the writing of constraints through various syntax. For example, generic types and enumerations are not required. Summing types and null value merging are the same thing. | KCL provides a richer check declarative constraint syntax, which makes it easier to write. For some configuration field combination constraints, it is simpler to write (compared with CUE, KCL provides more if guard combination constraints, all/any/map/filter and other collection constraint writing methods, which makes it easier to write) |
| Scalability | CUE supports configuration merging but it is completely idempotent. It may not meet the requirements of complex multi-tenant and multi- environment configuration scenarios | KCL can customize the configuration block writing method and multiple strategies to meet the requirements of complex multi-tenant and multi-environment configuration scenarios. |
| Code writing | For complex loop and constraint scenarios, it is complex to write, and it is cumbersome to write scenarios that require accurate configuration modifications. | Complex structure definition, loop, and conditional constraint scenarios are easy to write. |

#### 3.4.2 Examples

**CUE constraint vs. KCL constraint**

CUE (run `cue export base.cue prod.cue`)

- base.cue

```cue
// base.cue
import "list"

#App: {
    domainType: "Standard" | "Customized" | "Global",
    containerPort: >=1 & <=65535,
    volumes: [...#Volume],
    services: [...#Service],
}

#Service: {
    clusterIP: string,
    type: string,

    if type == "ClusterIP" {
        clusterIP: "None"
    }
}

#Volume: {
    container: string | *"*"  // The default value of `container` is "*"
    mountPath: string,
    _check: false & list.Contains(["/", "/boot", "/home", "dev", "/etc", "/root"], mountPath),
}

app: #App & {
    domainType: "Standard",
    containerPort: 80,
    volumes: [
        {
            mountPath: "/tmp"
        }
    ],
    services: [
        {
            clusterIP: "None",
            type: "ClusterIP"
        }
    ]
}

```

- prod.cue

```python
// prod.cue
app: #App & {
    containerPort: 8080,  // error: app.containerPort: conflicting values 8080 and 80:
}
```

KCL (run `kcl base.k prod.k`)

- base.k

```python
# base.k
schema App:
    domainType: "Standard" | "Customized" | "Global"
    containerPort: int
    volumes: [Volume]
    services: [Service]

    check:
        1 <= containerPort <= 65535

schema Service:
    clusterIP: str
    $type: str

    check:
        clusterIP == "None" if $type == "ClusterIP"

schema Volume:
    container: str = "*"  # The default value of `container` is "*"
    mountPath: str

    check:
        mountPath not in ["/", "/boot", "/home", "dev", "/etc", "/root"]

app: App {
    domainType = "Standard"
    containerPort = 80
    volumes = [
        {
            mountPath = "/tmp"
        }
    ]
    services = [
        {
            clusterIP = "None"
            $type = "ClusterIP"
        }
    ]
}

```

- prod.k

```python
# prod.k
app: App {
    # Using `=` attribute operator to modify the `containerPort` of the base `app`.
    containerPort = 8080
    # Using `+=` attribute operator to add volumes of the base `app`.
    # Here, it means to add one volume in the prod environment.
    volumes += [
        {
            mountPath = "/tmp2"
        }
    ]
}
```

In addition, due to the idempotent merge feature of CUE, it is not easy to use an overlay configuration similar to Kustomize to override the additional capability in scenarios, such as the above CUE code will report a conflict error.

### 3.5 Performance

KCL performs better than CUE/Jsonnet/HCL and other languages in scenarios with large code size or high computation load (CUE and other languages are limited by the runtime constraint checking overhead, while KCL is a statically compiled language).

- CUE (test.cue)

```cue
import "list"

temp: {
        for i, _ in list.Range(0, 10000, 1) {
                "a\(i)": list.Max([1, 2])
        }
}
```

- KCL (test.k)

```python
a = lambda x: int, y: int -> int {
    max([x, y])
}
temp = {"a${i}": a(1, 2) for i in range(10000)}
```

- Jsonnet (test.jsonnet)

```jsonnet
local a(x, y) = std.max(x, y);
{
    temp: {["a%d" % i]: a(1, 2) for i in std.range(0, 10000)},
}
```

- Terraform HCL (test.tf. Since the terraform `range` function only supports up to 1024 iterators, the `range(10000)` is divided into 10 sub ranges)

```python
output "r1" {
  value = {for s in range(0, 1000) : format("a%d", s) => max(1, 2)}
}
output "r2" {
  value = {for s in range(1000, 2000) : format("a%d", s) => max(1, 2)}
}
output "r3" {
  value = {for s in range(1000, 2000) : format("a%d", s) => max(1, 2)}
}
output "r4" {
  value = {for s in range(2000, 3000) : format("a%d", s) => max(1, 2)}
}
output "r5" {
  value = {for s in range(3000, 4000) : format("a%d", s) => max(1, 2)}
}
output "r6" {
  value = {for s in range(5000, 6000) : format("a%d", s) => max(1, 2)}
}
output "r7" {
  value = {for s in range(6000, 7000) : format("a%d", s) => max(1, 2)}
}
output "r8" {
  value = {for s in range(7000, 8000) : format("a%d", s) => max(1, 2)}
}
output "r9" {
  value = {for s in range(8000, 9000) : format("a%d", s) => max(1, 2)}
}
output "r10" {
  value = {for s in range(9000, 10000) : format("a%d", s) => max(1, 2)}
}
```

- Running time (considering the actual resource cost of the production environment, this test is subject to the single core).

| Environment | KCL v0.4.3 Running time (including compilation+runtime) | CUE v0.4.3 Running time (including compilation+runtime) | Jsonnet v0.18.0 Running time (including compilation+runtime)  | HCL in Terraform v1.3.0 Running time (including compilation+runtime) |
| --- | --- | --- | --- | --- |
| OS: macOS 10.15.7; CPU: Intel(R) Core(TM) i7-8850H CPU @ 2.60GHz; Memory: 32 GB 2400 MHz DDR4; no NUMA | 440 ms (kcl test.k) | 6290 ms (cue export test.cue) | 3340 ms (jsonnet test.jsonnet) | 1774 ms (terraform plan -parallelism=1) |

#### Another Complex Case

Using KCL and CUE to write Kubernetes configuration.

- CUE (test.cue)

```cue
package templates

import (
 apps "k8s.io/api/apps/v1"
)

deployment: apps.#Deployment

deployment: {
 apiVersion: "apps/v1"
 kind:       "Deployment"
 metadata: {
  name:   "me"
  labels: me: "me"
 }
}
```

- KCL (test.k)

```python
import kubernetes.api.apps.v1

deployment = v1.Deployment {
    metadata.name = "me"
    metadata.labels.name = "me"
}
```

| Environment | KCL v0.4.3 Running time (including compilation+runtime) | CUE v0.4.3 Running time (including compilation+runtime) |
| --- | --- | --- |
| OS: macOS 10.15.7; CPU: Intel(R) Core(TM) i7-8850H CPU @ 2.60GHz; Memory: 32 GB 2400 MHz DDR4; no NUMA | 140 ms (kcl test.k) | 350 ms (cue export test.cue) |

## 4. Summary

The blog gives a landscape overview of declarative configuration technology, focusing on the KCL concept, core features, usage cases and comparison with other configuration languages, hoping to help you understand declarative configuration technology and KCL language. For more information about the concept, background and design of KCL, please visit the [KCL website](https://kcl-lang.io/)

## 5. Reference

- KusionStack Cloud Native Configuration Practice Blog: [https://kusionstack.io/blog/2021-kusion-intro](https://kusionstack.io/blog/2021-kusion-intro)
- Terraform Language: [https://www.terraform.io/language](https://www.terraform.io/language)
- Terraform Provider Kubernetes: [https://github.com/hashicorp/terraform-provider-kubernetes](https://github.com/hashicorp/terraform-provider-kubernetes)
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
- Jsonnet: [https://github.com/google/jsonnet](https://github.com/google/jsonnet)
- Dhall: [https://github.com/dhall-lang/dhall-lang](https://github.com/dhall-lang/dhall-lang)
- Thrift: [https://github.com/Thriftpy/thriftpy2](https://github.com/Thriftpy/thriftpy2)
- Kustomize: [https://kustomize.io/](https://kustomize.io/)
- Kube-linter: [https://github.com/stackrox/kube-linter](https://github.com/stackrox/kube-linter)
- Checkov: [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- KCL Documents: [https://kcl-lang.io/docs/reference/lang/tour](https://kcl-lang.io/docs/reference/lang/tour)
- How Terraform Works: A Visual Intro: [https://betterprogramming.pub/how-terraform-works-a-visual-intro-6328cddbe067](https://betterprogramming.pub/how-terraform-works-a-visual-intro-6328cddbe067) 
- How Terraform Works: Modules Illustrated: [https://awstip.com/terraform-modules-illustrate-26cbc48be83a](https://awstip.com/terraform-modules-illustrate-26cbc48be83a)
- Helm: [https://helm.sh/](https://helm.sh/)
- Helm vs. Kustomize: [https://harness.io/blog/helm-vs-kustomize](https://harness.io/blog/helm-vs-kustomize)
- KubeVela: [https://kubevela.io/docs/](https://kubevela.io/docs/)
