---
sidebar_position: 3
---

# IntelliJ IDEA

We provide two IntelliJ KCL plugin

- IntelliJ KCL: The basic version of the KCL plugin provides basic features of syntax highlighting and keywords completion, and can be used in more versions of IntelliJ IDE.

- IntelliJ KCL LSP: The KCL plugin implemented based on [LSP (Language Server Protocol)](https://code.visualstudio.com/api/language-extensions/overview) provides more features, such as diagnostics, completion, hover and others. But for some [reasons](https://plugins.jetbrains.com/docs/intellij/language-server-protocol.html#supported-ides), it can only be used in specific versions.

> The integration with the Language Server Protocol is created as an extension to the paid IntelliJ-based IDEs. Therefore, plugins using Language Server integration are not available in Community releases of JetBrains products and Android Studio from Google.
> Starting with the 2023.2 release cycle, the LSP API is publicly available as part of the IntelliJ Platform in the following IDEs: IntelliJ IDEA Ultimate, WebStorm, PhpStorm, PyCharm Professional, DataSpell, RubyMine, CLion, Aqua, DataGrip, GoLand, Rider, and RustRover.

## IntelliJ KCL

The basic version of the KCL plug-in can be downloaded and used directly from the IntelliJ plugin marketplace. The basic version provides syntax highlighting and keywords completion.
![intellij](/img/docs/tools/Ide/intellij/kcl.png)

## IntelliJ KCL LSP

> Note that the LSP version of the plugin is not necessarily available in all versions of IntelliJ IDE. 
> https://plugins.jetbrains.com/docs/intellij/language-server-protocol.html#supported-ides

IntelliJ KCL LSP also can be downloaded from the plugin marketplace
<!-- todo, wait for plugin publish -->
![intellij](/img/docs/tools/Ide/intellij/kcl.png)

Apart from that, you need to install [kcl-language-server](https://www.kcl-lang.io/docs/user_docs/getting-started/install#install-language-server) and check `kcl- The language-server` command is in your PATH:
In MacOs and Linux：

  ```bash
  which kcl-language-server
  ```

  In Windows:

  ```bash
  where kcl-language-server
  ```
