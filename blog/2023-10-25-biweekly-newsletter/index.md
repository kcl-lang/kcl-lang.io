---
slug: 2023-10-25-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 10.12 - 10.25) | FindReferences and Rename in IDE, ArtifactHub integration in KPM!
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation(CNCF) that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest developments every two weeks, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thank you to all contributors for their outstanding work over the past two weeks (10.12 - 10.25 2023). Here is an overview of the key content:

**🔧 Language and Toolchain Updates**

- **KCL IDE Updates** - Supports for symbol find-references and rename; Optimized the formatting output for import statements and union types; Fixed the bug where file changes caused the language server to crash.
- **KCL Package Management Tool KPM Updates** - kpm is integrating with ArtifactHub, enabling KCL packages publishing to ArtifactHub.
- **KCL Language Updates** - Optimized error messages for mismatched parameter types in methods, providing clearer indications of the mismatch.
- **Unified Interface of KCL Command-Line** - Redesigned the command-line interface and workflow for KCL tools to achieve a unified experience.

## Special Thanks

The following are listed in no particular order:

- Thanks to @jakezhu9 for enhancing the KCL syntax parsing unit tests, migrating some test cases to the snaptest framework 🙌 [https://github.com/kcl-lang/kcl/pull/794](https://github.com/kcl-lang/kcl/pull/794)
- Thanks to @opsnull for correcting code examples in kcl-lang.io website 🙌 [https://github.com/kcl-lang/kcl-lang.io/pull/182](https://github.com/kcl-lang/kcl-lang.io/pull/182)
- Thanks to @prahaladramji for fixing and optimizing the formatting functionality in the KCL IntelliJ plugin 🙌 [https://github.com/kcl-lang/intellij-kcl/pull/15](https://github.com/kcl-lang/intellij-kcl/pull/15), etc.
- Thanks to @steeling, @prahaladramji, @liangyuanpen, @Kory Taborn, and others for valuable feedback and discussions while using KCL and the toolchain 🙌

## Featured Updates

### IDE Extension Updates

In the upcoming release, the KCL IDE extension will support find/go-to references navigation, symbol renaming, and some optimizations for formatting import statements and union types. Additionally, virtual file system-related bugs causing language service crashes have been fixed.

Go-to references:
![](/img/docs/tools/Ide/vs-code/FindRefs.png)

Rename symbols:
![](/img/docs/tools/Ide/vs-code/Rename.gif)

Formatting improvements for import statements and union types: optimized behavior for newlines between reference statements and other code blocks (formatted as a single newline) and spacing between union types (formatted with `|` as separators):
![](/img/blog/2023-10-25-kcl-biweekly-newsletter/Format.gif)

### KCL Package Manager Updates

In the upcoming release, KPM will support integration with [ArtifactHub](https://artifacthub.io/). You can now submit a PR to the [kcl-lang Registry repository](https://github.com/kcl-lang/artifacthub) to publish your KCL packages on ArtifactHub. The pre-uploaded KCL Kubernetes package can be seen on the [ArtifactHub staging page](https://staging.artifacthub.io/packages/search?ts_query_web=kcl&sort=relevance&page=1). The functionality will be released in version v0.6.1:

![](/img/docs/tools/kpm/artifacthubStaging.png)

### KCL Language Updates

The compilation command of KCL continues to improve error message output, aiming to provide clear and understandable guidance to help developers quickly identify and fix errors while writing correct code. Recently, error messages related to method parameter type mismatches have been optimized, clearly indicating parameter type mismatches:

![](/img/blog/2023-10-25-kcl-biweekly-newsletter/error-msg.png)

Additionally, a fix addressed the issue of lazy evaluation in property assignments, deferring the computation and constraint validation of property assignments until after configuration merging to avoid unnecessary compilation errors.

### Unified Interface of KCL Command-Line

We are redesigning the command-line interface of KCL tools to achieve a unified user workflow, seamless integration with related tools and multi-language APIs, and command-line tool extensibility. Welcome to join the discussion if anyone are insterested: https://github.com/kcl-lang/kcl/issues/756.

### Community Updates

With the inclusion in CNCF Sandbox, we are glad to announce that the CNCF KCL Slack channel is now available for KCL-related discussions. Feel free to join:

1. Join the CNCF workspace by providing your email address: https://communityinviter.com/apps/cloud-native/cncf
2. Join the CNCF KCL channel: https://cloud-native.slack.com/archives/C05TC96NWN8

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
