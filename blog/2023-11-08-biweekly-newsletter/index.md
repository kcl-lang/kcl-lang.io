---
slug: 2023-11-08-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 10.26 - 11.08) | Better IDE Experience Enhancements and More Cloud-Native Modules
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

Thank you to all contributors for their outstanding work over the past two weeks (10.26 - 10.08 2023). Here is an overview of the key content:

**🔧 Language and Toolchain Updates**

- **KCL IDE Updates** - Supports for symbol find-references and rename; Optimized the formatting output for import statements and union types; Fixed the bug where file changes caused the language server to crash.
- **KCL Package Management Tool KPM Updates** - kpm is integrating with ArtifactHub, enabling KCL packages publishing to ArtifactHub.
- **KCL Language Updates** - Optimized error messages for mismatched parameter types in methods, providing clearer indications of the mismatch.
- **Unified Interface of KCL Command-Line** - Redesigned the command-line interface and workflow for KCL tools to achieve a unified experience.

- **KCL IDE Update** - More intelligent configuration value completion, property list completion, function parameter completion, built-in package reference completion, and docstring completion, etc.
- **KCL Package Manage Tool Update** - More smooth workflow for creating and publishing KCL packages: supports automated processes for package updates and releases based on versioning systems; additionally, custom configuration of metadata for KCL packages is now allowed.
- **KCL Module Update** - Out-of-the-box inclusion of over 120 KCL models: [https://github.com/kcl-lang/artifacthub](https://github.com/kcl-lang/artifacthub)
- **KCL Language Update** - Improved error messages for schema attribute type mismatches, support for lambda type annotations, and fixes for individual compilation issues and more system libraries support e.g., validation, serialization, and deserialization of JSON/YAML strings.
- **KCL Import Tool Release**: Supports one-click generation of KCL configurations/models from YAML/JSON/CRD/Terraform Schema, enabling automated migration.

## Special Thanks

The following are listed in no particular order:

- Thanks to @jakezhu9 for the improvement of KCL benchmark from single-threaded Rc to Arc, and for fixing the bug related to reference paths in the KCL import tool. 🙌 https://github.com/kcl-lang/kcl-go/pull/170, etc.
- Thanks to @liangyuanpeng for contributing the `karmada` model package to KCL models, welcome! 🙌 https://github.com/kcl-lang/artifacthub/pull/48/files
- Additionally, thanks to @Matt Gowie, @ddh for their attention to KCL and valuable feedback. 🙌

## Featured Updates

### IDE Extension Updates

The KCL IDE extension has added a large number of completion suggestions, focusing on the core aspect of configuration definition, simplifying the mental process of users when writing configurations based on models, and improving the efficiency of configuration editing. Additionally, parameter completion when invoking built-in functions has been enhanced. Talk is cheap, let's directly see the results:

![](/img/blog/2023-11-08-biweekly-newsletter/module-function-completion.gif)

![](/img/blog/2023-11-08-biweekly-newsletter/config-completion.gif)

For the model design phase, quick generation of document strings has also been added, reducing the need for manual boilerplate typing:

![](/img/blog/2023-11-08-biweekly-newsletter/docstring-gen.gif)

### KCL Package Manager Updates

The package management tool has now interconnected the core workflow of KCL package creation, update, code review, and release. Based on this, over 120+ out-of-the-box KCL model packages have been added. Users can refer to the [Writing and Publishing Kubernetes KCL Code Packages guide](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/publish-modules/) to start using them immediately.

### KCL Language Updates

The optimization of error message output in the KCL compilation command continues to progress, aiming to provide clear and understandable guidance to help developers quickly locate and fix issues and write correct code. Recently, KCL has optimized the error messages for schema field type mismatches:

- before:
  ![](/img/blog/2023-11-08-biweekly-newsletter/schema-expr-type-error-before.png)

- after:
  ![](/img/blog/2023-11-08-biweekly-newsletter/schema-expr-type-error-after.png)

Additionally, support has been added for adding type annotations in lambda expressions, and system libraries now support validation, serialization, and deserialization of JSON/YAML strings. The following issues have been fixed: cache invalidation for KCL programs with third-party libraries, path conflicts when compiling imported files across kcl.mod, and semantic checks for default value of KCL functions.

### KCL Import Tool

Support for one-click generation of KCL configurations/models from YAML/JSON/CRD/Terraform Schema enables automated migration. Please refer to the [One-click Migration from Kubernetes Ecosystem to KCL guide](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/adopt-from-kubernetes) for more information.

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community.

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)

- [KCL 2023 Roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.7.0 Milestone](https://github.com/kcl-lang/kcl/milestone/7)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
