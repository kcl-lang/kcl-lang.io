---
slug: 2024-08-07-newsletter
title: KCL Newsletter (2024.07.25 - 2024.08.07)
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

Special thanks to all community contributors over the past two weeks. The following list is in no particular order:

- Thanks @briheet for the contribution to the formatted output of the kcl.mod file. 🙌
- Thanks @Vishalk91-4 for the ongoing contribution to the KCL tree-sitter. 🙌
- Thanks @liangyuanpeng for the ongoing contribution to the CI of repositories such as KCL cli, kpm, and modules. 🙌
- Thanks @kukacz for the ongoing contribution to the KCL model repository. 🙌
- Thanks @Moulick for the contribution to the Crossplane KCL Function. 🙌
- Thanks @stmcginnis for the contribution to the KCL documentation. 🙌
- Thanks @YvanDaSilva for the contribution to the KCL Nix Package. 🙌
- Thanks @DavidChevallier for the ongoing contribution to the KCL model repository. 🙌
- Thanks @Manoramsharma for the contribution to the alias feature and external Git dependency functionality of the KCL package management tool. 🙌
- Thanks @NishantBansal2003, @varshith257 for the research and contribution to the checksum check of third-party dependencies in the KCL package management tool. 🙌
- Thanks to Harsh4902, @Gmin2, @shishir-11, @RehanChalana for the research and contribution to the Intellij IDE KCL LSP plugin. 🙌
- Thanks @Shruti78 for the contribution to the KCL documentation. 🙌
- Thanks @jianzs for the contribution to the KCL Playground. 🙌
- Thanks @vinayakjaas for the contribution to the error messages of KPM. 🙌
- Thanks to @wmcnamee-coreweave, @dennybaa, @bozaro, @eshepelyuk, @liangyuanpeng, @vietanhtwdk, @hoangndst, @sschne, @patpicos, @metacoma, @YvanDaSilva, @ovk, @karlderkaefer, @kukacz, @Matthew Hodgkins, @Christopher Haar, @Gao Jun, and @Zack Zhang for their valuable suggestions and feedback while using KCL in recent times. 🙌

## Overview

Thanks to all contributors for their outstanding work over the past two weeks. Here is an overview of the key content:

**📦️ Modules Updates**

- `cluster-api-provider-azure` updated to v1.16.0
- `cluster-api` updated to v1.7.4
- `konfig` updated to v0.6.0
- `karmada` updated to v0.1.1
- New modules
  - `fluxcd-kcl-controller`
  - `fluxcd-kustomize-controller`
  - `fluxcd-helm-controller`
  - `fluxcd-source-controller`
  - `fluxcd-image-reflector-controller`
  - `fluxcd-image-automation-controller`
  - `fluxcd-notification-controller`
  - `kwok`

**🏄 Language Updates**

- Fixed type conversion error with the `as` keyword in the presence of external packages.
- Fixed type check error from config to schema in the `lambda` function.
- Added `file.current()` function to retrieve the full path of the currently running KCL file.
- Assignment statements support syntax such as `_config["key"] = "value"` or `_config.key = "value"` for in-place modification of configurations.

**💻 IDE Updates**

- Fixed completion of attribute instantiation using `:` operator in Schema.
- Fixed unexpected completion in Schema Doc
- Fixed display issues with the `kcl-language-server` command-line version.
- Support for disabling formatting on save in plugins like NeoVim, VS Code.
- Fine-grained completion for distinguishing between property and value semantics during Schema instantiation.
- Removal of default key bindings in KCL NeoVim plugin, support for user customization.

**📬️ Toolchain Updates**

- `kcl test` tool supports output of print function in test cases
- Fixed compilation error in `kcl import` when importing Schema from Kubernetes CRD and OpenAPI
- Improved formatting of output for `kcl mod init`

**⛵️ API Updates**

- Fixed unexpected data formatting error in KCL C API.
- `OverrideFile` API supports automatic merging and modification of configurations using the `:` operator during compilation.

**🔥 SDK Updates**

- KCL Go SDK supports interaction with KCL core Rust API through build tags, defaulting to CGO mode and can be switched to RPC mode with `-tags rpc`.
- Alpha version v0.10.0 of KCL SDKs released
- Initial release of KCL Kotlin and Swift language SDKs, with no official dependency package yet, contributions are welcome.

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
