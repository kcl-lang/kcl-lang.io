---
sidebar_position: 4
---

# Python API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，了解 `call`、`"ERROR:"` 前缀、**4 MiB** 的 `BUFFER_SIZE`，以及 `_kcl_lib.so` 扩展是如何路由到 `kcl_api::call` 的。下文的 `kcl_lib.api.API` 类是对该单一 C ABI 的轻薄 Python 封装。

官方的 [Python KCL 包](https://github.com/kcl-lang/lib/tree/main/python)基于 [PyO3](https://pyo3.rs) 构建，将整个 `KclService` + `BuiltinService` 的接口面暴露为两层 Python：

- **`kcl_lib.api`** — 底层的 protobuf 封装。每个方法都接收一个有类型的 `*Args` 原型（从 `spec/spec.proto` 自动生成），并返回对应的 `*Result`。这是规范的接口面，当您希望输入和输出都是有类型的消息时，应当使用这一层。
- **`kcl_lib.kcl`** — 高级外观层，对应 [`kcl-go`](https://github.com/kcl-lang/kcl-go) SDK。提供 `run(path, *opts)` / `must_run` / `run_files`、一个函数式的 `Option` 链（`with_overrides`、`with_disable_none` 等），以及一个支持点号键 `get`/`to_dict` 访问的 `KCLResult` 辅助对象。

## 安装

```shell
python3 -m pip install kcl-lib
```

唯一声明的依赖是 `protobuf`。从源码构建需要可用的 Rust 工具链；PyPI wheel 包中已捆绑预构建的 `_kcl_lib.cpython-*.so` 扩展。

## 快速开始

假设有一个 `schema.k` 文件：

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

您可以运行：

```python
import kcl_lib.api as api

args = api.ExecProgramArgs(k_filename_list=["schema.k"])
api_instance = api.API()
result = api_instance.exec_program(args)
print(result.yaml_result)
```

或者使用高级外观层：

```python
import kcl_lib.kcl as kcl

results, err = kcl.run("schema.k")
if err is not None:
    raise err
print(results.first().yaml_string())
assert results.first().get("app.replicas") == 2
```

## 底层 API（`kcl_lib.api`）

### API

每个 RPC 的唯一入口点。每个线程实例化一次：

```python
import kcl_lib.api as api

api_instance = api.API()
```

默认情况下，它与由 `kcl_lib.plugin.plugin_agent_addr` 安装的进程内插件代理指针通信。传入 `plugin_agent=<addr>` 可使用不同的代理指针。

#### `API.call(name, args)`

通用调度器。将编码后的 `args` 原型发送到 `<name>`（例如 `"KclService.ExecProgram"`），并返回解码后的响应消息。

```python
import kcl_lib.api as api

api_instance = api.API()
result = api_instance.call("KclService.Ping", api.PingArgs(value="hi"))
assert result.value == "hi"
```

如果调度器以 `"ERROR:..."` 前缀进行回复，`call` 将抛出 `Exception(...)`；请参阅 [`./ffi-abi.md`](./ffi-abi.md) §4。

#### 类型化方法

每个方法与 `spec/spec.proto` 中的某个 RPC 一一对应。`kcl_lib.api.service.API` 中提供的完整方法列表如下：

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

### 示例

`kcl_lib/api/service.py` 的完整源码是规范的参考（每个方法的 docstring 中都包含可运行的示例）。一些要点：

#### `exec_program`

```python
import kcl_lib.api as api

args = api.ExecProgramArgs(k_filename_list=["schema.k"])
result = api.API().exec_program(args)
assert result.yaml_result == "app:\n  replicas: 2"
```

一个文件未找到错误的示例：

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

#### `get_schema_type_mapping_under_path`（v0.13.0）

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

其设计缘由请参阅 [kcl-lang/kcl#1546](https://github.com/kcl-lang/kcl/issues/1546)。

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

（具体的 `version` / `checksum` / `git_sha` 值随发布版本不同而变化；只需断言它们非空即可。）

## 高级外观层（`kcl_lib.kcl`）

`kcl_lib.kcl` 模块构建于 `kcl_lib.api.API` 之上，复刻了 `kcl-go` 的便捷接口面：

### 顶层入口点

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

### 函数式选项

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

`with_*` 工厂函数包括：`with_code`、`with_k_filenames`、`with_overrides`、`with_selectors`、`with_settings`、`with_work_dir`、`with_external_pkgs`、`with_disable_none`、`with_sort_keys`、`with_show_hidden`、`with_include_schema_type_path`、`with_output_format`、`with_logger`、`with_plugin_agent`。

### `KCLResult` / `KCLResultList`

`kcl.run` 返回一个 `(KCLResultList, Optional[Exception])` 元组。每个 `KCLResult` 提供以下接口：

- `.yaml_string()` / `.json_string()` — 原始的输出文本
- `.to_dict()` — 解析后的映射
- `.get("a.b.c", target_type=...)` — 类型化的点号键查找
- `result["key"]` / `key in result` — 字典式访问

## 备注

旧的 `BuildProgram` 和 `ExecArtifact` RPC 已于 v0.13.0 从 `spec/spec.proto` 中移除（请参阅 [lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；它们并未通过 `kcl_lib.api.API` 暴露。如果您之前调用过 `api.build_program(...)` 或 `api.exec_artifact(...)`，请改为调用 `api.exec_program(...)` — 调度器已无法识别旧的 RPC 名称。

Python 绑定通过与其他绑定相同的 4 MiB `BUFFER_SIZE` 来缓存 protobuf 负载；非常大的 `yaml_result` 负载可能需要使用 `with_*` 选项或后续的分页调用。有关缓冲区大小契约，请参阅 [`./ffi-abi.md`](./ffi-abi.md)。