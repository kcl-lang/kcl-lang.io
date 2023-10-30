---
slug: 2023-10-23-cloud-native-supply-chain-krm-kcl-spec
title: A New Paradigm for Cloud Native Configuration and Policy Management - KRM KCL Specification
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Meeting]
---

> This blog is a review of the content of the KCL speech at the 2023 CNCF KCD Hangzhou Conference. Activity link: [https://community.cncf.io/events/details/cncf-kcd-hangzhou-presents-kcd-hangzhou-2023/](https://community.cncf.io/events/details/cncf-kcd-hangzhou-presents-kcd-hangzhou-2023/)

## Background

> With the development of cloud-native technology, we are increasingly shifting towards cloud infrastructure. Infrastructure as code (IaC) tools like Kubernetes and Terraform have become increasingly popular for managing and deploying cloud API-based applications. However, this popularity has also brought about complexity and cognitive burden issues that have reached their peak in recent years.

![cognitive-loading](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/cognitive-loading-en.jpg)

For Kubernetes, as the most widely used container orchestration system, Gartner predicts that by 2022, over 75% of organizations globally will be running containerized applications in production. The container management market is estimated to be around 300 million dollars, projected to surpass 1 billion dollars by 2025. Additionally, Kubernetes is steadily moving out of its troubled phase towards maturity and wider adoption<sup>[1]</sup>.

For Terraform, as the most widely used IaC tool, as of the time of writing this article, the Terraform VS Code plugin has an installation count of around 3.2 million, roughly one-third of the installation count of the Go VS Code plugin (around 10 million), and even surpasses the installation count of many general-purpose programming languages. For example, the Rust VS Code plugin has an installation count of around 2.3 million. Furthermore, HCL is the fastest-growing programming language on GitHub in 2022, surpassing all other general-purpose and domain-specific programming languages, forming a wide developer ecosystem<sup>[2]</sup>.

From this, it can be seen that Kubernetes and Terraform are becoming indispensable infrastructure projects in the cloud-native field and will continue to grow in the coming years. Although the nature of these two projects is not entirely the same, they are converging and becoming increasingly complex.

The increasing complexity of the cloud API represented by Kubernetes and Terraform can be attributed to several factors<sup>[3]</sup><sup>[4]</sup><sup>[5]</sup>:

+ **Increasing capabilities**: Kubernetes and cloud APIs are constantly evolving to meet the growing demands of applications and cloud computing. To meet user demands, they continuously introduce new features and capabilities such as auto-scaling, service discovery, load balancing, and permission management. The introduction of these new features increases the complexity of the system. Although we already have various automation methods, over time, the number of different resource types, potential settings for these resource types, and the complexity of relationships between these resource types grow exponentially.
+ **Complex configuration management requirements**: As the scale of applications grows, configuring and managing Kubernetes and cloud APIs becomes increasingly complex. For example, managing a large number of container instances and resources, configuring complex networking and storage, implementing high availability and load balancing, and repeatedly performing configurations for different environments and topologies. These complex configuration and management requirements increase the complexity of Kubernetes and cloud APIs, often resulting in the emergence of "YAML engineers" or "markup language human-editing engineers" in the Kubernetes field.

For cloud APIs, we can leverage IaC tools like Terraform to obtain a large number of pre-written module configurations and providers. However, for Kubernetes, there is still a lack of lightweight client-side configuration composition and abstraction solutions. Existing solutions or specifications struggle to strike a balance between abstraction capabilities and scalability. In extreme scenarios, developers often write a lot of glue code and scripts to handle configurations, which restricts stability and efficiency.

Therefore, we propose the KCL project and the KRM KCL specification, hoping to fill the gap in configuration languages and tools in the lightweight client-side cloud-native dynamic configuration field with more modern declarative configuration languages and tools. We aim to address the following issues:

+ **Dimension explosion**: Most static configurations, such as Kubernetes YAML configurations in the cloud-native field, need to be configured separately for each environment. In the worst case, it may introduce difficult-to-debug errors involving cross-environment dependencies, leading to poor stability and scalability.
+ **Configuration drift**: There is often no standardized way to manage the dynamic configurations of applications and infrastructure for different environments. Adopting non-standard methods such as scripting and piecing together glue code can result in exponential complexity and configuration drift.
+ **Cognitive burden**: Kubernetes and other platform technologies that serve as building platforms excel in unifying infrastructure details at the underlying level. However, they lack higher-level software delivery abstractions, which result in a higher cognitive burden for ordinary developers and affect the software delivery experience of higher-level application developers.

## Concepts

### KCL

![kcl-intro](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/kcl-intro-en.jpg)

KCL is a specialized configuration policy language for the cloud-native domain. It was open-sourced in June 2022 and became a CNCF Sandbox project hosted by the CNCF foundation in September 2023. KCL aims to improve the user experience of writing cloud-native configuration policies and programmability at the Kubernetes API layer. The KCL project is currently included in the CNCF foundation's Automation & Configuration Landscape. The "C" in KCL stands for Configuration, the "L" stands for Language, and the "K" is derived from the first letter of Kubernetes<sup>[6]</sup>.

Unlike general-purpose programming languages, KCL is a domain-specific programming language that solves nearly infinite variations of business scenarios and complexities with a convergent set of syntax and semantics. For example, within the Kubernetes domain alone, there are thousands of resources and a fragmented Operator ecosystem in the community. KCL encapsulates the thought process and approach of writing complex configurations and policies into its language features, avoiding the security risks and side effects associated with using general-purpose languages for configuration.

As a configuration language, KCL provides the most important functionality for application and platform developers/SREs, which is **dynamic configuration management**. Through code abstraction, we can build an application-centric model that shields developers from the complexities of infrastructure and platform concepts and provides them with an interface that is centered around the application and easy to understand. Additionally, KCL allows platform engineers to quickly extend and define their own models, and it provides rich manageability capabilities, including out-of-the-box KCL code libraries, semantic versioning, OCI Registry, language toolchains, and automation support.

Furthermore, KCL operates within a completely open cloud-native ecosystem and is not tightly coupled to any orchestration/engineering tools or Kubernetes controllers. In cloud-native supply chain scenarios and large-scale operational scenarios, KCL can provide API abstraction, composition, and validation capabilities for both the client and runtime. Users can choose suitable engines such as Kubectl<sup>[7]</sup>, KusionStack<sup>[8]</sup>, KubeVela<sup>[9]</sup>, or Helmfile<sup>[10]</sup> to combine with KCL and apply configurations to the cluster.

![kcl-concept](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/kcl-concept-en.jpg)

In addition, KCL itself is a modern, high-level domain-specific programming language, which is a compiled static and strongly-typed language. KCL provides developers with the core capabilities of **configuration (config)**, **model abstraction (schema)**, **logic (lambda)**, and **policies (rules)** through a record and function-oriented language design.

KCL aims to provide programmability independent of the runtime, without providing system functionalities such as threads and IO locally. It strives to offer programming support that is stable, secure, low-noise, low side-effect, high-performance, easy to automate, and easy to manage in order to solve domain-specific problems.

### KRM KCL Specification

![krm-kcl](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/krm-kcl-en.jpg)

The KRM KCL specification is a configuration specification based on the Kubernetes Resource Model (KRM). KRM is a generic configuration model used to describe and manage various cloud-native resources such as containers, pods, and services. KRM provides a unified way to define and manage these resources, enabling them to be portable and reusable across different environments<sup>[11]</sup>.

As one of the official Kubernetes specifications, the core concept of KRM is KRM functions. The input of KRM functions is a set of Kubernetes resources and the configuration of the KRM function, and the output is a set of Kubernetes resources along with the results of the function execution, such as error messages and debug information. KRM KCL is the implementation of KRM functions using KCL code and extends it with support for various code sources such as OCI Registry, Git, and HTTPS.

In the KRM KCL specification, the behaviors of the KCL configuration model are mainly divided into three categories:

+ **Mutation**: Takes input KCL parameters `params` and a list of KRM resources and outputs a modified list of KRM resources.
+ **Validation**: Takes input KCL parameters `params` and a list of KRM resources and outputs the list of KRM resources and resource validation results.
+ **Abstraction**: Takes input KCL parameters `params` and outputs a list of KRM resources.

Using KCL, we can achieve the following capabilities programmatically:

+ Modify resources using KCL, such as adding/modifying label tags or annotation comments based on certain conditions or injecting Sidecar container configurations in all Kubernetes Resource Model (KRM) resources containing PodTemplate.
+ Validate all KRM resources using KCL schema, such as constraining containers to only be launched in a root manner.
+ Generate KRM resources or abstract/combine different Kubernetes APIs using the abstraction model, for example, instantiating a web application configuration using the "web-service" model.

With the help of KCL IDE and KCL package management tools, we can write models and upload them to the OCI Registry for model reuse. We can programmatically extend the support for the KRM KCL specification, and these models can be used separately in the client or runtime based on specific scenario requirements.

## Developer Experience

Regarding the mentioned domain-specific problems and the related concepts of KCL, we primarily provide three aspects of support to users: language, toolchain, and cloud-native integrations.

![workspace](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/workspace.png)

Although KCL is a domain-specific language, it is comprehensive in its capabilities. KCL provides toolchain functionalities that are equivalent to general-purpose languages, such as formatting, testing, documentation, package management, etc., to assist in writing, understanding, and validating configurations or policies. IDE plugins like VS Code and Playground reduce the cost of configuration writing and sharing. Automation of configuration management and execution is achieved through multilingual SDKs in Rust, Go, and Python.

![ide](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/ide.png)

For IDE plugins, KCL currently mainly supports VS Code, IntelliJ, and NeoVim. These plugins, based on the same KCL Language Server, offer features like autocompletion, navigation, hover, code refactoring, and formatting<sup>[12]</sup>.

![integration](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/integration-en.jpg)

As a CNCF project, KCL is integrated with many other CNCF ecosystem projects. For example, KCL provides plugins for existing CNCF ecosystem configuration management tools like Kubectl, Helm, Kustomize, kpt, helmfile, etc. At runtime, KCL offers the KCL Kubernetes Operator to meet various configuration management needs. Additionally, we provide the following integration support:

+ **Multilingual Support**: We offer multilingual SDKs to help users work with KCL in different programming languages and integrate it into their own applications.
+ **Package Management Support**: We provide KCL package management tools that allow distribution and reuse of configurations and policy code through standard OCI supply chain methods like Harbor, Docker Hub, GitHub Packages, etc.
+ **Schema and Data Migration Support**: We support one-click migration of schema and data from other ecosystems to KCL Schema, including Go/Rust struct definitions, JsonSchema, Protobuf, OpenAPI, Terraform Provider Schema, JSON, YAML, and more.

![artifact-hub](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/artifact-hub.png)

![artifact-hub-k8s](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/artifact-hub-k8s.png)

Furthermore, KCL supports integration with ArtifactHub. You can publish your KCL package to ArtifactHub by submitting a PR to the `kcl-lang/artifacthub` repository. This allows you to see the effects of the uploaded KCL package on the ArtifactHub page, such as the k8s package<sup>[13]</sup>.

In addition to that, KCL provides many out-of-the-box cloud-native models, primarily covering **Kubernetes** and **Terraform** models. Developers can easily add corresponding configuration model dependencies or view the KCL source code with just one line of KCL command.

![performance](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/performance.png)

In addition to the external work related to language, toolchain, and cloud-native integration, we have also made significant efforts to ensure stability and performance within KCL. In scenarios with large code bases or high computational requirements, KCL outperforms languages like CUE, Jsonnet, HCL, etc. Furthermore, KCL's progressive static typing system, immutability, schema, and validation rules ensure further stability of configurations.

## Case Studies

### Kubernetes

KCL currently focuses on the cloud-native domain, particularly in Kubernetes scenarios.

![k8s-mutation](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/k8s-mutation-en.jpg)

As a small programming language within the cloud-native domain, KCL can be directly used to address simple tasks in the environment. For example, the `append-env` model can be used to inject environment variables into Kubernetes resources without the need for scripting. These models are shareable, reusable, and have been tested for code reliability, stability, and scalability.

![k8s-validation](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/k8s-validation-en.jpg)

In addition to in-place editing of Kubernetes configurations, KCL offers a variety of out-of-the-box models for Kubernetes configuration validation. These models address security and compliance issues in the cloud-native supply chain. For example, the `disallow-svc-lb` model can be used to validate whether the `Service` resource incorrectly sets the `LoadBalancer` type, and the `https-only` model can verify if the `Ingress` resource contains explicit annotations set to use https.

Compared to other policy tools or engines, the advantage of using KCL is that a validation model can be used both on the client side and at runtime. Schema and constraint conditions can be defined simultaneously in the programming language interface, without the need for additional OpenAPI Schema or JSON Schema integration.

![kcl-operator](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/kcl-operator-en.jpg)

In addition to abstracting, editing, and verifying configurations on the client side, KCL also provides runtime support. KCL Operator provides Kubernetes cluster integration, allowing Access Webhook to generate, mutate, or validate resources based on KCL configuration when applying Kubernetes resources to the cluster. Webhook will capture creation, application, and editing operations, and `KCLRun` will execute resources on the configuration associated with each operation<sup>[14]</sup>.

Using the KCL Operator, resource configuration management and security verification can be automated in a lightweight manner within the Kubernetes cluster through KCL code in a few steps, without the need to repeatedly develop Webhook Server to dynamically modify and verify configurations at runtime.

### Terraform

Another scenario that KCL focuses on is the ecosystem model of Terraform.

![tf-validation](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/tf-validation-en.jpg)

In the cloud-native supply chain scenario, apart from the user's business code, it is often necessary to verify the security of the Infrastructure as Code (IaC) code. Therefore, KCL also provides validation models related to Terraform. For example, the example shown in the image only requires a few lines of KCL code to enforce the requirement of not deleting resources during automatic scaling operations in an AWS resource group<sup>[15]</sup>.

Compared to other policy engines or tools, KCL supports easy conversion from Terraform Provider Schema to KCL Schema, making policy writing more accessible.

### IaC & GitOps

![gitops](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/gitops-en.jpg)

Whether it is the Kubernetes model or the Terraform model, and whether it is using the standalone KCL or KRM KCL configuration format, KCL supports integration with various CI/CD and GitOps tools. KCL allows developers to define the resources required for an application in a declarative manner. By combining KCL with GitOps tools, we can achieve better Infrastructure as Code (IaC) implementation, improve deployment efficiency, and simplify application configuration management<sup>[16]</sup>.

With GitOps, developers and operations teams can manage the deployment of applications by separately modifying application and configuration code. The GitOps toolchain can automatically change configurations based on the automation capabilities of KCL, enabling continuous deployment and ensuring consistency. If any issues arise, the GitOps toolchain allows for quick rollbacks.

![app-delivery](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/app-delivery-en.jpg)

KCL can also be used in conjunction with various CI/CD and application configuration delivery engines within an enterprise, such as KusionStack, to achieve separation of concerns, application-centric programmable model interfaces, and GitOps workflows. This simplifies the deployment and operations of scalable applications in today's hybrid and multi-cloud environments, enhancing release and operations efficiency as well as developer experience.

![k8s-abstraction](/img/blog/2023-10-23-cloud-native-supply-chain-krm-kcl-spec/k8s-abstraction-en.jpg)

Furthermore, with the Schema structure and automation API of KCL, we can integrate KCL into external systems and use CLI/API/UI forms to automate the addition, deletion, modification, and retrieval of KCL configurations. This not only enables GitOps and Infrastructure as Code (IaC) but also provides a user-friendly configuration management interface for developers. It supports changes to KCL code in the form of UI forms, improving the efficiency of configuration management and application delivery while avoiding configuration drift and other issues.

## Summary

This article mainly reviews the content of the KCL presentation at the CNCF KCD community conference. It discusses the challenges encountered in the cloud-native domain, especially in the Kubernetes and Terraform ecosystems, as well as the concepts, user experiences, and practices of the KRM KCL specification.

Of course, the problems that KCL can solve and the scenarios it can be applied to are much broader than what is covered in this article. Due to the limitations of the article length, we will continue to share the best practices of adopters in the community. We also welcome everyone to join our community for further discussions and exchanges ❤️.

## More Resources

For more resources, please refer to:

+ [KCL Website](https://kcl-lang.io/)
+ [KCL Repo](https://github.com/kcl-lang/kcl)
+ [KusionStack Website](https://kusionstack.io/)
+ [KusionStack Repo](https://github.com/KusionStack/kusion)

See the [community](https://github.com/kcl-lang/community) for ways to join us. 👏👏👏

## Reference

+ [1] Forecast Analysis: Container Management (Software and Services), Worldwide: [https://www.gartner.com/en/documents/3985796](https://www.gartner.com/en/documents/3985796)
+ [2] The top programming languages: [https://octoverse.github.com/2022/top-programming-languages](https://octoverse.github.com/2022/top-programming-languages)
+ [3] Declarative Application Management in Kubernetes: [https://docs.google.com/document/d/1cLPGweVEYrVqQvBLJg6sxV-TrE5Rm2MNOBA_cxZP2WU/edit#](https://docs.google.com/document/d/1cLPGweVEYrVqQvBLJg6sxV-TrE5Rm2MNOBA_cxZP2WU/edit#)
+ [4] CNCF Platform Engineering Whitepaper: [https://tag-app-delivery.cncf.io/whitepapers/platforms/](https://tag-app-delivery.cncf.io/whitepapers/platforms/)
+ [5] Google SRE Workbook: Configuration Specifics: [https://sre.google/workbook/configuration-specifics/](https://sre.google/workbook/configuration-specifics/)
+ [6] KCL Website: [https://kcl-lang.io/](https://kcl-lang.io/)
+ [7] Kubectl: [https://kubernetes.io/docs/reference/kubectl/](https://kubernetes.io/docs/reference/kubectl/)
+ [8] KusionStack: [https://kusionstack.io](https://kusionstack.io)
+ [9] KubeVela: [https://kubevela.net](https://kubevela.net)
+ [10] Helmfile: [https://github.com/helmfile/helmfile](https://github.com/helmfile/helmfile)
+ [11] KRM KCL Specification: [https://github.com/kcl-lang/krm-kcl](https://github.com/kcl-lang/krm-kcl)
+ [12] KCL IDE Extension: [https://kcl-lang.io/docs/tools/Ide/](https://kcl-lang.io/docs/tools/Ide/)
+ [13] ArtifactHub KCL Integration: [https://artifacthub.io/](https://artifacthub.io/)
+ [14] KCL Operator: [https://github.com/kcl-lang/kcl-operator](https://github.com/kcl-lang/kcl-operator)
+ [15] Terraform KCL Policy: [https://kcl-lang.io/docs/user_docs/guides/working-with-terraform/validation](https://kcl-lang.io/docs/user_docs/guides/[]working-with-terraform/validation)
+ [16] GitOps using KCL: [https://kcl-lang.io/docs/user_docs/guides/gitops/gitops-quick-start](https://kcl-lang.io/docs/user_docs/guides/gitops/gitops-quick-start)
