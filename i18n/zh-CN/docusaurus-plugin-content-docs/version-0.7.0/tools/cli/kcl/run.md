---
sidebar_position: 1
---

# 运行 KCL 代码

## 参数说明

```shell
Usage:
  kcl run [flags]

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
  -t, --tag string              Specify the tag fo
```
