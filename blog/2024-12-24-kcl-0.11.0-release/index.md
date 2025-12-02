---
slug: 2024-12-24-kcl-0.11.0-release
title: KCL v0.11.0 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## Introduction

The KCL team is pleased to announce that **KCL v0.11.0 is now available**! This release has brought two key updates to everyone

- _Enhance the coding experience and efficiency with a more performant, feature-rich, and less error-prone KCL language, toolchain, and IDE._
- _A more comprehensive and diverse set of standard libraries, third-party libraries, and community ecosystem integrations, covering different application scenarios and requirements._

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF). KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

## ❤️ Special Thanks

**We would like to extend our heartfelt thanks to all community contributors who participated in the iteration from version v0.10 to v0.11. The following list is in no particular order.**

_@adamwg, @steeling, @dennybaa, @liangyuanpeng, @NishantBansal2003, @mayrf, @eminaktas, @Gmin2, @tvandinther, @diefans, @nkabir, @suin, @Chewie, @lwz23, @eminaktas,@steeling, @bozaro, @cakemanny, @Yufeireal, @andrzejgorski, @yonas, @dansrogers, @SkySingh04, @jellllly420, @slashexx, @xnull, @diefans, @zflat, @vfarcic, @spastorclovr, @patpicos, @mproffitt, @fraenkel, @irizzant, @vfarcic, @patpicos, @mproffitt, @fraenkel, @Clint, @Christopher Haar, @ron18219, @Zack Zhang, @Alexander Fuchs, @Smaine Kahlouch, @Yvan da Silva, @Jakob Maležič, @Ryan Rueth, @Christopher Haar, @kesser, @Justin B, @Evgeny Shepelyuk, @Smaine Kahlouch, @KennyZ, @Mark Altmann (Wompi), @Peter Boat, @Hai Wu, @Evgeny Shepelyuk, @anshuman singh, @Carl-Fredrik, @Larry Gadallah, @Kevin Sztern, @Nick Atzert, @Tobias Kässer, @Mike, @john thompson, @Sky Singh, @suin, @Tom van Dinther, @Stefano Borrelli, @Valer Orlovsky, @Jacob Colvin, @Sjuul Janssen, @Vyacheslav Terdunov, @Yury Tsarev_

## 📚 Key Updates

### 🔧 Core Features

#### Language

- KCL supports Alpine Linux(musl) platform.
- KCL refactored the implementation of the Parser and reorganized the parse process of import dependencies.
- KCL optimized the type parsing of \*\* expressions in schema attributes.
- KCL fixed the problem that lambda expressions do not work when nested calls.
- KCL fixed the memory leak problem of schema mixin parse.
- KCL fixed the type promotion in function call expressions in assignment statements with type declarations.
- KCL fixed the error of lambda functions calling attr in mixin

#### Toolchain

- Package management tool version selection algorithm is released. In v0.11.0, the KCL package management tool supports the selection of different version numbers of the same tripartite library that appears in the dependency graph. The KCL package management tool refers to the mvs algorithm of go mod.

To ensure as much compatibility as possible, package management tools currently prefer to select the latest version that appears in the dependency diagram rather than the latest version that has already been released.

In version v0.11.0, version selection is turned off by default. You can control whether version selection is turned on by setting the environment variable `export KPM_FEATURE_GATES='SupportMVS=true'`.

- Package management tool added a new local tripartite library cache. In v0.11.0, KCL package management tool implemented a new local tripartite library cache, and the new storage cache structure improved the performance of downloading git repositories by 88% on average.

In v0.11.0, the new cache structure is turned off by default, and the new local tripartite library cache is controlled by setting the environment variable `export KPM_FEATURE_GATES=' SupportNewStorage=true'`.

- Fix `kcl fmt` formatting error for code comments.
- Fix `kcl fmt` error in handling line continuation and comment combinations.

#### IDE

- KCL IntelliJ plugin released 0.4.0, supporting LSP4IJ.
- IDE can complete schemas defined in the worksace but not imported , and automatically insert the import statements of the package.
  ![complete](/img/blog/2024-12-06-kcl-0.11.0-release/complete.gif)
- IDE adds type hints for key in the Config block.
  ![hint](/img/blog/2024-12-06-kcl-0.11.0-release/hint.png)
- IDE hover provides schema attribute default value information.
  ![hover](/img/blog/2024-12-06-kcl-0.11.0-release/hover.png)
- IDE fixed the failure of Windows path issues.
- IDE fixed the failure of compound assignment operation statements.
- IDE distinguished the highlighting of the `any` from keyword and type.
- IDE fixed the failure of formatting code in the IntelliJ plugin.
- Optimized the parser part of the IDE compilation process.
- IDE fixed inconsistent hints for function parameters.
- Optimized hint information and added the feature of double-clicking to insert hints into the code.

#### API

- Added `kcl_run_with_log_message` API
- Added `kcl_exec_program` capi
- Added `kcl_version` api for wasm

### 📦️ Standard Libraries and Third-Party Libraries

#### Standard Libraries

- KCL new standard libraries `filesha512` and `fileblake3`。

```kcl
import crypto

sha_filesha512 = crypto.filesha512("test.txt")
sha_fileblake3 = crypto.fileblake3("test.txt")
```

- Fixes an issue that `ignore_private=False` parameter does not take effect in `manifests.yaml_stream`.

#### Third-Party Libraries

- k8s updated to 1.31.2
- Fixed the import alias problem in the k8s package.
- helloworld updated to 0.1.4
- gateway updated to 0.3.2
- kubevirt updated to 0.3.0
- cert-manager updated to 0.3.0
- Added edp-keycloak-operator
- Added sealed-secrets
- Added DeploymentStrategy model in konfig

### ☸️ Ecosystem Integration

#### Multi-Language Plugins

- KCL Plugin supports development through Rust.
- Add more test cases for the KCL Plugin.

### 📖 Documentation Updates

- Fixed errors in sample code for argocd kcl plugin configuration
- Added FAQ document about plugin.
- Added more sample documents about system packages.
- Added FAQ document about json_merge_patch.
- Added FAQ document about isnullish function.
- Added sample code about oam app inheritance.
- Fixed Windows installation script.
- Fixed some typos and broken links in the document.
- Updated the documentation of KCL IntelliJ plugin.

## 🌐 Other Resources

🔥 Check out the [KCL Community](https://github.com/kcl-lang/community) and join us 🔥

For more resources, refer to:

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
