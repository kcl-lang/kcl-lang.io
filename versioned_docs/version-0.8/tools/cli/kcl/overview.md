---
sidebar_position: 0
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

## Args

```shell
The KCL Command Line Interface (CLI).

KCL is an open-source, constraint-based record and functional language that
enhances the writing of complex configurations, including those for cloud-native
scenarios. The KCL website: https://kcl-lang.io

Usage:
  kcl [command]

Available Commands:
  clean       KCL clean tool
  completion  Generate the autocompletion script for the specified shell
  doc         KCL document tool
  fmt         KCL format tool
  help        Help about any command
  import      KCL import tool
  lint        Lint KCL codes.
  mod         KCL module management
  play        Open the kcl playground in the browser.
  registry    KCL registry management
  run         Run KCL codes.
  server      Run a KCL server
  test        KCL test tool
  version     Show version of the KCL CLI
  vet         KCL validation tool

Flags:
  -h, --help      help for kcl
  -v, --version   version for kcl

Use "kcl [command] --help" for more information about a command.
```
