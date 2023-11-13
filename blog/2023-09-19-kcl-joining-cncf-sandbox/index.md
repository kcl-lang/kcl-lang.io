---
slug: 2023-09-19-kcl-joining-cncf-sandbox
title: KCL Joining CNCF as a Sandbox Project! 🎉
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
---

![kcl-joining-cncf-sandbox](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/kcl-joining-cncf-sandbox-en.png)

**On September 20, 2023, the KCL project was approved by the TOC of the Cloud Native Computing Foundation (CNCF) and officially became a CNCF Sandbox project**.

This means that KCL has gained recognition from the cloud native open source community, ensuring the neutrality of the project and facilitating the participation of developers and partners in project construction. It is a significant step towards dynamic configuration management and automation capabilities for cloud native application delivery.

<!--TODO: CNCF Sandbox Review Figure-->

- _Project Link: https://github.com/kcl-lang/kcl_
- _Project Website: https://kcl-lang.io_

By joining CNCF as a sandbox project, the KCL community aims to attract more developers and users to contribute and further promote the mature application of the project in cloud native scenarios. In addition, joining CNCF provides KCL with an enhanced platform for collaboration and innovation. It offers an opportunity to engage with a diverse community of developers, organizations, and industry experts at the forefront of cloud native technology. We look forward to collaborating with other CNCF projects, contributing our technical expertise, and exploring the possibilities of integrating with more CNCF projects.

## What is CNCF?

CNCF, short for Cloud Native Computing Foundation, is a sub-foundation under the Linux Foundation. CNCF is dedicated to building a sustainable ecosystem for cloud native software, covering areas such as storage, computing, orchestration, scheduling, CI/CD, DevOps, service governance, and service gateways.

_Kubernetes is one of the most representative projects of CNCF_.

## What is CNCF Sandbox Project?

![cncf-sandbox-logo](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/cncf-sandbox-logo.png)

The CNCF community classifies projects into Sandbox, Incubating, and Graduated. Well-known graduated projects include Kubernetes, Prometheus, Istio, ETCD, Containerd, ArgoCD, and Helm. For a complete list of graduated and incubating projects, you can visit [https://www.cncf.io/projects/](https://www.cncf.io/projects/).

Sandbox is a category created by CNCF to provide a beneficial and neutral home for open source projects to promote collaboration and development. Projects selected for the Sandbox are recognized by the CNCF Technical Oversight Committee (TOC) and have the potential for experimentation and development. You can find the list of Sandbox projects at https://www.cncf.io/sandbox-projects/. To enter the Sandbox, at least 66% of the TOC members (all 11 people listed at https://github.com/cncf/toc#members) need to vote in favor, which means at least 8 people.

## What is KCL?

KCL is an open-source, constraint-based record and function language. It aims to improve the writing of complex configurations, such as cloud-native Kubernetes configurations, using mature programming language techniques and practices. KCL focuses on modularity, extensibility, and stability around configuration, aiming to create a simpler logic writing experience and build a simpler path for automation and ecosystem integration.

Key milestones of the project include:

- May 2022: KCL was initiated and officially open-sourced by Ant Group.
- June 2023: KCL became an official CNCF Landscape project.
- September 2023: KCL was reviewed by the CNCF Application Delivery TAG and approved through TOC voting, officially becoming a CNCF Sandbox project (https://github.com/cncf/sandbox/issues/48).

## Why do we need KCL?

Just like recording music with a staff and storing time series data in a sequential database, we use specialized configuration and policy languages to write and manage large-scale complex configurations and policies within specific problem domains of cloud native configuration and automation. Unlike high-level general-purpose languages with hybrid writing paradigms and hybrid engineering capabilities, the core logic of specialized languages is to solve domain problems with almost infinite changes and complexity through a converged finite set of syntax and semantics, and to deposit complex configuration and strategy writing ideas and methods into language characteristics.

In addition, KCL hopes to fill the gap in configuration languages and tools in the field of lightweight client cloud native dynamic configuration through more modern declarative configuration languages and tools, and address the following issues:

- **Configuration Bloat**: Most static configurations such as Kubernetes YAML in the cloud native domain need to be configured separately for each environment; In the worst-case scenario, it may introduce difficult to debug errors involving environmental cross linking, with poor stability and scalability.
- **Configuration Drift**: There is often no standard way to manage the static configuration of applications and infrastructure in different environments. Using non-standard methods such as combining scripts and glue code can lead to exponential complexity growth and configuration drift.
- **Cognitive loading**: Kubernetes and others, as platform technology tools for building platforms, excel in the details of the underlying unified infrastructure, but lack higher-level abstraction for application software delivery, which has a high cognitive loading on ordinary developers and affects the software delivery experience of higher-level application developers.

In response to the above issues, KCL expects to provide the following capabilities:

- Shielding the details and complexity of infrastructure and platforms through methods such as code **abstraction**, reducing the cognitive loading on developers.
- **Mutate** and **Validate** existing inventory configurations or templates to directly solve cloud generated small configuration scenarios such as Helm Chart configuration hard coding issues, but it goes far beyond that.
- Improve team collaboration efficiency by **managing large-scale configuration** data across teams without side effects through language configuration.

Specifically, KCL can

- Improve the ability of **configuration semantic verification** at the code level, such as schema definition, field optional/mandatory, type, range, and other configuration check and verification capabilities.
- Provide the ability to write, combine, and abstract \*\*configuration blocks, such as structural definition, structural inheritance, constraint definition, and configuration policy merging.
- Improve configuration flexibility through **modern programming languages** and **writing code**, such as conditional statements, loops, functions, package management, and other features to enhance configuration reuse capabilities.
- Provide **comprehensive tool chain support**, rich IDE plugins, languages, and ecological tool chain support to reduce the threshold of getting started and improve the user experience.
- By using **package management tools** and **OCI registry**, configurations can be shared, propagated, and delivered in a simpler way among different teams/roles.
- Provide **high-performance** compilers to meet the requirements of large-scale configuration scenarios, such as meeting the rendering performance requirements of generating configurations of different environments and topologies based on deployment context from a baseline configuration, as well as the performance requirements of automatic configuration modification.
- By enhancing its automation and integration capabilities through means such as **multilingual SDK and KCL language plugin**, it can significantly reduce the learning cost of KCL while leveraging the value of configuration and policy writing.

![](/img/docs/user_docs/intro/kcl-overview.png)

In addition to the language itself, KCL also provides many additional tools such as formatting, testing, documentation, etc. to help you use, understand, and check the written configuration or strategy; Reduce the cost of configuration writing and sharing through IDE plugins such as VS Code, package management tools, and Playground; Automatically manage and execute configurations through Rust, Go, and Python multilingual SDKs.

## What can KCL do?

### Dynamic Configuration Management

![standalone-kcl-form](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/standalone-kcl-form.png)

As a configuration language, the most important feature that KCL provides to application and platform developers/SREs is dynamic configuration management. Through code abstraction, we can build an application-centric model that shields complex infrastructure and platform concepts, providing developers with a centralized and easy-to-understand interface. Additionally, KCL allows platform personnel to quickly extend and define their own models, which can be shared and reused through the OCI registry.

![krm-kcl-form](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/krm-kcl-form.png)

Furthermore, KCL also supports direct integration with the Kubernetes Resource Model (KRM) specification. KRM KCL is a generic configuration model specification used to describe and manage various cloud native resources, such as container, pod, and service configurations and abstractions. The KRM KCL specification provides a unified way to define and manage these resources, enabling them to be portable and reusable across different environments. It operates in a fully open Kubernetes world, with minimal binding to any orchestration/engine tools or Kubernetes controllers. It allows platform personnel to extend their abstractions, configuration editing and validation logic, while providing a developer-friendly configuration management interface based on the separation of concerns.

### GitOps

![gitops](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/gitops.png)

Whether using standalone KCL or KRM KCL configuration forms, we support integration between KCL and various CI/CD and GitOps tools. KCL allows developers to define the resources required by applications in a declarative manner. By combining KCL with GitOps tools, we can better achieve Infrastructure as Code (IaC), improve deployment efficiency, and simplify application configuration management.

With GitOps, developers and operations teams can manage application deployments by separately modifying application and configuration code. The GitOps toolchain can automatically make changes to the configuration based on the automation capabilities of KCL, enabling continuous deployment and ensuring consistency. If any issues arise, the GitOps toolchain can quickly roll back the changes.

## Integrations

![integration](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/integration.png)

In addition to integrating with GitOps automation tools like ArgoCD, as a CNCF project, KCL has also integrated with many other CNCF ecosystem projects. For example, it provides KCL plugins for existing CNCF ecosystem configuration management tools such as Helm, Kustomize, and kpt. It also provides a KCL Kubernetes Operator at runtime to meet different configuration management needs. Furthermore, we offer the following integration support:

- **Multi-language support**: We provide multi-language SDKs to help users operate KCL in different languages and integrate it into their own applications.
- **Package management support**: We provide the KPM package management tool to distribute and reuse KCL configurations through Docker Hub, GitHub container registry, etc.
- **Schema migration support**: We support one-click migration of schemas from other ecosystems to KCL schemas, such as Go/Rust struct definitions, JsonSchema, Protobuf, OpenAPI, Terraform Provider Schema, etc.

## Practices

![practice-krm-kcl](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/practice-krm-kcl.png)

Firstly, as a small language in the cloud-native field, KCL can be directly used to solve simple problems in scenarios. For example, using the KCL model to directly inject environment variables for Kubernetes resources, and using the KCL model and Helm KCL plugins to non-invasively handle the hard-coded configuration of Helm Charts instead of directly modifying the Helm Chart by forking it.

![practice-konfig-gitops](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/practice-konfig-gitops.png)

Secondly, KCL can also be used in conjunction with various CI/CD and application configuration delivery engines such as [KusionStack](https://kusionstack.io) within enterprises to achieve separation of concerns, application-centric programmable model interfaces, and GitOps processes. This simplifies the deployment and operation of scaled applications in today's hybrid multi-cloud environments, improving release and operation efficiency and developer experience.

Of course, KCL can solve more problems and scenarios than mentioned above. We will continue to share best practices from adopters in the community, and we welcome everyone to join our community for further discussions and exchanges ❤️. https://github.com/kcl-lang/community

## Community

![community](/img/blog/2023-09-19-kcl-joining-cncf-sandbox/community.png)

In just one year of KCL being open source, we have released many versions and built the KCL community in collaboration with contributors and maintainers from all over the world. We have also gained recognition from some adopters, such as Youzan and Huawei. By joining CNCF, our goal is to increase project visibility and drive community adoption and participation, as strong and well-known foundation organizations are crucial for advancing the development of language ecosystems.

Additionally, we have received recognition from companions in the open-source community from all over the world, including China, North America, Europe, and Australia. We thank all the users and community developers who have accompanied KCL on this journey, and we welcome more companions to join our community and build together ❤️.

## Conclusion

For KCL, joining CNCF does not mean the end, but a new beginning. We will work together with our community companions to build a better KCL language, toolchain, and IDE experience! Lastly, we welcome everyone to join our community for discussions and contributions 👏👏👏

## Resources

- KCL Website: https://kcl-lang.io/
- KusionStack Website: https://kusionstack.io/
- KCL Community: https://github.com/kcl-lang/community
- KCL 2023 Roadmap: https://kcl-lang.io/docs/community/release-policy/roadmap
- KCL GitHub Issues: https://github.com/kcl-lang/kcl/issues
- KCL GitHub Discussion: https://github.com/orgs/kcl-lang/discussions
