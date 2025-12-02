---
sidebar_position: 4
---

# Python API

## Installation

```shell
python3 -m pip install kcl-lib
```

## Quick Start

```typescript
import kcl_lib.api as api

args = api.ExecProgramArgs(k_filename_list=["path/to/kcl.k"])
api = api.API()
result = api.exec_program(args)
print(result.yaml_result)
```

## API Reference

### exec_program

Execute KCL file with arguments and return the JSON/YAML result.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Python Code

```python
import kcl_lib.api as api

args = api.ExecProgramArgs(k_filename_list=["schema.k"])
api = api.API()
result = api.exec_program(args)
assert result.yaml_result == "app:\n  replicas: 2"
```

</p>
</details>

A case with the file not found error

<details><summary>Example</summary>
<p>

```python
import kcl_lib.api as api

try:
    args = api.ExecProgramArgs(k_filename_list=["file_not_found"])
    api = api.API()
    result = api.exec_program(args)
    assert False
except Exception as err:
    assert "Cannot find the kcl file" in str(err)
```

</p>
</details>

### parse_file

Parse KCL single file to Module AST JSON string with import dependencies and parse errors.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Python Code

```python
import kcl_lib.api as api

args = api.ParseFileArgs(path=TEST_FILE)
api = api.API()
result = api.parse_file(args)
assert len(result.errors) == 0
```

</p>
</details>

### parse_program

Parse KCL program with entry files and return the AST JSON string.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Python Code

```python
import kcl_lib.api as api

args = api.ParseProgramArgs(paths=["schema.k"])
api = api.API()
result = api.parse_program(args)
assert len(result.paths) == 1
assert len(result.errors) == 0
```

</p>
</details>

### load_package

load_package provides users with the ability to parse KCL program and semantic model information including symbols, types, definitions, etc.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Python Code

```python
import kcl_lib.api as api

args = api.LoadPackageArgs(
    parse_args=api.ParseProgramArgs(paths=["schema.k"]), resolve_ast=True
)
api = api.API()
result = api.load_package(args)
assert list(result.symbols.values())[0].ty.schema_name == "AppConfig"
```

</p>
</details>

### list_variables

list_variables provides users with the ability to parse KCL program and get all variables by specs.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Python Code

```python
import kcl_lib.api as api

args = api.ListVariablesArgs(files=[TEST_FILE])
api = api.API()
result = api.list_variables(args)
assert result.variables["app"].variables[0].value == "AppConfig {replicas: 2}"
```

</p>
</details>

### list_options

list_options provides users with the ability to parse KCL program and get all option information.

<details><summary>Example</summary>
<p>

The content of `options.k` is

```python
a = option("key1")
b = option("key2", required=True)
c = {
    metadata.key = option("metadata-key")
}
```

Python Code

```python
import kcl_lib.api as api

args = api.ParseProgramArgs(paths=["options.k"])
api = api.API()
result = api.list_options(args)
assert len(result.options) == 3
assert result.options[0].name == "key1"
assert result.options[1].name == "key2"
assert result.options[2].name == "metadata-key"
```

</p>
</details>

### get_schema_type_mapping

Get schema type mapping defined in the program.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Python Code

```python
import kcl_lib.api as api

exec_args = api.ExecProgramArgs(k_filename_list=["schema.k"])
args = api.GetSchemaTypeMappingArgs(exec_args=exec_args)
api = api.API()
result = api.get_schema_type_mapping(args)
assert result.schema_type_mapping["app"].properties["replicas"].type == "int"
```

</p>
</details>

### override_file

Override KCL file with arguments. See [https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation) for more override spec guide.

<details><summary>Example</summary>
<p>

The content of `main.k` is

```python
a = 1

b = {
    "a": 1
    "b": 2
}
```

Python Code

```python
import kcl_lib.api as api
import pathlib

test_file = "main.k"
args = api.OverrideFileArgs(
    file=test_file,
    specs=["b.a=2"],
)
api = api.API()
result = api.override_file(args)
assert len(result.parse_errors) == 0
assert result.result == True
assert pathlib.Path(test_file).read_text() == """\
a = 1
b = {
    "a": 2
    "b": 2
}
"""
```

</p>
</details>

### format_code

Format the code source.

<details><summary>Example</summary>
<p>

Python Code

```python
import kcl_lib.api as api

source_code = """\
schema Person:
    name:   str
    age:    int

    check:
        0 <   age <   120
"""
args = api.FormatCodeArgs(source=source_code)
api_instance = api.API()
result = api_instance.format_code(args)
assert (
    result.formatted.decode()
    == """\
schema Person:
    name: str
    age: int

    check:
        0 < age < 120

"""
    )
```

</p>
</details>

### format_path

Format KCL file or directory path contains KCL files and returns the changed file paths.

<details><summary>Example</summary>
<p>

The content of `format_path.k` is

```python
schema Person:
    name:   str
    age:    int

    check:
        0 <   age <   120
```

Python Code

```python
import kcl_lib.api as api

args = api.FormatPathArgs(path="format_path.k")
api_instance = api.API()
result = api_instance.format_path(args)
print(result)
```

</p>
</details>

### lint_path

Lint files and return error messages including errors and warnings.

<details><summary>Example</summary>
<p>

The content of `lint_path.k` is

```python
import math

a = 1
```

Python Code

```python
import kcl_lib.api as api

args = api.LintPathArgs(paths=["lint_path.k"])
api_instance = api.API()
result = api_instance.lint_path(args)
```

</p>
</details>

### validate_code

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

Python Code

```python
import kcl_lib.api as api

code = """\
schema Person:
    name: str
    age: int

    check:
        0 < age < 120
"""
data = '{"name": "Alice", "age": 10}'
args = api.ValidateCodeArgs(code=code, data=data, format="json")
api_instance = api.API()
result = api_instance.validate_code(args)
assert result.success == True
assert result.err_message == ""
```

</p>
</details>

### rename

Rename all the occurrences of the target symbol in the files. This API will rewrite files if they contain symbols to be renamed. Return the file paths that got changed.

<details><summary>Example</summary>
<p>

The content of `main.k` is

```python
a = 1
b = a
```

Python Code

```python
import kcl_lib.api as api

args = api.RenameArgs(
    package_root=".",
    symbol_path="a",
    file_paths=["main.k"],
    new_name="a2",
)
api_instance = api.API()
result = api_instance.rename(args)
```

</p>
</details>

### rename_code

Rename all the occurrences of the target symbol and return the modified code if any code has been changed. This API won't rewrite files but return the changed code.

<details><summary>Example</summary>
<p>

Python Code

```python
import kcl_lib.api as api

args = api.RenameCodeArgs(
    package_root="/mock/path",
    symbol_path="a",
    source_codes={"/mock/path/main.k": "a = 1\nb = a"},
    new_name="a2",
)
api_instance = api.API()
result = api_instance.rename_code(args)
assert result.changed_codes["/mock/path/main.k"] == "a2 = 1\nb = a2"
```

</p>
</details>

### test

Test KCL packages with test arguments.

<details><summary>Example</summary>
<p>

Python Code

```python
import kcl_lib.api as api
args = api.TestArgs(
    pkg_list=["path/to/testing/pkg/..."],
)
api_instance = api.API()
result = api_instance.test(args)
```

</p>
</details>

### load_settings_files

Load the setting file config defined in `kcl.yaml`

<details><summary>Example</summary>
<p>

The content of `kcl.yaml` is

```yaml
kcl_cli_configs:
  strict_range_check: true
kcl_options:
  - key: key
    value: value
```

Python Code

```python
import kcl_lib.api as api

args = api.LoadSettingsFilesArgs(
    work_dir=".", files=["kcl.yaml"]
)
api_instance = api.API()
result = api_instance.load_settings_files(args)
assert result.kcl_cli_configs.files == []
assert result.kcl_cli_configs.strict_range_check == True
assert (
    result.kcl_options[0].key == "key" and result.kcl_options[0].value == '"value"'
)
```

</p>
</details>

### update_dependencies

Download and update dependencies defined in the `kcl.mod` file and return the external package name and location list.

<details><summary>Example</summary>
<p>

The content of `module/kcl.mod` is

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

Python Code

```python
import kcl_lib.api as api

args = api.UpdateDependenciesArgs(
    manifest_path="module"
)
api_instance = api.API()
result = api_instance.update_dependencies(args)
pkg_names = [pkg.pkg_name for pkg in result.external_pkgs]
assert len(pkg_names) == 2
assert "helloworld" in pkg_names
assert "flask" in pkg_names
```

</p>
</details>

Call `exec_program` with external dependencies

<details><summary>Example</summary>
<p>

The content of `module/kcl.mod` is

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

The content of `module/main.k` is

```python
import helloworld
import flask

a = helloworld.The_first_kcl_program
```

Python Code

```python
import kcl_lib.api as api

args = api.UpdateDependenciesArgs(
    manifest_path="module"
)
api_instance = api.API()
result = api_instance.update_dependencies(args)
exec_args = api.ExecProgramArgs(
    k_filename_list=["module/main.k"],
    external_pkgs=result.external_pkgs,
)
result = api_instance.exec_program(exec_args)
assert result.yaml_result == "a: Hello World!"
```

</p>
</details>

### get_version

Return the KCL service version information.

<details><summary>Example</summary>
<p>

Python Code

```python
import kcl_lib.api as api

api_instance = api.API()
result = api_instance.get_version()
print(result.version_info)
```

</p>
</details>
