---
slug: 2024-05-15-newsletter
title: KCL Newsletter (2024.05.01 - 2024.05.15)
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang/kcl) is an open-source configuration and policy language hosted by the Cloud Native Computing Foundation (CNCF) as a Sandbox Project. Built on a foundation of constraints and functional programming principles, KCL enhances the process of writing complex configurations, particularly in cloud-native environments. By leveraging advanced programming language techniques, KCL promotes improved modularity, scalability, and stability in configuration management. It simplifies logic writing, offers easy-to-use automation APIs, and seamlessly integrates with existing systems.

This section will update the KCL language community's latest news, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thanks to to all contributors for their outstanding work over the past twenty days (2024.05.01 - 2024.05.15). Here is an overview of the key content.

**📦️ Module Updates**

- `argo-cd-order` updated to version 0.2.0, featuring new resource filtering functionality.
- `crossplane` module KCL code updated to match the CRD Webhook validation rules of crossplane version 1.15.
- `json-merge-patch` module updated to version 0.1.1, supporting Schema type filtering.

**🏄 Language Updates**

- Fixed the type error of return value from `yaml.decode_all` function.
- Fixed assertion failure when `as` keyword is present in certain third-party libraries.
- `file` module function list updated, seee [here](https://www.kcl-lang.io/docs/reference/model/file) for more documentation.
- Added support for Schema types in `typeof` function to distinguish between schema types and instances.

```python
schema Foo:
    bar?: str

foo = Foo {}
type_schema = typeof(foo) # schema
type_type = typeof(Foo) # type
```

**💻 IDE Updates**

- Fixed IDE path errors and occasional crashes on Windows operating systems.
- The Intellij KCL plugin is divided into two versions based on its functionality: with/without `kcl-language-server`.

**📬️ Toolchain Updates**

- Fixed the issue where third-party libraries cannot be found when compiling relative path modules with `kcl run`.
- Fixed the issue of `kcl vet` validation tool not being able to import external libraries.
- Fixed formatting errors in the `kcl fmt` formatting tool when inserting external import statements.
- Fixed unexpected errors in the `kcl completion bash` command completion.

**⛵️ API Updates**

- Improved format output when automatically modifying variables with the `OverrideFile` API.
- `ListVariables` API now supports return types for variable property operators and Schema types.
- `GetSchemaType` API now supports returning parent class of Schema 🔥 SDK Updates.

**🔥 SDK Updates**

- KCL Rust SDK released preview version v0.9.0-alpha.1
- KCL Python SDK released preview version v0.9.0-alpha.1
- KCL Node.js SDK released preview version v0.9.0-alpha.1
- KCL Java SDK released preview version v0.9.0-SNAPSHOT

**🚪 Integration Updates**

- Fixed the issue of concurrent synchronization resource errors in the ArgoCD KCL Plugin.
- Added new KCL arm64 docker image `kcllang/kcl-arm64`.
- KRM KCL specification added fields for access permissions, Kubernetes resource filtering, and compilation configuration, supporting private OCI Registry access and flexible compilation configuration, see [documentation](https://github.com/kcl-lang/krm-kcl) for more information.
- Crossplane KCL functions released v0.8.0 version and updated more usage examples, see [documentation](https://github.com/crossplane-contrib/function-kcl) for more information.

## Special Thanks

We'd like to thank all the community participants from the past two weeks. The following are listed in no particular order:

- Thanks to @Blarc and @prahaladramji for contributing to the KCL Intellij IDE plugin support for the latest Intellij version. 🙌
- Thanks to @jgascon-nx for contributions to the KCL Crossplane module. 🙌
- Thanks to @Gmin2 for contributions to rebooting KCL Language Server commands in the KCL VS Code IDE. 🙌
- Thanks to @Gmin2 for contributions to the KCL GetSchemaType API supporting parent class field returns. 🙌
- Thanks to @metacoma for contributions to the KCL argo-cd-order module. 🙌
- Thanks to @shruti2522 for contributions to the KCL file module. 🙌
- Thanks to @shruti2522 for contributions to KCL Import and Doc tools. 🙌
- Thanks to @shruti2522 for contributions to the Kubernetes resource filtering feature in the KRM KCL specification. 🙌
- Thanks to @JeevaRamanathan for contributions to the KCL file module. 🙌
- Thanks to @AkashKumar7902 for contributions to the KCL package management tool MVS (Minimum Version Selection) algorithm. 🙌
- Thanks to @bozaro for contributions to the KCL Go SDK Native API. 🙌
- Thanks to @officialasishkumar for contributions to KCL package management tool configuration support for exclude and include parameters. 🙌
- Thanks to @beholdenkey for contributions to KCL documentation. 🙌
- Thanks to @d4v1d03 for contributions to the hover feature in KCL IDE. 🙌
- Thanks to @ibishal for contributions to the preview feature in KCL IDE. 🙌
- Thanks to @bradkwadsworth-mw for contributions to the access rights field in the KRM KCL specification. 🙌
- Thanks to @jgascon-nx and @metacoma for sharing experiences and case studies on using KCL and Crossplane KCL functions, see [here](https://github.com/mindwm/mindwm-gitops) for more information. 🙌
- Thanks to @mintu, @Sergei Iakovlev, @HAkash Kumar, @HStéphane Este-Gracias, @Korada Vishal, @Bishal, @metacoma, @NAVRockClimber, @nkabir, @dennybaa, @dopesickjam, @vfarcic, @sestegra, @jgascon-nx, @zargor, @markphillips100, @evensolberg, @borgius, @bradkwadsworth-mw, @reedjosh, @patrycju, @PrettySolution, @selfuryon, @steeling, @empath-nirvana, @CC007, @M Slane, @MOHAMED FAWAS, and @Even Solberg, among others, for their valuable advice and feedback during the recent use of KCL. 🙌

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
