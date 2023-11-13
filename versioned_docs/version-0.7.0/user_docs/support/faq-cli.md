---
sidebar_position: 4
---

# Command Line Tool

## 1. What is the function of the `settings.yaml` in the application directory of the Konfig?

The `settings.yaml` in KCL indicates the configuration file of the KCL command line tool. You can put the compiled configuration into it, such as the file to be compiled, the option dynamic parameter that needs to be input(`-d`), whether to ignore the null value(`-n`) and other configurations.

For example, for the following arguments:

```shell
kcl main.k -D key=value -n -r
```

It can be replaced by the following command line arguments and `settings.yaml`

```shell
kcl -Y settings.yaml
```

settings.yaml

```yaml
kcl_cli_configs:
  files:
    - main.k
  disable_none: true
  strict_range_check: true
kcl_options:
  - key: key
    value: value
```

- `kcl_cli_configs` indicates configurable compilation arguments, `file` indicates the KCL file used for compilation，`disable_none` indicates whether to use `-n`, `strict_range_check` indicates whether to use `-r`.
- `kcl_options` indicates dynamic options that can be configured, `key` indicates option name, `value` indicates option value

Note: The file name does not need to be `settings.yaml`, but the configuration in it must meet the requirements.

### 2. How to input dynamic options? How to get dynamic options in code?

KCL supports multiple ways to input dynamic options

- `-D`: Use the command line argument `-D` to input dynamic options. It supports basic data types str/int/float/bool and structured data types list/dict

```shell
kcl main.k -D env-type=TEST -D deploy-topology='[{"cluster":"my-cluster","idc":"my-idc","replicas":2,"workspace":"my-idc","zone":"my-zone"}]'
```

- `-Y`: Use the command line argument `-Y` to input dynamic options by configuration file:

```yaml
kcl_options:
  - key: env-type
    value: TEST
  - key: deploy-topology
    value:
      - cluster: my-cluster
        idc: my-idc
        replicas: 2
        workspace: my-workspace
        zone: my-zone
```

Use the built-in function `option()` to get it:

```python
env = option("env-type")
deploy_topology = option("deploy-topology")
```

Output:

```yaml
env: TEST
deploy_topology:
  - cluster: my-cluster
    idc: my-idc
    replicas: 2
    workspace: my-workspace
    zone: my-zone
```

### 3. How to compile multiple files?

- Input multiple files in the command line:

```shell
kcl file1.k file2.k file3.k
```

- Set multiple files in configuration file and use command line argument `-Y`:

settings.yaml

```yaml
kcl_cli_configs:
  files:
    - file1.k
    - file2.k
    - file3.k
```

```shell
kcl -Y settings.yaml
```
