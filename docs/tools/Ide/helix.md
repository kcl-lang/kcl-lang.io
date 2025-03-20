---
sidebar_position: 4
---

# Helix

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

- **Step 2.** Amend your Helix `languages.toml` file:
  ```toml
  [[language]]
  name = "kcl"
  scope = "source.k"
  file-types = ["kcl", { glob = "*.k" } ]
  roots = ["kcl.mod", "kcl.yaml"]
  language-servers = ["kcl-lsp"]

  [language-server.kcl-lsp]
  command = "kcl-language-server"
  ```
- **Step 3.** Reopen Helix, create a KCL file, and begin your KCL journey!

## Features

This extension provides comprehensive coding assistance based on the Language Server Protocol.

<!-- - **Highlighting:** Syntax and semantic highlighting -->
- **Code Completion:** Completion for keywords, variable names, attributes, and more
<!-- - **Goto definition:** Navigate to the definition of schema, variables, schema attributes, and imported packages -->
- **Structure:** View the main definition (schema definition) and variables in KCL files
- **Hover:** View identifier information (type and schema documentation)
- **Diagnostics:** Detect warnings and errors in KCL files
- **Code Action:** Quick fix for some errors
- **InlayHint:** Display hints for variable type, functions, and schema arguments
- **Format:** Format a KCL file or snippet code

Other useful features such as diagnostics and testing are under development.

## Dependencies

We recommend using the latest version of KCL.

## Known Issues

See [here](https://github.com/kcl-lang/kcl/issues).

## Ask for help

If the extension does not behave as expected, please reach out to us through the [community](https://kcl-lang.io/docs/community/intro/support) for assistance.

## Contributing

We are actively working to enhance KCL development on Helix. We welcome all types of contributions. You can consult our [contribution guide](https://kcl-lang.io/docs/community/contribute), which explains how to build and run the extension locally and describes the contribution process.

## License

Apache License 2.0
