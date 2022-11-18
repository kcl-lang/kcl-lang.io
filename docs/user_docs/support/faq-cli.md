---
sidebar_position: 5
---

# Command Line Tool

### 1. What is the function of the `settings.yaml` in the application directory of the Konfig?

The `settings.yaml` in KCL indicates the configuration file of the KCL command line tool. You can put the compiled configuration into it, such as the file to be compiled, the option dynamic parameter that needs to be input(`-d`), whether to ignore the null value(`-n`) and other configurations.

For example, for the following arguments:

```
kcl main.k -D key=value -n -r
```

It can be replaced by the following command line arguments and `settings.yaml`

```

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

```
kcl main.k -D env-type=TEST -D deploy-topology='[{"cluster":"sigma-eu126-mybank-staging","idc":"cn-hangzhou-test-eu126","replicas":2,"workspace":"middlewarehzcloudsit","zone":"CellAEU126"}]'
```

- `-Y`: Use the command line argument `-Y` to input dynamic options by configuration file:

```yaml
kcl_options:
- key: env-type
  value: TEST
- key: deploy-topology
  value:
  - cluster: sigma-eu126-mybank-staging
    idc: cn-hangzhou-test-eu126
    replicas: 2
    workspace: middlewarehzcloudsit
    zone: CellAEU126
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
- cluster: sigma-eu126-mybank-staging
  idc: cn-hangzhou-test-eu126
  replicas: 2
  workspace: middlewarehzcloudsit
  zone: CellAEU126
```

### 3. How to compile multiple files?

- Input multiple files in the command line:

```
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

```
kcl -Y settings.yaml
```

### 4. What is the function of the `settings.yaml` in the application directory of the KCL?

A Stack is an isolated logical workspace within a project. Stacks uniquely belong to a unique development group, such as the front-end development group in a web project, and uniquely represent a specific development phase, such as dev, test, or prod. From a development perspective, Stack is the basic unit of configuration for the KCL project. From an execution perspective, KCL code units are deployed into a Stack.
