---
slug: 2024-03-20-newsletter
title: KCL Newsletter (2024.03.06 - 2024.03.20)
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF) that enhances the writing of complex configurations and polices, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest news, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thanks to to all contributors for their outstanding work over the past twenty days (2024.03.06 - 2024.03.20). Here is an overview of the key content:

**📦 Module Updates**

- Added new kubeadm configuration module.
- Updated Knative Operator module to align with upstream Knative CRD definitions.

**🏄 Language Updates**

**KCL has released v0.8.1 and v0.8.2**, mainly including the following updates:

- Enhanced error messages for simplified experience when binary expression types do not match.
- Fixed abnormal error of high-order lambda functions capturing local scope closure variables.
- Removed inequality comparison operations for uncommon list data types.

**🔧 Toolchain Updates**

- Fixed an issue in the kcl import tool where input Kubernetes CRDs with the regex property conflicted with the KCL regex system library.
- Fixed a syntax error in the KCL file output when the input Kubernetes CRD properties had complex default values in the kcl import tool.
- Added support for setting the version of a newly created KCL module with the `--version` flag in the kcl mod init command.
- Commands such as kcl run, kcl mod add, and kcl mod pull now support accessing private Git repositories.
- Fixed a path error encountered when running the kcl run command on a local OCI Registry on Windows.

**🔥 SDK Updates**

- The KCL Rust, Go, and Java SDKs have released version 0.8, primarily synchronizing with KCL syntax and semantic updates.
- The KCL Python SDK has released versions 0.8.0.2 and 0.7.6, addressing the issue of outdated dependencies for `protobuf` and `pyyaml`.

**💻 IDE Updates**

- Support for multiple quick fix repair options.

![multiple-quick-fix](/img/blog/2024-03-20-newsletter/multiple-quick-fix.png)

**🎁 API Updates**

- Added `ListOptions` API, which can read all `option` function call information in KCL projects.

**🚢 Integration Updates**

- Crossplane KCL Function has released version 0.3.2, supporting access to non-HTTPS protocol OCI Registries and local debugging.

**🌐 Website Updates**

- Enabled the `kcl-lang.dev` domain, allowing access to the KCL website through both `kcl-lang.io` and `kcl-lang.dev`.
- Optimized website loading speed for an improved documentation experience on the KCL website.

## Special Thanks

Thank you to all the community contributors over the past two weeks, listed in no particular order:

- Thank you to @bozaro for the contribution to the KCL Go SDK with the Go language plugin API. 🙌
- Thank you to @shashank-iitbhu for enhancing the quick fix feature in the KCL IDE, adding support for multiple fix options. 🙌
- Thank you to @octonawish-akcodes for the ongoing contribution to the KCL IDE, automatically monitoring kcl.mod dependencies and updating them. 🙌
- Thank you to @liangyuanpeng for fixing the CLA Bot CI automatic PR locking, contributing to the kubeadm model, and supporting the version setting feature in `kcl mod init`. 🙌
- Thank you to @Stefano Borrelli, @sfshumaker, @eshepelyuk, @vtomilov, @ricochet1k, @yjsnly, @markphillips100, @userxiaosi, @wilsonwang371, @steeling, @bozaro, @nizq, @reckless-huang, @folliehiyuki, @samuel-deal-tisseo, @MrGuoRanDuo, and @MattHodge for providing valuable suggestions and feedback while using KCL recently. 🙌

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
