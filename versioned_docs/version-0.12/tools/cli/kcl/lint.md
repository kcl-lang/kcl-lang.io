---
sidebar_position: 5
---

# Lint

The KCL Lint tool supports checking some warning-level defects in KCL code and supports multiple output formats. This document shows how to use the KCL Lint tool.

## Example

### Project Structure

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
kcl lint your_config.k
```

or

```shell
kcl lint your_config_path
```

## Args

```shell
This command lints the kcl code. 'kcl lint' takes multiple input for arguments.

For example, 'kcl lint path/to/kcl.k' will lint the file named path/to/kcl.k

Usage:
  kcl lint [flags]

Examples:
  # Lint a single file and output YAML
  kcl lint path/to/kcl.k

  # Lint multiple files
  kcl lint path/to/kcl1.k path/to/kcl2.k

  # Lint OCI packages
  kcl lint oci://ghcr.io/kcl-lang/helloworld

  # Lint the current package
  kcl lint

Flags:
  -D, --argument stringArray    Specify the top-level argument
  -d, --debug                   Run in debug mode
  -n, --disable_none            Disable dumping None values
  -E, --external strings        Specify the mapping of package name and path where the package is located
      --format string           Specify the output format (default "yaml")
  -h, --help                    help for lint
      --no_style                Set to prohibit output of command line waiting styles, including colors, etc.
  -o, --output string           Specify the YAML/JSON output file path
  -O, --overrides strings       Specify the configuration override path and value
  -S, --path_selector strings   Specify the path selectors
  -q, --quiet                   Set the quiet mode (no output)
  -Y, --setting strings         Specify the command line setting files
  -H, --show_hidden             Display hidden attributes
  -k, --sort_keys               Sort output result keys
  -r, --strict_range_check      Do perform strict numeric range checks
  -t, --tag string              Specify the tag for the OCI or Git artifact
  -V, --vendor                  Run in vendor mode
```
