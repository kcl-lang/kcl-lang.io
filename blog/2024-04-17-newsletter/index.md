---
slug: 2024-04-17-newsletter
title: KCL Newsletter (2024.04.04 - 2024.04.17)
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

Thanks to to all contributors for their outstanding work over the past twenty days (2024.04.04 - 2024.04.17). Here is an overview of the key content.

**🏄 Language Updates**

- The `instances()` method of Schema has added a new keyword parameter `full_pkg` for reading all instances corresponding to the Schema in the code.

```python
schema Person:
    name: str

alice = Person {name = "Alice"}
all_persons = Person.instances(True)
```

- Added the `template` system module for manipulation of templates in KCL.

```python
import template

content = template.execute("""\
<div class="entry">
{{#if author}}
<h1>{{firstName}} {{lastName}}</h1>
{{/if}}
</div>
""", {
  author: True,
  firstName: "Yehuda",
  lastName: "Katz",
})
```

**⛵️ Toolchain Updates**

- The OverrideFile API supports modifying/deleting non-schema type fields.
- New ListVariable API for reading the values of variables in KCL files.

**🔥 SDK Updates**

- The KCL Go SDK has been released in version 0.8.4.
- The KCL Rust SDK has added the `llvm` feature, allowing to choose whether to use the LLVM, defaulting to off. When the LLVM feature is turned off, binary size can be reduced by 90%. Dependencies can be added in the following way:

```shell
cargo add --git https://github.com/kcl-lang/lib
```

- The initial release of the KCL Node.js SDK. Repository link: [https://github.com/kcl-lang/lib/tree/main/nodejs](https://github.com/kcl-lang/lib/tree/main/nodejs). Contributions are welcome.

* `__test__/test_data/schema.k`

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

- `execProgram`

```ts
import { execProgram, ExecProgramArgs } from "kcl-lib";

function main() {
  const result = execProgram(new ExecProgramArgs(["__test__/test_data/schema.k"]));
  console.log(result.yamlResult);  // 'app:\n  replicas: 2'
}

main();
```

- `listVariables`

```ts
import { listVariables, ListVariablesArgs } from "kcl-lib";

function main() {
  const result = listVariables(
    ListVariablesArgs("__test__/test_data/schema.k", []),
  );
  console.log(result.variables["app"].value); // 'AppConfig {replicas: 2}'
}

main();
```

- `loadPackage`

```ts
import { loadPackage, LoadPackageArgs } from "kcl-lib";

function main() {
  const result = loadPackage(
    LoadPackageArgs(["__test__/test_data/schema.k"], [], true),
  );
  console.log(result.symbols);
}

main();
```

**💻 IDE Updates**

- Added compilation unit caching to enhance IDE performance.

**🌼 Integration Updates**

- Crossplane KCL Function supports reading Function Context parameters for passing parameters to different functions.
  - Support reading the function context across different functions.
  - Support reading the function details to set sensitive information.
  - Support setting the status field of XR to output user information.
  - Fixed errors related to concurrent requests when issuing clusters under multiple XR resources.
- KCL has released a Nix package, allowing installation of the KCL command line tools with `nix-shell` or `devbox shell`.

## Special Thanks

We'd like to thank all the community participants from the past two weeks.

The following are listed in no particular order:

- Thanks to @bozaro for the contribution to the KCL Go SDK 🙌
- Thanks to @jheyduk for the contribution to the Kubectl KCL plugin 🙌
- Thanks to @shashank-iitbhu for the contribution to the quick fix feature for KCL IDE syntax 🙌
- Thanks to @d4v1d03 for the contribution to the KCL official website FAQ documentation 🙌
- Thanks to @octonawish-akcodes for the contribution to the automatic dependency update feature for KCL IDE based on kcl.mod 🙌
- Thanks to @utnim2 for the contribution to the restart kcl-language-server command for KCL IDE 🙌
- Thanks to @AkashKumar7902 for the contribution to the KCL package management tool MVS algorithm 🙌
- Thanks to @steeling, @bozaro, @vtomilov, @sanzoghenzo, @folliehiyuki, @markphillips100, @wilsonwang371, @zargor, @aleeriz, @reckless-huang, @zhuxw, @jheyduk, @Vitaly Tomilov, @Sergey Ryabin, @Stephen C, @ytsarev and others for their valuable suggestions and feedback while using KCL recently. 🙌

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
