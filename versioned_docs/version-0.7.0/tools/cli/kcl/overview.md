---
sidebar_position: 1
---

# Overview

KCL toolchain is a toolset of KCL language, which aims to improve the efficiency of batch migration, writing, compiling and running of KCL.

|            | Name                         | Description                                                         |
| ---------- | ---------------------------- | ------------------------------------------------------------------- |
| Main Tools | **kcl** (alias of `kcl run`) | Provide support for KCL in coding, compiling and running            |
|            | kcl run                      | Provide support for KCL in coding, compiling and running            |
|            | kcl doc                      | Parses the KCL code and generate documents                          |
|            | kcl fmt                      | Format the kcl code                                                 |
|            | kcl import                   | Import other data and schema to KCL                                 |
|            | kcl lint                     | Check code style for KCL                                            |
|            | kcl mod                      | KCL module related features and package management                  |
|            | kcl play                     | Run the KCL playground in localhost                                 |
|            | kcl registry                 | KCL registry related features                                       |
|            | kcl server                   | Run the KCL REST server in localhost                                |
|            | kcl test                     | Run unit tests in KCL                                               |
|            | kcl vet                      | Validate data files such as JSON and YAML using KCL                 |
| IDE Plugin | IntelliJ IDEA KCL extension  | Provide assistance for KCL in coding and compiling on IntelliJ IDEA |
|            | NeoVim KCL extension         | Provide assistance for KCL in coding and compiling on NeoVim        |
|            | VS Code KCL extension        | Provide assistance for KCL in coding and compiling on VS Code       |

## KCL Tool

### Args

```shell
This command runs the kcl code and displays the output. 'kcl run' takes multiple input for arguments.

For example, 'kcl run path/to/kcl.k' will run the file named path/to/kcl.k

Usage:
  run [flags]

Aliases:
  run, r

Examples:
  # Run a single file and output YAML
  kcl run path/to/kcl.k

  # Run a single file and output JSON
  kcl run path/to/kcl.k --format json

  # Run multiple files
  kcl run path/to/kcl1.k path/to/kcl2.k

  # Run OCI packages
  kcl run oci://ghcr.io/kcl-lang/hello-world

  # Run the current package
  kcl run


Flags:
  -D, --argument strings        Specify the top-level argument
  -d, --debug                   Run in debug mode
  -n, --disable_none            Disable dumping None values
  -E, --external strings        Specify the mapping of package name and path where the package is located
      --format string           Specify the output format (default "yaml")
  -h, --help                    help for run
      --no_style                Set to prohibit output of command line waiting styles, including colors, etc.
  -o, --output string           Specify the YAML/JSON output file path
  -O, --overrides strings       Specify the configuration override path and value
  -S, --path_selector strings   Specify the path selectors
  -q, --quiet                   Set the quiet mode (no output)
  -Y, --setting strings         Specify the command line setting files
  -k, --sort_keys               Sort output result keys
  -r, --strict_range_check      Do perform strict numeric range checks
  -t, --tag string              Specify the tag for the OCI or Git artifact
  -V, --vendor                  Run in vendor mode
```
