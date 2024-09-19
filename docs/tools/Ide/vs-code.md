---
sidebar_position: 1
---

# Visual Studio Code

## Quick Start

- **Step 1.** [Install KCL](https://kcl-lang.io/docs/user_docs/getting-started/install) on your system. Please ensure that `kcl` and `kcl-language-server` are installed and added to your PATH:
  On MacOS and Linux:

  ```bash
  which kcl
  which kcl-language-server
  ```

  On Windows:

  ```bash
  where kcl
  where kcl-language-server
  ```

- **Step 2.** Install the [KCL extension](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-extension) for Visual Studio Code. This extension requires the VS Code 1.50+.
- **Step 3.** Reopen VS Code, create a KCL file, and begin your KCL journey!

## Features

This extension provides some coding assistance, including the following features:

- **Highlighting:**
  ![Highlight](/img/docs/tools/Ide/vs-code/Highlight.png)
- **Goto Definition:** Navigate to the definition of schema, variables, schema attributes, and imported packages
  ![Goto Definition](/img/docs/tools/Ide/vs-code/GotoDef.gif)
- **Completion:** Completion for keywords, variable names, attributes, and more
  ![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)
- **Outline:** View the main definition (schema definition) and variables in KCL files
  ![Outline](/img/docs/tools/Ide/vs-code/Outline.gif)
- **Hover:** View identifier information (type and schema documentation)
  ![Hover](/img/docs/tools/Ide/vs-code/Hover.gif)
- **Diagnostics:** Detect warnings and errors in KCL files
  ![Diagnostics](/img/docs/tools/Ide/vs-code/Diagnostics.gif)

> Tips: You can enhance the effect of diagnostics by installing another extension: [Error Lens](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens).

- **Format:** Format a KCL file or snippet code
  ![Format](/img/docs/tools/Ide/vs-code/Format.gif)
- **Quick fix:** Quick fix some diagnostics
  ![Qucik Fix](/img/docs/tools/Ide/vs-code/QuickFix.gif)
- **Inlay hint:** Display hints for variable type, functions, and schema arguments
  ![Inlay Hint](/img/docs/tools/Ide/vs-code/Inlayhint.png)

Other useful features such as refactoring and testing are in development.

## Dependencies

We recommend using the latest version of KCL, but the minimum required version for this extension is 0.4.6. If you are using an earlier version, the extension may not work properly.

## Known Issues

See [here](https://github.com/kcl-lang/kcl/issues).

## Ask for help

If the extension does not behave as expected, please reach out to us through the [community](https://kcl-lang.io/docs/community/intro/support) for assistance.

## Contributing

We are actively working to enhance KCL development on VS Code. We welcome all types of contributions. You can consult our [contribution guide](https://kcl-lang.io/docs/community/contribute), which explains how to build and run the extension locally and describes the contribution process.

## License

Apache License 2.0
