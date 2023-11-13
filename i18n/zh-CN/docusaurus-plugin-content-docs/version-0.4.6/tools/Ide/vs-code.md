# KCL Extension for Visual Studio Code

## Quick Start

- **Step 1.** [Install KCL](https://kcl-lang.io/docs/user_docs/getting-started/install) on your system. Please check that `kcl` and `kcl-language-server` are installed and have been added to Path:

  ```bash
  which kcl
  which kcl-language-server
  ```

- **Step 2.** Install the [KCL extension](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-extension) for Visual Studio Code. This extension requires the VS Code 1.50+.
- **Step 3.** Open or create a KCL file and begin your KCL tour!

## Features

This extension provides some coding assistance, including the following features:

- **Syntax Highlight:**
  ![Highlight](/img/docs/tools/Ide/vs-code/Highlight.png)
- **Goto Definition:** Goto definition of schema, variable, schema attribute, and import pkg.
  ![Goto Definition](/img/docs/tools/Ide/vs-code/GotoDef.gif)
- **Completion:** Keywords completions and dot(`.`) completion.
  ![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)
- **Outline:** Main definition(schema def) and variables in KCL file.
  ![Outline](/img/docs/tools/Ide/vs-code/Outline.gif)
- **Hover:** Identifier information (type and schema documentation).
  ![Hover](/img/docs/tools/Ide/vs-code/Hover.gif)
- **Diagnostics:** Warnings and errors in KCL file.
  ![Diagnostics](/img/docs/tools/Ide/vs-code/Diagnostics.gif)

Other useful features such as refactoring and testing are in development.

## Dependencies

We recommend that you use the latest version of KCL, but the minimum required version for this extension is 0.4.6. If you are using an earlier version, the extension may not work properly.

## Known Issues

- **Hover and GotoDefintion:** The current hover and goto definitions are similar to global search, and there may be multiple results for some Identifiers with the same name.
- **Completion:** Currently, we only support keyword completion and dot-triggered completion (e.g., `schema.attr`, `pkg.schema` and `str.methods` ). Full semantic completion is in development.

## Ask for help

If the extension isn't working as you expect, please contact us with [community](https://kcl-lang.io/docs/community/intro/support) for help.

## Contributing

We are working actively on improving the KCL development on VS Code. All kinds of contributions are welcomed. You can refer to our [contribution guide](https://kcl-lang.io/docs/community/contribute). It introduces how to build and run the extension locally, and describes the process of sending a contribution.

## License

Apache License Version 2.0
