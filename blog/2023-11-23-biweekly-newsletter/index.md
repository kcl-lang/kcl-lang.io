---
slug: 2023-11-23-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 11.09 - 11.23) | Cloud-Native Modules, Language, and Toolchain Update Express!
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF) that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest developments every two weeks, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thank you to all contributors for their outstanding work over the past two weeks (11.09 - 11.23 2023). Here is an overview of the key content:

**📦 Module Update**

- The number of KCL modules has been increased to **200+**, mainly adding validation modules related to `Pod`, `RBAC`, and reference documentation for Kubernetes 1.14-1.28.
- Now we can search and browse the documentation and usage of all modules on the `Artifact Hub` website: _[https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1)_

**💬 Language Update**

- **Developer Experience**
  - Optimized syntax indentation check for configuration code blocks, no longer enforced as an error.
  - Support for using file path wildcards as compilation entry points.
- **Bug Fixes**
  - Fixed type inference errors for some scenarios involving dictionary types.
  - Fix the check of the number of schema arguments.

**🔧 Toolchain Update**

- **Testing Tool Release**
  - Support writing unit tests using KCL functions and executing tests using the tool.
  - Support filtering test cases using regular expressions.
  - Support fast failure for unit tests.
- **Import Tool Update**
  - Fixed the generation of patterns to regular expression matching expressions: _[https://github.com/kcl-lang/kcl-openapi/pull/70](https://github.com/kcl-lang/kcl-openapi/pull/70)_
  - Fixed the generation of minItems/maxItems to field length validation rules: _[https://github.com/kcl-lang/kcl-openapi/pull/69](https://github.com/kcl-lang/kcl-openapi/pull/69)_
  - Fixed the generation of 0 or empty string as default values: _[https://github.com/kcl-lang/kcl-openapi/pull/69](https://github.com/kcl-lang/kcl-openapi/pull/69)_
  - Fixed the generation of package names in the conversion from Kubernetes CRD to KCL Package: `${apiVersion}_${kind}`: _[https://github.com/kcl-lang/kcl-openapi/pull/68](https://github.com/kcl-lang/kcl-openapi/pull/68)_
- **Package Manage Tool Update**
  - Added the update command to automatically update local dependencies: _[https://github.com/kcl-lang/kpm/pull/212](https://github.com/kcl-lang/kpm/pull/212)_

**💻 IDE Update**

- **Developer Experience**
  - Support the completion of external package dependency import statements added by package management tools.
- **Bug Fixes**
  - Fixed the display position of undefined type errors for function parameters.

**🏄 API Update**

- Added KCL Unit Testing API: _[https://github.com/kcl-lang/kcl/pull/904](https://github.com/kcl-lang/kcl/pull/904)_
- Added KCL Symbol Renaming API: _[https://github.com/kcl-lang/kcl/pull/890](https://github.com/kcl-lang/kcl/pull/890)_

**🔥 Architecture Upgrade**

- KCL has designed and reconstructed a new semantic model, as well as APIs that support nearest symbol lookup and symbol semantic information query.
- IDE features such as autocomplete, definition, and hover have been migrated to the new semantic model, significantly reducing the difficulty and amount of code for IDE feature development.

**🚀 Performance Improvement**

- The KCL compiler supports incremental parsing of syntax and incremental checking of semantics, significantly improving the performance of KCL compilation, build, and IDE plugin usage in most scenarios by **5-10 times**.

## Special Thanks

The following are listed in no particular order:

- Thanks to @cr7258 for his contributions to the KCL model library and KCL documentation 🙌
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/203](https://github.com/kcl-lang/kcl-lang.io/pull/203)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/209](https://github.com/kcl-lang/kcl-lang.io/pull/209)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/210](https://github.com/kcl-lang/kcl-lang.io/pull/210)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/211](https://github.com/kcl-lang/kcl-lang.io/pull/211)_
  - _[https://github.com/kcl-lang/modules/pull/67](https://github.com/kcl-lang/modules/pull/67)_

* Thanks to @XiaoK29 for his contributions to the code architecture refactoring of hover and reference lookup features in the KCL IDE, as well as the KCL documentation 🙌
  - _[https://github.com/kcl-lang/kcl/pull/887](https://github.com/kcl-lang/kcl/pull/887)_
  - _[https://github.com/kcl-lang/kcl/pull/899](https://github.com/kcl-lang/kcl/pull/899)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/205](https://github.com/kcl-lang/kcl-lang.io/pull/205)_
* Thanks to @MeenuyD, @negz for their discussions and support regarding the integration of Crossplane KCL Composition Functions 🙌
  - _[https://github.com/kcl-lang/kcl/issues/885](https://github.com/kcl-lang/kcl/issues/885)_
* Thanks to @kolloch for his valuable feedback on the Bazel KCL build rule script 🙌
  - _[https://github.com/kcl-lang/rules_kcl/pull/2](https://github.com/kcl-lang/rules_kcl/pull/2)_
* Thanks to @Yun Lu, @Even Solberg, @Prahalad Ramji, @Matt Gowie, @ddh, and @mouuii for their valuable feedback and discussions during the promotion and usage of KCL 🙌

## Featured Updates

### Search KCL Code and Cloud-Native Models on Artifact Hub

- Write or validate Kubernetes configurations using KCL k8s module.

![](/img/blog/2023-11-23-biweekly-newsletter/k8s-module.png)

- Application delivery and and operation using the KCL Open Application Model (OAM) and the KubeVela controller.

![](/img/blog/2023-11-23-biweekly-newsletter/oam-module.png)

- Do configuration operations using KCL code libraries like `jsonpatch`.

![](/img/blog/2023-11-23-biweekly-newsletter/jsonpatch-module.png)

- Enhance application delivery experience through the [Kusion Modules ecosystem](https://github.com/KusionStack/catalog) at the client side.

In the future, we will explain the specific use cases and workflows of each module through a series of blogs. The source code for these modules is located at _[https://github.com/kcl-lang/modules](https://github.com/kcl-lang/modules)_. We welcome contributions from the community. ❤️

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community. See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.7.0 Milestone](https://github.com/kcl-lang/kcl/milestone/7)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
