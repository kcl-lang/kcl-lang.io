---
slug: 2024-09-05-newsletter
title: KCL Newsletter (2024.08.21 - 2024.09-05)
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

- Thanks to @prakhar479 for contributing to the KCL built-api support for blake3 🙌
- Thanks to @shruti2522 for contributing to the IDE hints feature enhancement 🙌
- Thanks to @liangyuanpeng for continuous contributions to the kcl-openapi tool 🙌
- Thanks to @trogowski for contributing to the KCL documentation 🙌
- Thanks to @yonas for contributing to the KCL documentation 🙌
- Thanks to @NishantBansal2003 for continuous contributions to the KCL package management tool sum check feature 🙌
- Thanks to @officialasishkumar for contributing to the KCL package management tool download Git subpackage feature 🙌

- Thanks to @cx2c, @yonas, @NishantBansal2003, @shruti2522, @nwmcsween, @trogowski, @suin, @johnallen3d, @liangyuanpeng, @riven-blade, @officialasishkumar, @gesmit74, @prakhar479, @Lukáš Kubín, @Christopher Haar, @Alexander Fuchs, @Peter Boat, @Stéphane Este-Gracias, @Yvan da Silva, @Rehan Chalana, @Zack Zhang, @Josh West, @Brandon Nason, @suin, @Anany, and others for their valuable suggestions and feedback while using KCL in the past two weeks 🙌

## Overview

**🏄 Language Updates**

- KCL v0.10.0-rc.1 has been released.
- KCL added some built-in APIs parameters to support the encoding parameter.

```kcl
sha512(value: str, encoding: str = "utf-8") -> str
```

- KCL has added a new built-in API, `crypto.blake3`, to support the use of the Blake algorithm for hashing.

```kcl
import crypto
blake3 = crypto.blake3("ABCDEF")
```

- KCL has added a new built-in API, `isnullish`, to support determining whether a field is empty.

```kcl
a = [100, 10, 100]
A = isnullish(a)
e = None
E = isnullish(e)
```

- KCL has added a new built-in API, `datetime.validate`, to support validating date content.

```kcl
import datetime
assert datetime.validate("2024-08-26", "%Y-%m-%d")
```

- KCL has fixed the date format issue in the built-in API `datetime`.
- KCL Plugin now supports development through Rust.
- Fix the issue that the unification of the schema configuration arguments is parsed incorrectly.
- KCL Plugin has added some tests.

**💻 IDE Updates**

- Fixed the issue of the first line and first column code highlighting failure.
- Fixed the issue of IDE occasional deadlock.
- IDE has added more output logs.
- Optimized the semantic highlighting of the scehma index signature key.
- IDE has optimized the IDE find ref function.
- Fixed the issue of IDE failing to highlight code when opening a file.
- Fixed the issue that find ref failed.
- Fixed the issue that the code highlight failed when opening a file.
- Refactored the code structure of the LSP part and adjusted the scope of some APIs.
- Fixed the issue that the IDE failed to update after kpm updated dependencies.
- IDE has added hints for the schema arguments.

**📖 Documentation**

- Added a review article on KCL at kubecon 2024.
- Added a new built-in API section to the documentation.
- Adjusted the documentation to integrate with OCI registry and Git Repo in the package management tool section.
- Added a new section about the kcl.mod include and exclude fields in the documentation.
- Fixed some documentation errors.

**📦️ SDK Updates**

- Added support for the KCL wasm lib to integrate with node.js and browsers.
- Refactored the KCL python code examples.

**📬️ Toolchain Updates**

- kcl-openapi has been optimized and adjusted for code and document structure.
- kcl-openapi has added more test cases and optimized the code structure.
- Package management tools have fixed the bug that compiling multiple *.k files failed.
- Package management tools supported adding sub-packages in Git repositories as third-party libraries.
- Package management tools have added some test cases.
- krm-kcl function fixed some errors in some tests and documents.
- kcl-operator has been updated and fixed some documentation content, optimized some code structures.
- kcl-operator has added some test cases and optimized the release process.
- kcl-operator added automatic authentication when initializing containers.
- KCL fmt tool provides C API.

**⛵️ API Updates**

- kcl-go API supports importing jsonschema.

**🔥 Integration Updates**

- kcl-flux-controller parameter optimization, added more test cases, and a more complete release and test process.

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to the [KCL Website](https://kcl-lang.io/).
