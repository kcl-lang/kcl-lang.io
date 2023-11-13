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
    └── .kcllint
    └── a.k
    └── b.k
    └── dir
        └── c.k
    └── test.k
```

`.kcllint` is the configuration file of lint and it is optional. `a.k`, `b.k`, `c.k` and `test.k` are the kcl file to be checked.

Args：

```shell
kcl-lint your_config.k
```

or

```shell
kcl-lint your_config_path
```

lint configuration file

```shell
kcl-lint --config abspath/.kcllint your_config.k
```

Output:

```shell
/Users/../test.k:12:1: E0501 line too long (122 > 120 characters)
# line too long, line too long, line too long, line too long, line too long, line too long, line too long, line too long,
^

/Users/../test.k:14:1: E0413 Import b should be placed at the top of the module
import b
^


Check total 1 files:
1       E0413: ImportStmt is not at the top of the file
1       E0501: Line too long
KCL Lint: 2 problems
```

## KCL Lint Tool

### Args

```shell
usage: kcl-lint [-h] [--config file] [file]

positional arguments:
  file           KCL file path

optional arguments:
  -h, --help     show this help message and exit
  --config file  KCL lint config path
```

- --config: path of `.kcllint`
- file: the path of a single `*.k` file or directory to be checked. Support the absolute path or relative path of the current directory.

### Lint Configuration

#### Priority

The priority of Lint's configuration is as follows:

1. the `.kcllint` set in CLI Args
2. the `.kcllint` under the directory of checked `.k` file or checked directory
3. default configuration

#### .kcllint

The file `.kcllint` is written in YAML. Its contents include:

- check_list: kinds of checks, including `"import"` and `"misc"`
- ignore: ignored check items. See the `Error Code` for optional items.
- max_line_length: check parameter, that is, the maximum length of code
- output: output streams and formats, including `"stdout"`、`"file"` and `"sarif"`
- output_path: The path of the output file. It is optional, but it is required when the `output` is set as `"file"` or `"sarif"`

Example:

```yaml
check_list: ["import", "misc"]
ignore: ["E0501"]
max_line_length: 120
output: ["stdout"]
output_path:
```

#### Default Configuration:

```yaml
check_list: ["import", "misc"]
ignore": []
max_line_length: 200
output: ["stdout"]
```

### Error Code

- import_checker
  - E0401: Unable to import.
  - W0401: Reimport.
  - E0406: Module import itself.
  - W0411: Import but unused.
  - E0413: ImportStmt is not at the top of the file
- misc_checker
  - E0501: Line too long
