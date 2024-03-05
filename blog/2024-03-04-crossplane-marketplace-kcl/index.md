---
slug: 2024-03-04-crossplane-marketplace-kcl
title: "Empowering Cloud-Native Platforms: The Synergy of KCL and Crossplane"
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Crossplane]
---

> _Content sourced from the original Crossplane official blog post: [https://blog.crossplane.io/function-kcl](https://blog.crossplane.io/function-kcl)_

## Introduction

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF) that enhances the writing of complex configurations and polices, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

**Since the release of the beta version of composite functions in Crossplane v1.14**, the potential for building cloud-native platforms using Crossplane has been rapidly expanding. The KCL team promptly followed up and actively built a reusable function. **The entire Crossplane ecosystem can now utilize the high-level experience and capabilities provided by KCL to build its own cloud-native platform**.

Additionally, Crossplane announced that the KCL function has become the first third-party function component to be released to the Upbound Marketplace, available at https://marketplace.upbound.io/providers/crossplane-contrib/function-kcl. The source code can be found at https://github.com/crossplane-contrib/function-kcl, and contributions and feedback are welcome.

You can install the function-kcl with the following command and start using it across the entire Crossplane control plane:

```shell
crossplane xpkg install function xpkg.upbound.io/crossplane-contrib/function-kcl:v0.2.0
```

**The Crossplane team and community are thankful for the KCL team's significant contribution, and its substantial enhancement to the evolving Functions for Crossplane ecosystem!**

![crossplane-announcing](/img/blog/2024-03-04-crossplane-marketplace-kcl/crossplane-announcing.png)

Crossplane, along with its composite model, allows developers to create higher-level abstractions that encapsulate and combine various types of cloud resources across different providers and services. Rendering these abstractions using composite functions can effectively enhance the template functionality of various provider resources while reducing the amount of YAML code required.

Combining KCL with Composition Functions offers several benefits:

- **Simplification of Complex Configurations**: KCL provides a more concise syntax and structure as a DSL, reducing the complexity of configurations. When combined with Crossplane’s composite resources, you can create more intuitive and easy-to-understand configuration templates with loop and condition features, simplifying the definition and maintenance of resources instead of duplicate YAMLs.
- **Reusability and Modularity**: KCL supports modularity and code reuse through OCI Registry, which means you can create reusable configuration components. Combined with Crossplane, this promotes the modularity of composite resources, increases the reuse of configurations, and reduces errors.
- **Automation and Policy-Driven**: You can use KCL’s powerful features to write policies and constraints that, combined with Crossplane’s declarative resource management, can be automatically enforced, ensuring compliance within the cloud environment.

## Getting Started

There are two ways to combine KCL and Crossplane:

- One involves using KCL to write Crossplane composite functions and install them for use in a cluster, still using YAML to define the schema and input required by the app team. KCL is used to write rendering logic to Crossplane Manged Resource to interface with different cloud platforms or Kubernetes clusters. **Note: This approach can install KCL functions for use in the cluster and also use the crossplane beta render command to complete Managed Resource rendering directly on the client.**

![crossplane-kcl-func](/img/blog/2024-03-04-crossplane-marketplace-kcl/crossplane-kcl-func.png)

- The other method involves using KCL to entirely provide abstractions for application developers on the client side and generating Crossplane managed resources to deploy to a cluster, providing a unified programmable access layer for Kubernetes. Specific usage defines the schema input required by the app team using KCL Schema and writes the logic to render it to Crossplane Manged Resource to interface with different cloud platforms or Kubernetes clusters.

![kcl-on-crossplane](/img/blog/2024-03-04-crossplane-marketplace-kcl/kcl-on-crossplane.png)

**For detailed instructions on both approaches, please refer to the Crossplane official blog content: https://blog.crossplane.io/function-kcl**

![crossplane-kcl-blog](/img/blog/2024-03-04-crossplane-marketplace-kcl/crossplane-kcl-blog.png)

Both of these methods require a Registry to facilitate the work. The final choice between them may depend on your operational habits and environmental costs. Regardless of the chosen method, **we recommend maintaining KCL code in Git for better GitOps implementation and better IDE experience and reusable modules**, such as using the Crossplane AWS Module: https://github.com/kcl-lang/modules/tree/main/crossplane-provider-aws

## Summary

The function-kcl project is now donated to the Crossplane community, and we encourage the entire community to test it and try using KCL (the latest advanced language experience provided by Crossplane Functions) to build a cloud-native control plane. We welcome contributions and feedback from the community on the GitHub repository. Let us know your thoughts! https://github.com/crossplane-contrib/function-kcl

For more resources, please refer to:

- KCL Website: https://kcl-lang.io/
- KusionStack Website: https://kusionstack.io/
- KCL v0.9.0 Milestone: https://github.com/kcl-lang/kcl/milestone/9
