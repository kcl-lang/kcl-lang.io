---
sidebar_position: 1
---

# Overview

KCL toolchain is a toolset of KCL language, which aims to improve the efficiency of batch migration, writing, compiling and running of KCL.

|            | Name                     | Description                                                         |
| ---------- | ------------------------ | ------------------------------------------------------------------- |
| Main Tools | **kcl**                  | Provide support for KCL in coding, compiling and running            |
|            | kcl-test                 | Coming soon                                                         |
|            | kcl-lint                 | Check code style for KCL                                            |
|            | kcl-doc                  | Parses the KCL code and generate documents                          |
|            | kcl-fmt                  | Format the kcl code                                                 |
|            | kcl-vet                  | Validate data files such as JSON and YAML using KCL                 |
| IDE Plugin | IntelliJ IDEA KCL plugin | Provide assistance for KCL in coding and compiling on IntelliJ IDEA |
|            | VS Code KCL plugin       | Provide assistance for KCL in coding and compiling on VS Code       |

## KCL Tool

### Args

```shell
USAGE:
    kcl [OPTIONS] [--] [input]...

Arguments:
  [input]...  Specify the input files to run

Options:
  -o, --output <output>
          Specify the YAML output file path
  -Y, --setting <setting>...
          Specify the input setting file
  -v, --verbose...
          Print test information verbosely
  -n, --disable_none
          Disable dumping None values
  -r, --strict_range_check
          Do perform strict numeric range checks
  -d, --debug
          Run in debug mode (for developers only)
  -k, --sort_keys
          Sort result keys
  -D, --argument <arguments>...
          Specify the top-level argument
  -S, --path_selector <path_selector>...
          Specify the path selector
  -O, --overrides <overrides>...
          Specify the configuration override path and value
      --target <target>
          Specify the target type
  -E, --external <package_map>...
          Mapping of package name and path where the package is located
  -h, --help
          Print help
```
