---
slug: 2024-05-29-newsletter
title: KCL Newsletter (2024.05.01 - 2024.05.29)
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

- Congratulations to @AkashKumar7902 for completing the LFX 1 task, successfully merging the mvp version of the kpm version management module into the main branch 🙌
- Thanks to @shashank-iitbhu for his continued contributions to the IDE Quick Fix feature 🙌
- Thanks to @Wck-iipi for his continued contributions to the IDE hover feature 🙌
- Thanks to @warjiang for his contributions to the devcontainer 🙌
- Thanks to @shruti2522 for her continued contributions to the IDE hover feature 🙌
- Thanks to @XiaoK29 for his continued contributions to the KCL go SDK code optimization 🙌
- Thanks to @d4v1d03 for his continued contributions to the KCL documentation 🙌
- Thanks to @officialasishkumar for his contributions to the package management tool third-party dependency renaming feature 🙌
- Thanks to @Vishalk91-4, @Daksh-10 for their contributions to the KCL tree sitter syntax and parser generator 🙌
- Thanks to @SamirMarin for his contributions to the Crossplane KCL function 🙌
- Thanks to @officialasishkumar, @d4v1d03, @karlhepler, @Hai Wu, @ron18219, @olinux, @Alexander Fuchs, @Emmanuel Alap, @excalq, @leon-andria, @taylormonacelli, @dennybaa, @zhuxw, @aleeriz, @steeling, and others for their valuable feedback and suggestions while using KCL recently 🙌

## Overview

Thanks to all contributors for their outstanding work over the past two weeks (2024.05.15 - 2024.05.29). Here is an overview of the key content:

**📦️ Modules Updates**

- New module `difflib` added to support configuration comparison.

Through the `diff` method provided by the `difflib`, the configuration difference is output.

```python
import difflib
import yaml

data1 = {
    "firstName": "John",
    "lastName": "Doe",
    "age": 30,
    "address": {
        "streetAddress": "1234 Main St",
        "city": "New York",
        "state": "NY",
        "postalCode": "10001"
    },
    "phoneNumbers": [
        {
            "type": "home",
            "number": "212-555-1234"
        },
        {
            "type": "work",
            "number": "646-555-5678"
        }
    ]
}
data2 = {
    "firstName": "John",
    "lastName": "Doe",
    "age": 30,
    "address": {
        "streetAddress": "1234 Main St",
        "city": "New York",
        "state": "NY",
        "postalCode": None
    },
    "phoneNumbers": [
        {
            "type": "work",
            "number": "646-555-5678"
        }
    ]
}
diff = difflib.diff(yaml.encode(data1), yaml.encode(data2))
```

**🏄 Language Updates**

- KCL 0.9.0-beta.1 released.
- Enhanced the check process for non-empty attributes in the schema, optimized the diagnostic information when the check statement is invalid due to empty attributes.
- Fixed the issue of doc parse parsing string literals as doc.
- Fixed the issue of the resolver node type missing during the compilation process.
- Added syntax error types to support quick recovery of IDE syntax errors.
- Fixed the memory leak issue in the KCL runtime.

**💻 IDE Updates**

- Added support for quick fix of some compilation errors in the IDE.
- Added support for some syntax IDE hover highlights.

IDE hover highlights for some syntax.

![hover](/img/blog/2024-05-29-biweekly-newsletter/hover.png)

For string literals, added hover highlights.

![hoverstrlit](/img/blog/2024-05-29-biweekly-newsletter/hoverstrlit.png)

- Added vscode extension to the devcontainer configuration.
- Added config expression hover tips corresponding to the schema fields in the IDE.
- Added support for identifying compilation units through the kcl.mod file in the IDE.
- Fixed the document hover format error in the IDE.
- Fixed the compilation error caused by the LSP panic in the IDE.
- Optimized the log content of LSP input.

**📬️ Toolchain Updates**

- KCL testing tool supports fast eval mode.
- Added `kcl clean` to support cleaning module caches.
- Fixed the unexpected error in the YAML Stream format import process of the KCL import tool.

- Package management tool updates.
- - Added support for renaming dependencies to prevent name conflicts through the `mod add --rename` parameter and the `kcl.mod` file.
- - Fixed the issue of missing dependencies in the `kcl.mod` file when adding a local file directory as a dependency.
- - Added support for adding git third-party dependencies through branch names.
- - Removed the invalid log output when updating dependencies.
- - Added API support for writing `kcl.mod` and `kcl.mod.lock` files.
- - Removed the process of requesting metadata when loading third-party dependencies.
- - When packaging and uploading KCL, diagnostic information is output for the case of local dependencies in the KCL package.
- - LFX term 1 task completed, the version management module mvp version merged into the main branch.
- - Supported specifying files to be packaged and skipped through the `include` and `exclude` fields in the `kcl.mod` file.
- - Removed the calculation checksum process of dependencies.

**⛵️ API Updates**

- Added `UpdateDependencies` API to support updating KCL third-party libraries.
- Added API support for writing `kcl.mod` and `kcl.mod.lock` files.
- OverrideFile API returns compilation error information.
- OverrideFile API supports inserting configurations through operators ":" and "+=".
- ListVariable API return values support parsing List and Dict structures.
- Fixed the issue of configuration format error caused by the insertion of import statements in the OverrideFile API.
- Refactored the API for obtaining schema types.
- Fixed the issue of panic caused by the LSP handle_semantic_tokens_full and handle_document_symbol methods.

**🔥 SDK Updates**

- KCL SDK v0.9.0-beta.1 released, synchronously supporting API updates.
- KCL go SDK supports importing KCL Schema through proto.

**📂️ Documentation Updates**

- Fixed typos in the development guide documentation and some environment configuration descriptions.
- Added documentation for the `file.read_env` function.
- The language document has been updated to include information about the "-" and "." symbols in schema property names.
- Added some Q&A.

**📺️ Ecosystem Integration**

- Fixed the memory leak issue in the crossplane kcl function.
- Added support for the KCL tree sitter schema, mixin, rule, and other syntax support and corresponding tests.

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
