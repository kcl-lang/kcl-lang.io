---
slug: 2024-06-12-newsletter
title: KCL Newsletter (2024.05.30 - 2024.06.12)
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

- Thanks to @shruti2522 for contributions to the KCL IDE string union type variable completion and function symbol highlighting 🙌
- Thanks to @ihor-hrytskiv for contributions to the jsonpatch module 🙌
- Thanks to @selfuryon for contributions to the KCL Nix Package 🙌
- Thanks to @nestoralonso for contributions to the ArgoCD KCL plugin 🙌
- Thanks to @Vishalk91-4 for contributions to the KCL tree-sitter-grammar 🙌
- Thanks to @Daksh-10 for contributions to the KCL tree-sitter-grammar 🙌
- Thanks to @officialasishkumar for contributions to the kcl.mod file serialization/deserialization API 🙌
- Thanks to @d4v1d03 for contributions to the KCL FAQ documentation 🙌
- Thanks to @liangyuanpeng, @atelsier, @mproffitt, @steeling, @eshepelyuk, @SjuulJanssen, @riven-blade, @excalq, @Wck-iipi, @Yvan da Silva, @Hai Wu, and others for their invaluable suggestions and feedback during the recent period of using KCL 🙌

## Overview

Thanks to all contributors for their outstanding work over the past two weeks (2024.05.30 - 2024.06.12). Here is an overview of the key content:

**📦️ Modules Updates**

The `jsonpatch` library released version 0.0.4, fixing unexpected errors in the set_obj function. You can add the latest jsonpatch dependency using `kcl mod add jsonpatch`. Usage example:

```python
import jsonpatch as p

test_json_patch = lambda {
    data = {
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
    phoneNumbers0type: str = p.get_obj(data, "phoneNumbers/0/type")
    addressCity: str = p.get_obj(data, "address/city")
    newType = p.set_obj(data, "phoneNumbers/0/type", "school")
    newState = p.set_obj(data, "address/state", "WA")
    assert phoneNumbers0type == "home"
    assert addressCity == "New York"
    assert newType["phoneNumbers"][0]["type"] == "school"
    assert newState["address"]["state"] == "WA"
}

test_json_patch()
```

**🏄 Language Updates**

- Fixed an error with the schema insertion operator += during configuration merging.
- Improved error messages for undefined variables in multi-line string interpolation.

**💻 IDE Updates**

- Added highlighting support for kcl.mod and kcl.mod.lock files.
- Added support for restarting the kcl-language-server via VS Code Command.
- Improved messaging when the kcl-language-server is not found.
- Added member completion for string union types.
- Added function symbol highlighting to differentiate between normal variables and function variables.

**📬️ Toolchain Updates**

- `kcl import` tool now supports conversion from toml to KCL configuration.
- `kcl import` tool now supports YAML Stream format input and conversion to KCL configuration.
- `kcl run` now supports toml format output.
- `kcl run` and `kcl mod` commands now support the -q flag to disable extra message output.
- `kcl mod add` command improves the downloading process to prevent errors caused by unexpected interruptions.
- `kcl mod add` command supports adding dependencies from various OCI and Git sources.

**⛵️ API Updates**

- Added support for prototext format and KCL schema output to KCL configuration.
- Added support for serializing arbitrary Go types to KCL configuration.
- `ListVariables` API now supports multiple file input and configuration merge output.

**🔥 SDK Updates**

- Added KCL WASM module, supporting the compilation of KCL code in Rust using wasmtime or Node.js and other runtimes. For more details, see: [https://www.kcl-lang.io/docs/reference/xlang-api/wasm-api](https://www.kcl-lang.io/docs/reference/xlang-api/wasm-api). Future support for running KCL in a pure browser environment is planned.

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
