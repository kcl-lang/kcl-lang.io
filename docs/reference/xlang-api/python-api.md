---
sidebar_position: 4
---

# Python API

> **Looking for the cross-language FFI contract?**
> See [`./ffi-abi.md`](./ffi-abi.md) for `call`, the `"ERROR:"` prefix, the
> **4 MiB** `BUFFER_SIZE`, and how the `_kcl_lib.so` extension routes into
> `kcl_api::call`. The `kcl_lib.api.API` class below is a thin Python
> wrapper over that single C ABI.

The official [Python KCL package](https://github.com/kcl-lang/lib/tree/main/python)
is built on [PyO3](https://pyo3.rs) and exposes the entire `KclService`
+ `BuiltinService` surface as two Python layers:

- **`kcl_lib.api`** — low-level protobuf wrappers. Every method takes a
  typed `*Args` proto (auto-generated from `spec/spec.proto`) and returns
  the matching `*Result`. This is the canonical surface and the one to use
  when you want a typed message in and out.
- **`kcl_lib.kcl`** — high-level façade mirroring the
  [`kcl-go`](https://github.com/kcl-lang/kcl-go) SDK. Provides
  `run(path, *opts)` / `must_run` / `run_files`, a functional `Option`
  chain (`with_overrides`, `with_disable_none`, …), and a `KCLResult`
  helper with dotted-key `get`/`to_dict` access.

## Installation

```shell
python3 -m pip install kcl-lib
```

The only declared dependency is `protobuf`. Building from source needs a
working Rust toolchain; the PyPI wheel bundles the prebuilt
`_kcl_lib.cpython-*.so` extension.

## Quick Start

With a `schema.k` file:

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

You can run:

```python
import kcl_lib.api as api

args = api.ExecProgramArgs(k_filename_list=["schema.k"])
api_instance = api.API()
result = api_instance.exec_program(args)
print(result.yaml_result)
```

Or, using the high-level façade:

```python
import kcl_lib.kcl as kcl

results, err = kcl.run("schema.k")
if err is not None:
    raise err
print(results.first().yaml_string())
assert results.first().get("app.replicas") == 2
```

## Low-level API (`kcl_lib.api`)

### API

The single entry point for every RPC. Instantiate once per thread:

```python
import kcl_lib.api as api

api_instance = api.API()
```

By default it talks to the in-process plugin agent pointer installed by
`kcl_lib.plugin.plugin_agent_addr`. Pass `plugin_agent=<addr>` to use a
different one.

#### `API.call(name, args)`

Universal dispatcher. Sends the encoded `args` proto to `<name>` (e.g.
`"KclService.ExecProgram"`) and returns the decoded response message.

```python
import kcl_lib.api as api

api_instance = api.API()
result = api_instance.call("KclService.Ping", api.PingArgs(value="hi"))
assert result.value == "hi"
```

`call` raises `Exception(...)` if the dispatcher replies with the
`"ERROR:..."` prefix; see
[`./ffi-abi.md`](./ffi-abi.md) §4.

#### Typed methods

Every method maps 1:1 to a `spec/spec.proto` RPC. The full list shipped
in `kcl_lib.api.service.API`:

| Method                             | Proto RPC                                | Notes                                       |
| ---------------------------------- | ---------------------------------------- | ------------------------------------------- |
| `ping(args)`                       | `KclService.Ping`                        | Round-trips `value`                         |
| `parse_file(args)`                 | `KclService.ParseFile`                   | Single-file AST JSON                        |
| `parse_program(args)`              | `KclService.ParseProgram`                | Multi-file AST envelope                     |
| `load_package(args)`               | `KclService.LoadPackage`                 | AST + symbols + scopes + types              |
| `exec_program(args)`               | `KclService.ExecProgram`                 | YAML / JSON emit, v0.13.0 Source Map v3     |
| `list_variables(args)`             | `KclService.ListVariables`               | Filtered by `--specs`                       |
| `list_options(args)`               | `KclService.ListOptions`                 | Reuses `ParseProgramArgs`                   |
| `format_code(args)`                | `KclService.FormatCode`                  | In-memory source → formatted source         |
| `format_path(args)`                | `KclService.FormatPath`                  | On-disk formatter, returns changed paths    |
| `lint_path(args)`                  | `KclService.LintPath`                    | Errors + warnings                           |
| `override_file(args)`              | `KclService.OverrideFile`                | `*-override` specs, mutates file            |
| `get_schema_type_mapping(args)`    | `KclService.GetSchemaTypeMapping`        | Flattens all schemas under `__main__`       |
| `get_schema_type_mapping_under_path(args)` | `KclService.GetSchemaTypeMappingUnderPath` | Added in v0.13.0; keyed by package     |
| `validate_code(args)`              | `KclService.ValidateCode`                | In-memory schema + data                     |
| `load_settings_files(args)`        | `KclService.LoadSettingsFiles`           | `kcl.yaml` config                           |
| `rename(args)`                     | `KclService.Rename`                      | Rewrites files on disk                      |
| `rename_code(args)`                | `KclService.RenameCode`                  | Returns modified sources, no FS writes      |
| `test(args)`                       | `KclService.Test`                         | Runs `_test.*`, v0.13.0 adds line coverage  |
| `update_dependencies(args)`        | `KclService.UpdateDependencies`          | `kcl.mod` dependency resolver               |
| `get_version()`                    | `KclService.GetVersion`                  | `version` / `git_sha` / `checksum`          |
| `list_method()`                    | `BuiltinService.ListMethod`               | List of dispatcher RPC names                |

### Examples

The full source of `kcl_lib/api/service.py` is the canonical reference
(every method has a working example in its docstring). Highlights:

#### `exec_program`

```python
import kcl_lib.api as api

args = api.ExecProgramArgs(k_filename_list=["schema.k"])
result = api.API().exec_program(args)
assert result.yaml_result == "app:\n  replicas: 2"
```

A case with the file not found error:

```python
import kcl_lib.api as api

try:
    api.ExecProgramArgs(k_filename_list=["file_not_found"])
    api.API().exec_program(api.ExecProgramArgs(k_filename_list=["file_not_found"]))
    assert False
except Exception as err:
    assert "Cannot find the kcl file" in str(err)
```

#### `parse_program` / `parse_file`

```python
import kcl_lib.api as api

api_instance = api.API()
parsed = api_instance.parse_program(api.ParseProgramArgs(paths=["schema.k"]))
assert len(parsed.paths) == 1
assert len(parsed.errors) == 0

single = api_instance.parse_file(api.ParseFileArgs(path="schema.k"))
assert single.ast_json
```

#### `load_package`

```python
import kcl_lib.api as api

result = api.API().load_package(api.LoadPackageArgs(
    parse_args=api.ParseProgramArgs(paths=["schema.k"]),
    resolve_ast=True,
))
assert list(result.symbols.values())[0].ty.schema_name == "AppConfig"
```

#### `list_options`

```python
# options.k
a = option("key1")
b = option("key2", required=True)
c = {
    metadata.key = option("metadata-key")
}
```

```python
import kcl_lib.api as api

result = api.API().list_options(api.ParseProgramArgs(paths=["options.k"]))
assert len(result.options) == 3
assert result.options[0].name == "key1"
assert result.options[1].name == "key2"
assert result.options[2].name == "metadata-key"
```

#### `get_schema_type_mapping_under_path` (v0.13.0)

```python
import kcl_lib.api as api

exec_args = api.ExecProgramArgs(
    k_filename_list=["test_data/get_schema_ty_under_path/aaa"],
    external_pkgs=[api.ExternalPkg(
        pkg_name="bbb",
        pkg_path="test_data/get_schema_ty_under_path/bbb",
    )],
)
result = api.API().get_schema_type_mapping_under_path(
    api.GetSchemaTypeMappingArgs(exec_args=exec_args),
)
assert "bbb" in result.schema_type_mapping
bbb_schemas = {s.schema_name: s for s in result.schema_type_mapping["bbb"].schema_type}
assert bbb_schemas["B"].base_schema.schema_name == "Base"
```

See [kcl-lang/kcl#1546](https://github.com/kcl-lang/kcl/issues/1546) for the
rationale.

#### `validate_code`

```python
import kcl_lib.api as api

code = """
schema Person:
    name: str
    age: int

    check:
        0 < age < 120
"""
data = '{"name": "Alice", "age": 10}'
result = api.API().validate_code(api.ValidateCodeArgs(code=code, data=data, format="json"))
assert result.success == True
assert result.err_message == ""
```

#### `rename` / `rename_code`

```python
import kcl_lib.api as api

api_instance = api.API()

# Rewrites files on disk.
api_instance.rename(api.RenameArgs(
    package_root=".", symbol_path="a",
    file_paths=["main.k"], new_name="a2",
))

# Returns modified sources without touching the filesystem.
result = api_instance.rename_code(api.RenameCodeArgs(
    package_root="/mock/path", symbol_path="a",
    source_codes={"/mock/path/main.k": "a = 1"},
    new_name="a2",
))
assert result.changed_codes["/mock/path/main.k"] == "a2 = 1"
```

#### `test`

```python
import kcl_lib.api as api

result = api.API().test(api.TestArgs(pkg_list=["path/to/testing/pkg/..."]))
```

#### `update_dependencies`

```python
# module/kcl.mod
# [package]
# name = "mod_update"
# edition = "0.0.1"
# version = "0.0.1"
#
# [dependencies]
# helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
# flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }

import kcl_lib.api as api

api_instance = api.API()
result = api_instance.update_dependencies(api.UpdateDependenciesArgs(manifest_path="module"))
pkg_names = [pkg.pkg_name for pkg in result.external_pkgs]
assert "helloworld" in pkg_names
assert "flask" in pkg_names

# Feed straight into a follow-up exec_program.
exec_result = api_instance.exec_program(api.ExecProgramArgs(
    k_filename_list=["module/main.k"], external_pkgs=result.external_pkgs,
))
```

#### `get_version` / `list_method`

```python
import kcl_lib.api as api

api_instance = api.API()

v = api_instance.get_version()
assert v.version != "" and v.git_sha != "" and v.checksum != ""

for name in api_instance.list_method().method_name_list:
    print(name)
```

(The exact `version` / `checksum` / `git_sha` values vary per release;
assert only on non-empty.)

## High-level façade (`kcl_lib.kcl`)

The `kcl_lib.kcl` module sits on top of `kcl_lib.api.API` and mirrors
`kcl-go`'s ergonomic surface:

### Top-level entry points

| Function                          | Mirrors                       |
| --------------------------------- | ----------------------------- |
| `run(path, *opts)`                | `kcl.Run`                     |
| `run_files(paths, *opts)`         | `kcl.RunFiles`                |
| `must_run(path, *opts)`           | `kcl.MustRun` (raises on err) |
| `format_code(src)`                | `kcl.FormatCode`              |
| `format_path(path)`               | `kcl.FormatPath`              |
| `override_file(file, specs, ips)` | `kcl.OverrideFile`            |
| `validate_code(data, code)`       | `kcl.ValidateCode`            |
| `validate(data_file, code_file)`  | `kcl.Validate`                |
| `test(args)`                      | `kcl.Test`                    |
| `get_schema_type(file, src, name)`| `kcl.GetSchemaType`           |
| `list_dep_files(path)`            | `kcl.ListDepFiles`            |
| `list_upstream_files(path)`       | `kcl.ListUpstreamFiles`       |
| `list_downstream_files(path)`     | `kcl.ListDownstreamFiles`     |
| `get_version()`                   | `kcl.GetVersion`              |
| `ping(value)`                     | `kcl.Ping`                    |
| `parse_program(src, path="")`      | `kcl.ParseProgram`            |
| `load_package(args)`              | `kcl.LoadPackage`             |
| `list_variables(args)`            | `kcl.ListVariables`           |
| `list_options(args)`              | `kcl.ListOptions`             |
| `update_dependencies(args)`       | `kcl.UpdateDependencies`      |
| `rename(...)` / `rename_code(...)`| `kcl.Rename` / `kcl.RenameCode`|
| `load_settings_files(...)`        | `kcl.LoadSettingsFiles`       |

### Functional options

```python
import kcl_lib.kcl as kcl

results, err = kcl.run(
    "schema.k",
    kcl.with_overrides(["app.replicas=4"]),
    kcl.with_disable_none(True),
    kcl.with_sort_keys(True),
    kcl.with_output_format("json"),
)
```

The `with_*` factories: `with_code`, `with_k_filenames`, `with_overrides`,
`with_selectors`, `with_settings`, `with_work_dir`, `with_external_pkgs`,
`with_disable_none`, `with_sort_keys`, `with_show_hidden`,
`with_include_schema_type_path`, `with_output_format`, `with_logger`,
`with_plugin_agent`.

### `KCLResult` / `KCLResultList`

`kcl.run` returns a `(KCLResultList, Optional[Exception])` tuple. Each
`KCLResult` exposes:

- `.yaml_string()` / `.json_string()` — the raw emitted text
- `.to_dict()` — the parsed mapping
- `.get("a.b.c", target_type=...)` — typed dotted-key lookup
- `result["key"]` / `key in result` — dictionary-style access

## Notes

The legacy `BuildProgram` and `ExecArtifact` RPCs were removed from
`spec/spec.proto` in v0.13.0 (see
[lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac));
they are not exposed by `kcl_lib.api.API`. If you previously called
`api.build_program(...)` or `api.exec_artifact(...)`, switch to
`api.exec_program(...)` — the dispatcher no longer recognises the old
RPC names.

The Python binding buffers protobuf payloads through the same 4 MiB
`BUFFER_SIZE` used by every other binding; very large `yaml_result`
payloads may need a `with_*` option or a follow-up pagination call. See
[`./ffi-abi.md`](./ffi-abi.md) for the buffer-size contract.