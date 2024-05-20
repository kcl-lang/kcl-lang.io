---
sidebar_position: 3
---

# IntelliJ IDEA

We provide two IntelliJ KCL plugins:

- IntelliJ KCL: The basic version of the KCL plugin provides syntax highlighting and keyword completion. It is compatible with multiple versions of IntelliJ IDE.
- IntelliJ KCL LSP: This plugin is implemented based on the [Language Server Protocol（LSP)](https://code.visualstudio.com/api/language-extensions/language-server-extension-guide) and offers additional features such as diagnostics, completion, and hovering. However, due to certain limitations, it can only be used with specific versions.

> The integration with the Language Server Protocol is created as an extension to the paid IntelliJ-based IDEs. Therefore, plugins using Language Server integration are not available in Community releases of JetBrains products and Android Studio from Google.
> Starting with the 2023.2 release cycle, the LSP API is publicly available as part of the IntelliJ Platform in the following IDEs: IntelliJ IDEA Ultimate, WebStorm, PhpStorm, PyCharm Professional, DataSpell, RubyMine, CLion, Aqua, DataGrip, GoLand, Rider, and RustRover.

## IntelliJ KCL

The basic version of the KCL plugin can be directly downloaded and used from the IntelliJ Plugin Marketplace. It provides syntax highlighting and keyword completion.
![intellij](/img/docs/tools/Ide/intellij/kcl.png)

## IntelliJ KCL LSP

> Please note that the LSP version of the plugin may not be available in all versions of IntelliJ IDE.
> [https://plugins.jetbrains.com/docs/intellij/language-server-protocol.html#supported-ides]

IntelliJ KCL LSP also can be downloaded from the plugin marketplace

![intellij](/img/docs/tools/Ide/intellij/kcl-lsp.png)

Additionally, you need to install the [kcl-language-server](https://www.kcl-lang.io/docs/user_docs/getting-started/install#install-language-server) and verify that the `kcl-language-server` command is in your PATH. Here are the steps for different operating systems:

  For macOS and Linux:

  ```bash
  which kcl-language-server
  ```

  For Windows:

  ```bash
  where kcl-language-server
  ```
