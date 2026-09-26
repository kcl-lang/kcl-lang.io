---
sidebar_position: 12
---

# Lua API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)以了解 `call`、Rust 分发器，以及本绑定中 `client:call(name, args)` 如何路由到 `kcl_api::call`。下文中的 `kcl_lib.raw_api` 方法是对该单一 C ABI 的薄 Lua 封装。

官方的 [Lua KCL 包](https://github.com/kcl-lang/lib/tree/main/lua) 基于 [`mlua`](https://github.com/kcl-lang/mlua) 构建，并将整个 `KclService` + `BuiltinService` 表面作为单个 Lua 模块对外暴露。共发布两层：

- `kcl_lib.api` —— 高级外观层。封装 `raw_api:exec_program`，并提供带有 `:object()`、`:yaml()`、`:json()` 访问器的 `RunResponse`。
- `kcl_lib.raw_api` —— 与 `spec/spec.proto` 一一对应的 22 个类型化方法，每个方法接收一个 Lua 表，其字段映射到 protobuf 消息字段。

## 安装

支持以下 Lua 版本：

- 5.4
- 5.3
- 5.2
- 5.1
- LuaJIT

```bash
git clone --depth 1 https://github.com/kcl-lang/lib.git /tmp/lib
cd /tmp/lib/lua
# change Lua version to the version you want to install for
luarocks --lua-version 5.1 --local make
```

## 快速开始

假设有一个 `schema.k` 文件：

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

以及一个 `data.k` 文件：

```kcl
app2: AppConfig {
    replicas: 4
}
```

可以运行：

```lua
local api = require("kcl_lib.api")

-- Execute a single KCL file and print the YAML output
local result = api:run("./schema.k")
print(result:yaml())

-- Execute multiple KCL files and print JSON output
local result = api:run({
    "./schema.k",
    "./data.k"
})
print(result:json())

-- Using the raw API to the native service
local raw_api = require("kcl_lib.raw_api")

-- Perform a call to a native service function
local result = raw_api:exec_program({
    k_filename_list = { "./schema.k" },
})
print(result.yaml_result)
```

## API 参考

### run

执行一个或多个 KCL 文件，并返回一个 `RunResponse`。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:yaml() == "app:\n  replicas: 2")
```

</p>
</details>

### RunResponse

表示对 `run()` 调用结果的对象。

#### RunResponse:object()

将 KCL 响应解析为 Lua 对象后的结果。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:object().app.replicas == 2)
```

</p>
</details>

#### RunResponse:yaml()

以 YAML 字符串形式返回 KCL 响应结果。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:yaml() == "app:\n  replicas: 2")
```

</p>
</details>

#### RunResponse:json()

以 JSON 字符串形式返回 KCL 响应结果。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:json() == '{"app": {"replicas": 2}}')
```

</p>
</details>

## Raw API 参考

### ping

向后端服务发送 ping 请求。

<details><summary>示例</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:ping({ value = "ping" })
assert(result.value == "ping")
```

</p>
</details>

### get_version

获取 KCL 后端服务的版本。

<details><summary>示例</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:get_version({})
assert(result.version ~= "")
assert(result.git_sha ~= "")
assert(result.checksum ~= "")
```

（精确的 `version`、`checksum`、`git_sha` 值因发布版本而异；只需断言非空即可。）

</p>
</details>

### parse_program

使用入口文件解析 KCL 程序。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:parse_program({ paths = { "schema.k" } })
print(result.ast_json)
```

</p>
</details>

### parse_file

将单个 KCL 文件解析为包含 import 依赖与解析错误的 Module AST JSON 字符串。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:parse_file({ path = "schema.k" })
print(result.ast_json)
```

</p>
</details>

### load_package

`load_package` 为用户提供解析 KCL 程序及其语义模型信息（包括符号、类型、定义等）的能力。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:load_package({ parse_args = { paths = { "schema.k" } }, resolve_ast = true })
for _, symbol in pairs(result.symbols) do
    print(symbol.name)
end
```

</p>
</details>

### list_options

`list_options` 为用户提供解析 KCL 程序并获取所有选项信息的能力。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:list_options({ paths = { "schema.k" } })
for _, option in ipairs(result.options) do
    print(option.name)
end
```

</p>
</details>

### list_variables

`list_variables` 为用户提供解析 KCL 程序并按 spec 获取所有变量的能力。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:list_variables({ files = { "schema.k" } })
for name, _vars in ipairs(result.variables) do
    print(name)
end
```

</p>
</details>

### exec_program

使用参数执行 KCL 文件，并返回 JSON/YAML 结果。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:exec_program({ k_filename_list = { "schema.k" } })
assert(result.yaml_result == "app:\n  replicas: 2")
```

</p>
</details>

### format_code

格式化源代码。

<details><summary>示例</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local code = "schema AppConfig:\n  replicas:int"
local result = api:format_code({ source = code })
assert(result.formatted == "schema AppConfig:\n    replicas: int\n")
```

</p>
</details>

### format_path

格式化 KCL 文件或包含 KCL 文件的目录路径，并返回被修改的文件路径。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
  replicas:int

app:AppConfig {
  replicas: 2}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:format_path({ path = "schema.k" })
assert(result.changed_path[1] == "schema.k")
```

运行程序后，`schema.k` 会被格式化为：

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

</p>
</details>

### lint_path

检查文件，并返回包含错误与警告的错误信息。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
import a
import a

schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:lint_path({ paths = { "schema.k" } })
for _, res in ipairs(result.results) do
    print(res)
end
```

这将打印：

```
Module 'a' is reimported multiple times
Module 'a' imported but unused
Module 'a' imported but unused
```

</p>
</details>

### override_file

使用参数覆盖 KCL 文件。

<details><summary>示例</summary>
<p>

`file.k` 的内容为

```kcl
app = {
    replicas = 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:override_file({ file = "file.k", specs = { "app.replicas=42" } })
assert(result.result)
```

修改后的文件将变为：

```kcl
app = {replicas = 42}
```

</p>
</details>

### get_schema_type_mapping

获取 schema 类型映射。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:get_schema_type_mapping({
    exec_args = { k_filename_list = { "schema.k" } },
    schema_name = "AppConfig",
})
assert(result.schema_type_mapping.AppConfig.properties.replicas.type == "int")
```

</p>
</details>

### validate_code

使用 schema 和 data 字符串验证代码。

<details><summary>示例</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:validate_code({
    code = "schema AppConfig:\n    replicas: int\n    check:\n      0 < replicas < 100",
    data = "replicas: 42",
    format = "yaml",
})
assert(result.success)
```

</p>
</details>

### rename

重命名文件中所有出现的目标符号。若文件中包含待重命名的符号，该 API 会重写文件。返回被修改的文件路径列表。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:rename({
  package_root = ".",
  file_paths = { "schema.k" },
  symbol_path = "app",
  new_name = "other",
})
assert(#result.changed_files == 1)
```

执行后 `schema.k` 的内容将变为：

```kcl
schema AppConfig:
    replicas: int

other: AppConfig {
    replicas: 2
}
```

</p>
</details>

### test

使用测试参数测试 KCL 包。

<details><summary>示例</summary>
<p>

`test/schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int = 42

app: AppConfig {
    replicas: 2
}
```

此外，`test/schema_test.k` 的内容为

```kcl
test_app = lambda {
    app = AppConfig
    assert app.replicas == 42
}
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:test({
  exec_args = {
    work_dir = "test",
    k_filename_list = { "./schema.k" },
  },
  pkg_list = { "test/..." },
})
assert(result.info[1].name == "test_app")
```

</p>
</details>

### update_dependencies

下载并更新 `kcl.mod` 文件中定义的依赖。

<details><summary>示例</summary>
<p>

`kcl.mod` 的内容为

```toml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:update_dependencies({ manifest_path = "." })
print(result.external_pkgs[1].pkg_name == "helloworld")
```

</p>
</details>

### list_method

列出底层运行时所支持的 KCL 服务方法名称。

<details><summary>示例</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:list_method({})
for _, name in ipairs(result.method_name_list) do
    print(name)
end
```

</p>
</details>

### get_schema_type_mapping_under_path

与 `get_schema_type_mapping` 类似，但返回的 schema 类型映射以包名为键，以便从外部依赖包导入的 schema 保留各自的 pkgpath 与 base schema。参见 [kcl-lang/kcl#1546](https://github.com/kcl-lang/kcl/issues/1546)。

<details><summary>示例</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:get_schema_type_mapping_under_path({
    exec_args = { k_filename_list = { "." } },
})
for pkg, schemas in pairs(result.schema_type_mapping) do
    for _, s in ipairs(schemas.schema_type) do
        print(pkg, s.schema_name)
    end
end
```

</p>
</details>

### load_settings_files

从 `kcl.yaml`（或其别名文件）加载配置。

<details><summary>示例</summary>
<p>

`kcl.yaml` 的内容为

```yaml
kcl_cli_configs:
  strict_range_check: true
kcl_options:
  - key: key
    value: value
```

Lua 代码

```lua
local api = require("kcl_lib.raw_api")

local result = api:load_settings_files({
    work_dir = ".",
    files = { "kcl.yaml" },
})
assert(result.kcl_cli_configs.strict_range_check == true)
```

</p>
</details>

### rename_code

重命名所有目标符号出现的位置，并返回修改后的代码，且不会触碰文件系统。与 `rename` 不同，本方法不会重写任何文件。

<details><summary>示例</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:rename_code({
    package_root = "/mock/path",
    symbol_path = "a",
    source_codes = { ["/mock/path/main.k"] = "a = 1" },
    new_name = "a2",
})
assert(result.changed_codes["/mock/path/main.k"] == "a2 = 1")
```

</p>
</details>

## 注意事项

旧版的 `BuildProgram` 与 `ExecArtifact` RPC 已在 v0.13.0 中从 `spec/spec.proto` 中移除（参见 [lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；它们不再由 `kcl_lib.raw_api` 暴露。如果此前调用过 `api:build_program(...)` 或 `api:exec_artifact(...)`，请改用 `api:exec_program(...)`，并配合在宿主侧进行文件写入 —— 分发器已不再识别旧的 RPC 名称。
