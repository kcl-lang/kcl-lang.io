---
sidebar_position: 12
---

# Lua API

## Installation

The official [Lua KCL package](https://github.com/kcl-lang/lib/tree/main/lua) has not been released
yet. You can install it locally directly from GitHub.

The following Lua versions are supported:

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

## Quick Start

With a `schema.k` file:

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

and a `data.k` file:

```kcl
app2: AppConfig {
    replicas: 4
}
```

You can run:

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

## API Reference

### run

Execute one or several KCL files and return a `RunResponse`.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:yaml() == "app:\n  replicas: 2")
```

</p>
</details>

### RunResponse

An object representing the response from a call to `run()`.

#### RunResponse:object()

The resulting KCL response parsed as a Lua object.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:object().app.replicas == 2)
```

</p>
</details>

#### RunResponse:yaml()

The resulting KCL response as a YAML string.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:yaml() == "app:\n  replicas: 2")
```

</p>
</details>

#### RunResponse:json()

The resulting KCL response as a JSON string.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.api")

local result = api:run("./schema.k")
assert(result:json() == '{"app": {"replicas": 2}}')
```

</p>
</details>

## Raw API Reference

### ping

Send a ping request to the backing service.

<details><summary>Example</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:ping({ value = "ping" })
assert(result.value == "ping")
```

</p>
</details>

### get_version

Get the version of the KCL backing service.

<details><summary>Example</summary>
<p>

```lua
local api = require("kcl_lib.raw_api")

local result = api:get_version({})
assert(result.version == "0.12.4")
assert(result.checksum == "c020ab3eb4b9179219d6837a57f5d323")
```

</p>
</details>

### parse_program

Parse KCL program with entry files.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.raw_api")

local result = api:parse_program({ paths = { "schema.k" } })
print(result.ast_json)
```

</p>
</details>

### parse_file

Parse KCL single file to Module AST JSON string with import dependencies and parse errors.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.raw_api")

local result = api:parse_file({ path = "schema.k" })
print(result.ast_json)
```

</p>
</details>

### load_package

`load_package` provides users with the ability to parse KCL program and semantic model information
including symbols, types, definitions, etc.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

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

`list_options` provides users with the ability to parse KCL program and get all option information.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

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

`list_variables` provides users with the ability to parse kcl program and get all variables by
specs.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

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

Execute KCL file with arguments and return the JSON/YAML result.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.raw_api")

local result = api:exec_program({ k_filename_list = { "schema.k" } })
assert(result.yaml_result == "app:\n  replicas: 2")
```

</p>
</details>

### format_code

Format source code.

<details><summary>Example</summary>
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

Format KCL file or directory path contains KCL files and returns the changed file paths.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
  replicas:int

app:AppConfig {
  replicas: 2}
```

Lua code

```lua
local api = require("kcl_lib.raw_api")

local result = api:format_path({ path = "schema.k" })
assert(result.changed_path[1] == "schema.k")
```

After running the program, `schema.k` will be formatted:

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

Lint files and return error messages including errors and warnings.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
import a
import a

schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

```lua
local api = require("kcl_lib.raw_api")

local result = api:lint_path({ paths = { "schema.k" } })
for _, res in ipairs(result.results) do
    print(res)
end
```

This will print:

```
Module 'a' is reimported multiple times
Module 'a' imported but unused
Module 'a' imported but unused
```

</p>
</details>

### override_file

Override KCL file with args.

<details><summary>Example</summary>
<p>

The content of `file.k` is

```kcl
app = {
    replicas = 2
}
```

Lua code

```lua
local api = require("kcl_lib.raw_api")

local result = api:override_file({ file = "file.k", specs = { "app.replicas=42" } })
assert(result.result)
```

The modified file will then be:

```kcl
app = {replicas = 42}
```

</p>
</details>

### get_schema_type_mapping

Get schema type mapping.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

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

Validate code using schema and data strings.

<details><summary>Example</summary>
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

Rename all the occurrences of the target symbol in the files. This API will rewrite files if they
contain symbols to be renamed. Return the file paths that got changed.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

Lua code

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

This will result in the following content for `schema.k`:

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

Test KCL packages with test arguments.

<details><summary>Example</summary>
<p>

The content of `test/schema.k` is

```kcl
schema AppConfig:
    replicas: int = 42

app: AppConfig {
    replicas: 2
}
```

Moreover, the content of `test/schema_test.k` is

```kcl
test_app = lambda {
    app = AppConfig
    assert app.replicas == 42
}
```

Lua code

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

Download and update dependencies defined in the kcl.mod file.

<details><summary>Example</summary>
<p>

The content of `kcl.mod` is

```toml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

Lua code

```lua
local api = require("kcl_lib.raw_api")

local result = api:update_dependencies({ manifest_path = "." })
print(result.external_pkgs[1].pkg_name == "helloworld")
```

</p>
</details>
