---
slug: 2023-12-25-ten-ways-for-kubernetes-config-management
title: 10 Ways for Kubernetes Declarative Configuration Management
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Configuration, Landscape]
---

![](/img/blog/2023-12-25-ten-ways-for-kubernetes-config-management/cover.png)

Kubernetes has become the de facto standard for managing containerized applications. However, with its widespread adoption, the complexity of managing its configuration has also increased. To address this complexity, Kubernetes' declarative configuration management model has emerged to simplify this process. In this article, we will explore what Kubernetes declarative configuration is, why it is necessary, and the various ways it can be managed.

## What is Kubernetes Declarative Configuration

Kubernetes declarative configuration refers to the practice of declaring the desired state of applications and their resources in Kubernetes manifest files. Rather than issuing imperative commands to change the state of the cluster, it's easier to simply describe the expected state and let Kubernetes strive to match the actual state to the declared state. Specifically, in the declarative API, you describe "what" you want (for example, a Pod running a specific image) rather than a series of operations to achieve a certain target state ("how" to achieve it). This model simplifies system interactions because users only need to focus on the end goal without handling the specific steps to achieve it.

Kubernetes' declarative APIs are typically utilized through manifest files in YAML or JSON format. These files define the desired state of Kubernetes resources such as Pods, Services, Deployments, ConfigMaps, etc. Users submit these manifest files to the Kubernetes API server, which then has its control plane components, like controllers and schedulers, enforce these specifications and ensure that the actual state of the cluster matches them.

Declarative APIs support version control, automated deployment, rollback, scaling, and self-healing features, which significantly enhance the capability to manage large-scale, distributed systems. For example, if you want to deploy an application, you don't need to tell Kubernetes how to create each Pod, how to schedule them on nodes, or how to manage their lifecycle. Instead, you simply create a resource object like a Deployment, define the desired number of replicas and other attributes of the application containers, and then leave it to Kubernetes to handle. Kubernetes will monitor the state of this Deployment and take necessary actions to maintain or restore the desired state.

This declarative model elevates the system's level of abstraction, allowing developers and operators to focus on the application's behavior and requirements rather than the underlying operational commands and processes. As organizations adopt Kubernetes for large-scale application deployment, managing complex configurations and manifests becomes critical.

## What are the Ways to Manage Kubernetes Declarative Configuration

### Structured Key-Value Pair

Structured key-value pair meets the minimum data declaration requirements (int, string, list, dict, etc.). Declarative API meets the development demands of X as Data with the rapid development and application of cloud-native technology. Machine-readable and writable, human-readable.

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
- [Kustomize](https://kustomize.io/): It provides a solution to customize the Kubernetes resource base configuration and differential configuration without **template** and **DSL**. It does not solve the constraint problem itself, but needs to cooperate with a large number of additional tools to check constraints, such as [Kube-linter](https://github.com/stackrox/kube-linter), [Checkov](https://github.com/bridgecrewio/checkov) and [kubescape](https://github.com/kubescape/kubescape).

### Templated Key-Value Pair

The Templated KV has the capability of static configuration data and dynamic parameters, and can output different static configuration data with one template+dynamic parameters. The advantages and disadvantages are as follows:

- Pros.
  - Simple configuration logic and loop support.
  - External dynamic parameter support.
- Cons.
  - It is easy to fall into the trap that all configurations are template parameters.
  - When the configuration scale becomes larger, it is difficult for developers and tools to maintain and analyze them.

Representative technologies of templated KV include:

- [Helm](https://helm.sh/): The package management tool of Kubernetes resources, which manages the configuration of Kubernetes resources through the configuration template.
- [Helmfile](https://github.com/helmfile/helmfile): Helmfile is a declarative tool used to assist users in configuring and managing Helm charts running in Kubernetes clusters. Besides, Helmfile extends the functionality of Helm, making it easier and more repeatable to manage multiple Helm charts.
- Other configuration templates: Java Velocity, Go Template and other text template engines are very suitable for HTML writing templates. However,when used in configuration scenarios, they are difficult for developers and tools to maintain and analyze.

### Programmable Key-Value Pair

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
- [OPA](https://github.com/open-policy-agent/opa): While OPA is an open-source, general-purpose policy engine capable of enforcing unified and context-aware policies throughout the stack, it can also accept and output data in formats such as JSON, effectively functioning as a tool for generating or modifying configurations. Although it does not provide out-of-the-box schema definition support, it allows the integration of JsonSchema definitions.
- [Starlark](https://github.com/bazelbuild/starlark): Starlark is a language for describing build transformations, inspired by Python, but with features that make it suitable for embedding in software like Bazel. It can be used for configuration generation due to its capability for deterministic evaluation and expressing complex build transformations.
- [CEL](https://kubernetes.io/docs/reference/using-api/cel/): CEL is an expression language designed to be simple, fast, portable, and safe. While it is not directly a configuration language, CEL is used by Kubernetes as the foundation for complex field selection and filtering operations within its API. CEL can serve as a tool for validating and constraining configurations based on specific expressions.

### Typed Key-Value Pair

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
- [Dhall](https://github.com/dhall-lang/dhall-lang): Dhall is a programmable configuration language that combines features like JSON, functions, types, and import capabilities. Its style leans towards functional programming, so if you're familiar with functional-style languages such as Haskell, you might find Dhall to be quite intuitive.

### Modeled Key-Value Pair

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

- [KCL](https://github.com/kcl-lang/kcl): A declarative configuration and policy programming language implemented by Rust, which improves the writing of a large number of complex configurations through mature programming language technology and practice, and is committed to building better modularity, scalability and stability around configuration, simpler logic writing, fast automation and good ecological extensionally.
- [Nickel](https://github.com/tweag/nickel)：Nickel is a straightforward configuration language aimed at automatically generating static configuration files. Essentially, it's akin to JSON with the addition of functions and types.

Additionally, both KCL and Nickel feature a similar progressive typing system (static + dynamic), merging strategies, functions, and constraint definitions. The difference lies in the fact that KCL is a language similar to Python, whereas Nickel is more akin to JSON. Moreover, KCL offers a schema keyword to differentiate between configuration definitions and configuration data to prevent them from being mixed.

### General-Purpose Languages and CDKs

In addition to defining Kubernetes resources using DSLs, we can also employ general-purpose languages for definition. However, general-purpose languages are typically overkill, as they go beyond what needs to be resolved, and they come with a variety of security concerns, such as capability boundaries (initiating local threads, accessing I/O, networking, code infinite loops, etc.), which can be unsafe. For instance, in the domain of music, there are specific musical notes used to represent music, which facilitate learning and communication in ways that cannot be clearly articulated by ordinary language.

Furthermore, general-purpose languages, due to their diversity, come with the cost of unified maintenance, management, and automation. They are usually used to write client-side runtime code and are an extension of server-side runtime, making them unsuitable for writing configurations unrelated to runtime. These are ultimately compiled into binaries that start processes, and their stability and scalability are difficult to control. In contrast, configuration languages are typically used to write data, complemented by simple logic to describe the expected final outcome, which is then consumed by compilers or engines.

Representative technologies for general-purpose languages and CDKs include:

- [Pulumi](https://www.pulumi.com/docs/) - Pulumi enables the use of common programming languages such as TypeScript, Python, Go, and .NET to write code that defines and deploys cloud infrastructure and application services. Pulumi also supports YAML or DSLs that can be compiled into YAML, such as KCL.
- [CDK8s](https://cdk8s.io/) - CDK8s is used to define Kubernetes resources and applications. CDK8s uses the high-level abstraction concept called constructs to represent various Kubernetes resources such as deployments, services, and configurations. Developers can write code in programming languages like TypeScript, Python, and Java, and CDK8s will translate this code into standard Kubernetes YAML manifests that can be directly applied to a Kubernetes cluster.

### Hybrid Structured and Programmable KV

Some tools primarily employ structured KV for configuration management but also provide additional extensions to handle complex scenarios, eliminating the need for extensive YAML templating. For instance, some cloud-native tools offer function extensions that can be implemented in general-purpose languages such as Go, TypeScript, or DSLs like KCL.

- [YTT](https://github.com/carvel-dev/ytt) - YTT is a templating tool that understands YAML structure. It helps you easily configure complex software via reusable templates and user provided values using the Starlark language.
- [KPT](https://kpt.dev/) - KPT and KPT Functions are used to decouple data and logic definitions, using a Git repository as the source of truth for configurations while managing Kubernetes configurations declaratively without losing extensibility.
- [Kustomize](https://kustomize.io/) - Similar to KPT, Kustomize and Kustomize Functions can also decouple data and logic definitions.
- [Crossplane](https://www.crossplane.io/) - Crossplane and Crossplane Composite Functions are used to decouple XR and Composite resource definitions. XRs allow developers to create higher-level abstractions that can encapsulate and compose multiple types of cloud resources across different providers and services. Using Crossplane Composite Functions to render these abstractions can effectively enhance template capabilities for various provider resources while reducing the amount of YAML code needed.

### Client or Runtime Tools including Operators and Kubernetes CRDs

Kubernetes offers Mutation Webhooks and Validation Webhooks that can modify or validate Kubernetes resource objects at runtime before they are persisted.

Representative technologies for Operators and Kubernetes CRDs include:

- [KusionStack](https://kusionstack) - KusionStack is a modern application delivery and management toolchain that enables developers to specify desired intent in a declarative way and then using a consistent workflow to drive continuous deployment through application lifecycle. Besides, KusionStack provides cloud native operations, observable, and insightful resources that meet the K8s standard through `KusionStack Operation` and `Controller Mesh`
- [KubeVela](https://kubevela.io/docs/) - KubeVela is a modern application delivery system based on the Open Application Model (OAM) specification, providing developers and operation teams with a simplified and unified approach to deploying, managing, and operating applications.
- [Crossplane](https://www.crossplane.io/) - Crossplane is an open-source multicloud control plane that provides infrastructure as code capabilities on Kubernetes. Crossplane enables you to define XRDs and XRs to manage and compose cloud resources (such as databases, storage, and compute resources) directly from the Kubernetes API.
- [Radius](https://github.com/radius-project/radius) - Radius is a cloud-native, portable application platform that makes app development easier for teams building cloud-native apps.
- [KCL Operator](https://github.com/kcl-lang/kcl-operator) - KCL Operator brings programming capabilities to Kubernetes resource configurations at runtime based on the KCL language, utilizing the flexibility of DSL to avoid the complexity of developing Webhooks while integrating with KCL's existing [modules](https://github.com/kcl-lang/modules).

### GitOps Tools

GitOps is a system management practice that uses Git as the source of truth, storing the declarative descriptions of application deployment and infrastructure configuration in a Git repository. GitOps tools usually offer automated continuous deployment capabilities and ensure that the real-time state of the Kubernetes cluster matches the configuration in the Git repository. GitOps tools commonly provide native support or plugin integration with various Kubernetes configuration definition methods (structured, templated, programmable key-value pair, such as Kustomize, Helm, Jsonnet, KCL, etc.).

Representative technologies for GitOps include:

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) - ArgoCD is a declarative GitOps continuous delivery tool used for automating Kubernetes configuration, monitoring, and management. It automates deployment and updates of applications and configurations by tracking changes in the Git repository. ArgoCD offers a visual interface along with extensive control and security features, and it supports various configuration management tools such as Helm, Kustomize, Jsonnet, etc.
- [FluxCD](https://fluxcd.io/) - FluxCD is another popular GitOps tool that allows developers to use a Git repository as the sole source of configuration. Flux automatically ensures that the state of the Kubernetes cluster is synchronized with the configuration in the Git repository. It supports automatic updates, meaning Flux can monitor Docker image repositories for new images and push updates to the cluster.

### Infra from Code (IfC) Tools

Infra from Code (IfC) is an approach to infrastructure management similar to IaC (Infrastructure as Code), where code defines and manages the underlying infrastructure, typically via code intent deduction rather than explicitly defining infrastructure code.

- [Winglang](https://github.com/winglang/wing) - Winglang is a new cloud-oriented programming language that combines infrastructure and runtime code in one language, supporting multiple build targets such as AWS and Kubernetes. Additionally, Winglang provides built-in libraries for direct manipulation of containers and Helm Chart configurations.
- [Plutolang](https://github.com/pluto-lang/pluto) - Pluto is a new open-source programming language designed to help developers write cloud applications, making it easier to utilize cloud services. Developers can directly use required resources such as KV databases and message queues in their code based on business needs. Pluto uses static code analysis to obtain the infrastructure resource topology the application depends on and deploys the corresponding resource instances and applications on the specified cloud platform or Kubernetes.

## Conclusion

Each management approach has its specific advantages and applications. For simple projects, native Kubernetes YAML files and ConfigMaps may be all that's needed. For more complex projects that require stronger templating capabilities and package management, options like Helm or Kustomize might be chosen. If you need to handle configuration programmatically or integrate Kubernetes into a broader cloud infrastructure management system, Infrastructure as Code (IaC) tools such as Terraform and Pulumi, or DSLs like KCL and CUE, might be more suitable.

GitOps tools offer a method of continuous deployment centered around Git. Meanwhile, Operators and CRDs allow users to customize and extend Kubernetes' own capabilities to fit the needs of specific applications. These management methods are not mutually exclusive; in fact, in practical configuration management work, they are often complementary, and teams can choose and combine the tools and methods that best suit their specific needs.

Do you know of other ways? Feel free to add. ❤️

## Reference

- Terraform Language: [https://www.terraform.io/language](https://www.terraform.io/language)
- Terraform Kubernetes Provider: [https://github.com/hashicorp/terraform-provider-kubernetes](https://github.com/hashicorp/terraform-provider-kubernetes)
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
- KCL: [https://github.com/kcl-lang/kcl](https://github.com/kcl-lang/kcl)
- Nickel: [https://github.com/tweag/nickel](https://github.com/tweag/nickel)
- Jsonnet: [https://github.com/google/jsonnet](https://github.com/google/jsonnet)
- Dhall: [https://github.com/dhall-lang/dhall-lang](https://github.com/dhall-lang/dhall-lang)
- Thrift: [https://github.com/Thriftpy/thriftpy2](https://github.com/Thriftpy/thriftpy2)
- Kustomize: [https://kustomize.io/](https://kustomize.io/)
- YTT: [https://github.com/carvel-dev/ytt](https://github.com/carvel-dev/ytt)
- KPT: [https://kpt.dev/](https://kpt.dev/)
- Kube-linter: [https://github.com/stackrox/kube-linter](https://github.com/stackrox/kube-linter)
- Checkov: [https://github.com/bridgecrewio/checkov](https://github.com/bridgecrewio/checkov)
- How Terraform Works: A Visual Intro: [https://betterprogramming.pub/how-terraform-works-a-visual-intro-6328cddbe067](https://betterprogramming.pub/how-terraform-works-a-visual-intro-6328cddbe067)
- How Terraform Works: Modules Illustrated: [https://awstip.com/terraform-modules-illustrate-26cbc48be83a](https://awstip.com/terraform-modules-illustrate-26cbc48be83a)
- TFLint: [https://github.com/terraform-linters/tflint](https://github.com/terraform-linters/tflint)
- Helm: [https://helm.sh/](https://helm.sh/)
- Helm vs. Kustomize: [https://harness.io/blog/helm-vs-kustomize](https://harness.io/blog/helm-vs-kustomize)
- KubeVela: [https://kubevela.io/docs/](https://kubevela.io/docs/)
- Radius: [https://github.com/radius-project/radius](https://github.com/radius-project/radius)
- Crossplane: [https://www.crossplane.io/](https://www.crossplane.io/)
- ArgoCD: [https://argo-cd.readthedocs.io/en/stable/](https://argo-cd.readthedocs.io/en/stable/)
- FluxCD: [https://fluxcd.io/](https://fluxcd.io/)
- Helmfile: [https://helmfile.readthedocs.io/en/latest/](https://helmfile.readthedocs.io/en/latest/)
- CDK8s: [https://cdk8s.io/](https://cdk8s.io/)
- [Helm vs. Kustomize in Kubernetes](https://medium.com/@sushantkapare1717/helm-vs-kustomize-in-kubernetes-cc063bbb4b0e)
- Winglang: [https://github.com/winglang/wing](https://github.com/winglang/wing)
- Plutolang: [https://github.com/pluto-lang/pluto](https://github.com/pluto-lang/pluto)
- [Infrastructure as Code Landscape in 2023](https://blog.terramate.io/infrastructure-as-code-landscape-in-2023-e2dad4fb87d3)
