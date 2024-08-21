---
slug: 2024-08-21-newsletter
title: KCL Newsletter (2024.08.07 - 2024.08.21)
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

## Special Thanks

- Thanks to @officialasishkumar for contributing the ability to add Git repository subdirectory dependencies to the KCL package management tool. 🙌
- Thanks to @Gmin2 for contributing to the module storage path feature in the KCL package management tool. 🙌
- Thanks to @liangyuanpeng for contributions to modules like karpenter, gateway-api, and the KCL OpenAPI tool. 🙌
- Thanks to @NishantBansal2003 and @varshith257 for their research and contributions on third-party dependency checksum checks in the KCL package management tool. 🙌
- Thanks to @Harsh4902, @Gmin2, @shishir-11, @RehanChalana for their research and contributions to the Intellij IDE KCL LSP plugin. 🙌
- Thanks to @Vishalk91-4 for their ongoing contributions to the KCL tree-sitter grammar. 🙌
- Thanks to @dennybaa for contributions to modules like crossplane and crossplane-vault-provider. 🙌
- Thanks to @Manoramsharma for contributions to dependency alias features, ignoring TLS checks, and external Git dependencies in the KCL package management tool. 🙌
- Thanks to @DavidChevallier for contributions to modules like cilium and external-secrets. 🙌
- Thanks to @suin for contributions to the outdent module. 🙌
- Thanks to @Lukáš Kubín, @ChrisK, @Sergey Ryabin, @Lan Liang, @Endre Karlson, @suin, @Zack Zhang, @v3xro, @soubinan, @juanzolotoochin, @mnacharov, @dennybaa, @ron1, @DavidChevallier, @wmcnamee-coreweave, @vfarcic, @phisco, @juanzolotoochin, @juanique, @zackzhangverkada, @warmuuh and @novohool for their valuable suggestions and feedback during their use of KCL over the past two weeks. 🙌

## Overview

**🏄 Language Updates**

- Optimized the type inference and checks for function parameter calls/return value Dict to Schema, allowing the Schema name to be omitted to simplify configuration writing.
- Enhanced type checks for configuration merging operators, enabling the detection of more type errors at compile time.
- Supported omitting default values for Schema properties with singleton literal constant types.

Before optimization:

```python
schema Deployment:
    apiVersion: "apps/v1" = "apps/v1"
```

After optimization:

```python
schema Deployment:
    apiVersion: "apps/v1"  # The type value is the same as the default value, so the default value can be omitted.
```

**📦️ Module Updates**

- `k8s` updated to 1.31
- `gateway-api` updated to 0.2.0
- `karpenter` updated to 0.2.0
- `crossplane` updated to 1.16.0
- `cilium` updated to 0.3.0
- `external-secrets` updated to 0.1.2
- New modules
  - `crossplane-provider-vault` 1.0.0
  - `outdent` 0.1.0
  - `kcl_lib` 0.1.0

**📬️ Tool Updates**

- The `kcl import` tool now supports importing entire Go Packages and converting all Go struct definitions into KCL Schema definitions.
- The `kcl import` tool has added support for importing JSON Schemas containing AllOf validation fields as KCL Schema.
- The `kcl fmt` tool now preserves the user's blank lines between multiple code snippets, rather than deleting them all.
- Fixed the incorrect formatting position of the Schema index signature comments in the `kcl fmt` tool.
- Fixed unexpected errors when setting the -o parameter during the `kcl import` tool for Kubernetes CRDs.
- Fixed unexpected KCL Schema errors when importing empty Go structs with the `kcl import` tool.

**💻 IDE Updates**

- Supports workspace segmentation in the IDE using a `kcl.work` configuration file.
- Fixed the issue where schema example parameters could not display semantic information.

**⛵️ API Updates**

- Complete testing and case updates for the Kotlin API, see [https://www.kcl-lang.io/docs/reference/xlang-api/kotlin-api](https://www.kcl-lang.io/docs/reference/xlang-api/kotlin-api).
- Preliminary version of the Lua API released; contributions are welcome, see [https://github.com/kcl-lang/lib/tree/main/lua](https://github.com/kcl-lang/lib/tree/main/lua).

**🔥 Integration Updates**

- Flux KCL Controller released v0.4.0, aligning most Flux Kustomize Controller features to meet the demand for direct use of KCL instead of Kustomize for Flux GitOps.
- KRM KCL specification released v0.10.0 beta, adding features for pulling from private Git repositories and ignoring TLS checks.
- KCL Nix Package released v0.9.8.
- Crossplane KCL Function released v0.9.4; see details at [https://github.com/crossplane-contrib/function-kcl](https://github.com/crossplane-contrib/function-kcl).
- KCL Bazel Rules updated to KCL v0.10.0 beta; see details at [https://github.com/kcl-lang/rules_kcl](https://github.com/kcl-lang/rules_kcl).

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to the [KCL Website](https://kcl-lang.io/).
