---
sidebar_position: 3
---

# Lint

The KCL Lint tool supports checking some warning-level defects in KCL code and supports multiple output formats. This document shows how to use the KCL Lint tool.

## Example

### Project Struct

```text
.
└── Test
    └── kcl.mod
    └── a.k
    └── b.k
    └── dir
        └── c.k
    └── test.k
```

`a.k`, `b.k`, `c.k` and `test.k` are the kcl file to be checked.

Args：

```shell
kcl-lint your_config.k
```

or

```shell
kcl-lint your_config_path
```

## KCL Lint Tool

### Args

```shell
USAGE:
    kcl-lint [OPTIONS] [--] [input]...

ARGS:
    <input>...    Sets the input file to use

OPTIONS:
        --emit_warning            Emit warning message
    -h, --help                    Print help information
    -v, --verbose                 Print test information verbosely
    -Y, --setting <setting>...    Sets the input file to use
```

+ input: the path of a single `*.k` file or directory to be checked. Support the absolute path or relative path of the current directory.
