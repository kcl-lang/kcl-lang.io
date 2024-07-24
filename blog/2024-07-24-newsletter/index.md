---
slug: 2024-07-24-newsletter
title: KCL Newsletter (2024.07.10 - 2024.07.24)
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

- Thanks to @Vishalk91-4 for contributing to the KCL tree-sitter. 🙌
- Thanks to @liangyuanpeng for contributing to the KCL third-party modules kind and kubeadm. 🙌
- Thanks to @DavidChevallier for contributing to the KCL third-party libraries cilium and others. 🙌
- Thanks to @liangyuanpeng for contributing to the KCL CLI project. 🙌
- Thanks to @eshepelyuk, @haarchri, @liangyuanpeng, @logo749, @bilalba, @borgius, @patrick-hermann-sva, @ovk, @east4ming, @wmcnamee-coreweave, @steeling, @sschne, @Jacob Colvin, @Richard Holmes, @Christopher Haar, @Yvan da Silva, @Uladzislau Maher, @Sergey Ryabin, @Lukáš Kubín, @Alexander Fuchs, @Divyansh Choukse and others for their invaluable suggestions and feedback during the recent period of using KCL 🙌

## Overview

Thanks to all contributors for their outstanding work over the past two weeks (2024.06.12 - 2024.06.27). Here is an overview of the key content:

**📦️ Modules Updates**

- Add new third-party library kind that supports creating and managing clusters.
- Third party library kubeadm updated some fields.
- Third party library external-secrets updated to version 0.1.1.
- Third party library cilium updated to version 0.1.2, removing the duplicate declaration of regex.match.
- Konfig updated the example of adding more resource models.
- Konfig updated the example of adding additional pod metadata annotations.

**🏄 Language Updates**

- Assignment statements support attribute access and index access for the assigned target.
- Fixed KCL nested multi-level config block semantic check costing too long time.
- Removed the unwrap() in the semantic resolver to reduce panic issues.
- Fixed the error merge of the list index field by merge operation.

**💻 IDE Updates**

- Fixed the error completion of schema doc in the IDE.
- Fixed the issue of attributes defined in the unification not being automatically completed.
- KCL vim plugin update installation documentation.
- KCL vscode plugin removed the response to yaml files.
- KCL vscode plugin added Apache 2.0 License.

**📬️ Toolchain Updates**

- Package management tool fixed the issue of the compilation entry not recognizing the package relative path ${KCL_MOD}.
- Package management tool changed the PlainHttp option to optional.
- Package management tool fixed the compilation failure caused by the virtual compilation entry.
- Package management tool fixed the issue of the default dependency missing in kcl.mod.
- Package management tool fixed the vendor path calculation error that caused third-party dependencies to be re-downloaded.
- Package management tool fixed the push https protocol OCI registry failure.
- Package management tool added a cache for login credentials to reduce security risks.
- Package management tool fixed the compilation entry error of the root directory.
- KCL tree-sitter added sequence operations and selector support.

**⛵️ API Updates**

- Refactored the error message of the override_file API.

**🔥 SDK Updates**

- Added KCL C/C++ language SDK.
- Added Go, Java, Python, Rust, .NET, C/C++, and other multi-language API Specs, related documents, test cases, and examples.
- Refactored the go code structure, moving go-related code to the go file directory.

**📚️ Documentation Updates**

- Added Python, Java, NodeJs, Rust, Wasm, .NET, C/C++ and other multi-language API documents.
- Updated the IDE Quick Start document.
- Added New Blog [A Comparative Overview of Jsonnet and KCL](https://www.kcl-lang.io/blog/2024-07-22-Jsonnet-kcl-comparison).
- Updated the crd in [Adopt From Kubernetes](https://www.kcl-lang.io/docs/user_docs/guides/working-with-k8s/adopt-from-kubernetes).

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
