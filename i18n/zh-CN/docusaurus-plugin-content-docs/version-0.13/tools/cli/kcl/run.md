---
sidebar_position: 1
---

# 运行 KCL 代码

## 参数说明

```shell
This command runs the kcl code and displays the output. 'kcl run' takes multiple input for arguments.

For example, 'kcl run path/to/kcl.k' will run the file named path/to/kcl.k

Usage:
  kcl run [flags]

Aliases:
  run, r

Examples:
  # Run the current package
  kcl run

  # Run a single file and output YAML
  kcl run path/to/kcl.k

  # Run a single file and output JSON
  kcl run path/to/kcl.k --format json

  # Run a single file and output TOML
  kcl run path/to/kcl.k --format toml

  # Run a single file and output XML
  kcl run path/to/kcl.k --format xml

  # Run multiple files
  kcl run path/to/kcl1.k path/to/kcl2.k

  # Run OCI modules
  kcl run oci://ghcr.io/kcl-lang/helloworld --tag 0.1.0

  # Run remote Git repo
  kcl run git://github.com/kcl-lang/flask-demo-kcl-manifests --commit ade147b

  # Run OCI modules by flag
  kcl run --oci https://ghcr.io/kcl-lang/helloworld --tag 0.1.0

  # Run remote module from Git with branch repo by flag
  kcl run --git https://github.com/kcl-lang/flask-demo-kcl-manifests --branch main

  # Run remote module from Git with branch repo by flag with ssh url
  kcl run --git ssh://github.com/kcl-lang/flask-demo-kcl-manifests --branch main

  # Run OCI submodule by flag
  kcl run subhelloworld --oci https://ghcr.io/kcl-lang/helloworld --tag 0.1.4

  # Run OCI submodule with version by flag
  kcl run subhelloworld:0.0.1 --oci https://ghcr.io/kcl-lang/helloworld --tag 0.1.4

  # Run Git submodule by flag
  kcl run cc --git https://github.com/kcl-lang/flask-demo-kcl-manifests --commit 8308200

  # Run Git submodule with version by flag
  kcl run cc:0.0.1 --git https://github.com/kcl-lang/flask-demo-kcl-manifests --commit 8308200

Flags:
  -D, --argument stringArray        Specify the top-level argument
  -b, --branch string               Specify the branch for the Git artifact
  -c, --commit string               Specify the commit for the Git artifact
  -d, --debug                       Run in debug mode
  -n, --disable_none                Disable dumping None values
  -E, --external stringArray        Specify the mapping of package name and path where the package is located
      --format string               Specify the output format (yaml, json, toml, xml). When xml is selected, schema attributes decorated with `@info(type="attr")` are rendered as `name="value"` attributes on the parent element instead of as child elements. (default "yaml")
      --git string                  Specify the KCL module git url
  -h, --help                        help for run
      --no_style                    Set to prohibit output of command line waiting styles, including colors, etc.
      --oci string                  Specify the KCL module oci url
  -o, --output string               Specify the YAML/JSON output file path
  -O, --overrides stringArray       Specify the configuration override path and value
  -S, --path_selector stringArray   Specify the path selectors
  -q, --quiet                       Set the quiet mode (no output)
  -Y, --setting stringArray         Specify the command line setting files
  -H, --show_hidden                 Display hidden attributes
  -k, --sort_keys                   Sort output result keys
  -r, --strict_range_check          Do perform strict numeric range checks
  -t, --tag string                  Specify the tag for the OCI or Git artifact
  -V, --vendor                      Run in vendor mode
```
