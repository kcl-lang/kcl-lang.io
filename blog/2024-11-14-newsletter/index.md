---
slug: 2024-11-14-newsletter
title: KCL Newsletter (2024.11.01 - 2024.11-14)
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

Thanks to all community participants over the past two weeks, listed in no particular order:

- Thanks to @slusy for contributions to the KCL playground 🙌
- Thanks to @NishantBansal2003 for enhancing the KCL checksum feature 🙌
- Thanks to @cakemanny, @hanshardmeier, @haiwu, @dennybaa, @NishantBansal2003, @Stinjul, @slusy, @Christopher Haar, @Peter Boat, @Zack Zhang, @anshuman singh, @Carl-Fredrik, @Evgeny Shepelyuk, @kbristow and others for their valuable suggestions and feedback during the use of KCL over the past two weeks 🙌

## Overview

**🏄 Language Updates**

- Fixed unexpected runtime results caused by Schema inheritance definitions
- Refactored the Parser implementation, improving parsing performance by 40% under 400+ KCL files

**💻 IDE Updates**

- Optimized static analysis of unpacking expressions `**expr`, providing richer diagnostic information
- Optimized code snippet completion for schema types `{}` 
- Added monitoring for changes in `kcl.mod` files, improving external package completion experience
- Differentiated highlight colors for `any` type and `any` keyword expressions

**📖 Module Updates**

- edp-keycloak-operator released version `v1.23`

**📬️ Toolchain Updates**

- `kcl mod` command supports module spec to obtain submodules in OCI and Git dependencies
- `kcl import` tool fixed the import of multi-line YAML strings
- `kcl import` tool fixed the import of Kubernetes CRDs when properties have default values
- `kcl run` fixed the issue where the `-o` parameter truncated file output
- `kcl mod` fixed the issue where rename dependencies could not be found
- `kcl mod` fixes duplicate downloads caused by missing kcl.mod files in the root directory of the third-party git repo.
- `kcl mod` kcl.mod file supports `k8s = {version="1.27"}` dependency style.
- `kcl mod` fixes an issue where some diagnostic information is lost.

**🔥 Integration Updates**

- Crossplane KCL function updated to version v0.10.8, supporting the reading of external resources

**📖 Documentation Updates**

- Updated the FAQ with documentation on using KCL plugins
- Updated the FAQ with configuration merge documentation, adding usage documentation for the `json_merge_patch` library
- Added usage examples for all system library functions
- Added more usage cases for OAM models

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to the [KCL Website](https://kcl-lang.io/).
