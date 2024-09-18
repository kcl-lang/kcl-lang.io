---
sidebar_position: 3
---

# IntelliJ IDEA

## Quick Start

- **Step 1.** [Install KCL](https://kcl-lang.io/docs/user_docs/getting-started/install) on your system. Please check that `kcl` and `kcl-language-server` are installed and have been added to your PATH:
  In MacOs and Linux:

  ```bash
  which kcl
  which kcl-language-server
  ```

  In Windows:

  ```bash
  where kcl
  where kcl-language-server
  ```

- **Step 2.** Install the [KCL plugin](https://plugins.jetbrains.com/plugin/23378-kcl) from Jetbrains Plugins Marketplace .
- **Step 3.** Reopen IntelliJ IDEA and create a KCL file and begin your KCL tour!

## Features

This extension provides many coding assistance based on Language Server Protocol.

- **Highlight:** Syntax and semantic highlight
- **Completion:** Completion for keywords, variable name, attributes and more
- **Goto definition:** Goto definition of schema, variable, schema attribute, and import pkg
- **Structure:** Main definition(schema def) and variables in KCL file
- **Hover:** Identifier information (type and schema documentation)
- **Diagnostics:** Warnings and errors in KCL file
- **Code Action:** Quick fix for some errors
- **InlayHint:** Hint for variable type, function and schema args

Other useful features such as diagnostics and testing are in developing.

## Dependencies

We recommend that you use the latest version of KCL, but the minimum required version for this extension is 0.4.6. If you are using an earlier version, the extension may not work properly.

The minimun required version for IntelliJ IDEA is 2022.1

## Known Issues

See [here](https://github.com/kcl-lang/kcl/issues).

## Ask for help

If the extension isn't working as you expect, please contact us with [community](https://kcl-lang.io/docs/community/intro/support) for help.

## Contributing

We are working actively on improving the KCL development on VS Code. All kinds of contributions are welcomed. You can refer to our [contribution guide](https://kcl-lang.io/docs/community/contribute). It introduces how to build and run the extension locally, and describes the process of sending a contribution.

## License

Apache License 2.0
