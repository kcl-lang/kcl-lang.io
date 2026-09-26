---
sidebar_position: 11
---

# C++ API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，其中包含 `call`、`"ERROR:"` 前缀、
> **4 MiB** 结果缓冲区，以及 `cxx::bridge` 命名空间 `kcl_lib`。
> `kcl_lib.hpp` 中的每个类型化辅助函数都是由 [`cxx`](https://cxx.rs/)
> 基于该单一调度器（dispatcher）生成的轻量 C++ 包装。

[C++ API](https://github.com/kcl-lang/lib/tree/main/cpp) 通过
[`cxx`](https://cxx.rs/) bridge 构建于 `kcl_api::call` 之上，并在
`kcl_lib::` 命名空间中暴露完整的 `KclService` + `BuiltinService` 接口。
所有 `*Args` / `*Result` 类型均由 `spec/spec.proto` 生成，每个类型化包装
函数都会返回 `Result<T>`，并将调度器返回的 `"ERROR:..."` 回复映射为
`kcl_lib::KclError`。

## 环境要求

- CMake >= 3.10
- 支持 C++17 的 C++ 编译器
- Cargo

## 安装

### CMake

你可以使用 FetchContent 将 KCL C++ Lib 添加到你的项目中。

```shell
FetchContent_Declare(
  kcl-lib
  GIT_REPOSITORY https://github.com/kcl-lang/lib.git
  GIT_TAG        v0.13.0 # You can change the GitHub branch tag.
  SOURCE_SUBDIR  cpp
)
FetchContent_MakeAvailable(kcl-lib)
```

或者你可以下载源码并将其添加到你的项目中。

```shell
mkdir third_party
cd third_party
git clone https://github.com/kcl-lang/lib.git
```

更新你的 CMake 文件。

```shell
add_subdirectory(third_party/lib/cpp)
```

```shell
target_link_libraries(your_target kcl-lib-cpp)
```

## API 参考

### exec_program

执行 KCL 文件并传入参数，返回 JSON/YAML 结果。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ExecProgramArgs {
        .k_filename_list = { "../test_data/schema.k" },
    };
    auto result = kcl_lib::exec_program(args);
    std::cout << result.yaml_result.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### parse_file

将单个 KCL 文件解析为 Module AST JSON 字符串，并返回导入依赖与解析错误信息。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ParseFileArgs {
        .path = "../test_data/schema.k",
    };
    auto result = kcl_lib::parse_file(args);
    std::cout << result.deps.size() << std::endl;
    std::cout << result.errors.size() << std::endl;
    std::cout << result.ast_json.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### parse_program

通过入口文件解析 KCL 程序，并返回 AST JSON 字符串。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ParseProgramArgs {
        .paths = { "../test_data/schema.k" },
    };
    auto result = kcl_lib::parse_program(args);
    std::cout << result.paths[0].c_str() << std::endl;
    std::cout << result.errors.size() << std::endl;
    std::cout << result.ast_json.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### load_package

`load_package` 为用户提供解析 KCL 程序以及符号、类型、定义等语义模型信息的能力。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto parse_args = kcl_lib::ParseProgramArgs {
        .paths = { "../test_data/schema.k" },
    };
    auto args = kcl_lib::LoadPackageArgs {
        .resolve_ast = true,
    };
    args.parse_args = kcl_lib::OptionalParseProgramArgs {
        .has_value = true,
        .value = parse_args,
    };
    auto result = kcl_lib::load_package(args);
    std::cout << result.symbols[0].value.ty.value.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### list_variables

`list_variables` 为用户提供解析 KCL 程序并按规格获取所有变量的能力。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ListVariablesArgs {
        .files = { "../test_data/schema.k" },
    };
    auto result = kcl_lib::list_variables(args);
    std::cout << result.variables[0].value[0].value.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### list_options

`list_options` 为用户提供解析 KCL 程序并获取所有 option 信息的能力。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ParseProgramArgs {
        .paths = { "../test_data/option/main.k" },
    };
    auto result = kcl_lib::list_options(args);
    std::cout << result.options[0].name.c_str() << std::endl;
    std::cout << result.options[1].name.c_str() << std::endl;
    std::cout << result.options[2].name.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### get_schema_type_mapping

获取程序中定义的 schema 类型映射。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto exec_args = kcl_lib::ExecProgramArgs {
        .k_filename_list = { "../test_data/schema.k" },
    };
    auto args = kcl_lib::GetSchemaTypeMappingArgs();
    args.exec_args = kcl_lib::OptionalExecProgramArgs {
        .has_value = true,
        .value = exec_args,
    };
    auto result = kcl_lib::get_schema_type_mapping(args);
    std::cout << result.schema_type_mapping[0].key.c_str() << std::endl;
    std::cout << result.schema_type_mapping[0].value.properties[0].key.c_str() << std::endl;
    std::cout << result.schema_type_mapping[0].value.properties[0].value.ty.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### get_schema_type_mapping_under_path

获取程序及其依赖包中定义的 schema 类型映射，并以包名作为键。
与 `get_schema_type_mapping` 不同，从外部依赖包导入的 schema 会以其所属包名
作为键，而不是被合并到 `__main__` 下。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <filesystem>
#include <iostream>

int main()
{
    auto root = std::filesystem::canonical(std::filesystem::current_path() / "test_data" / "get_schema_ty_under_path");
    auto exec_args = kcl_lib::ExecProgramArgs{
        .k_filename_list = {(root / "aaa").string()},
        .external_pkgs = {kcl_lib::ExternalPkg{
            .pkg_name = "bbb",
            .pkg_path = (root / "bbb").string(),
        }},
    };
    auto args = kcl_lib::GetSchemaTypeMappingArgs{
        .exec_args = kcl_lib::OptionalExecProgramArgs{
            .has_value = true,
            .value = exec_args,
        },
        .schema_name = "",
    };
    auto result = kcl_lib::get_schema_type_mapping_under_path(args);
    for (auto &entry : result.schema_type_mapping)
    {
        std::cout << "package: " << entry.key.c_str() << std::endl;
    }
    return 0;
}
```

</p>
</details>

### override_file

使用参数覆盖 KCL 文件。更多覆盖规范说明，请参阅
[https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation)。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::OverrideFileArgs {
        .file = { "../test_data/override_file/main.k" },
        .specs = { "b.a=2" },
    };
    auto result = kcl_lib::override_file(args);
    std::cout << result.result << std::endl;
    std::cout << result.parse_errors.size() << std::endl;
    return 0;
}
```

</p>
</details>

### format_code

格式化代码源文件。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::FormatCodeArgs {
        .source = "schema Person:\n"
                  "    name:     str\n"
                  "    age:     int\n"
                  "    check:\n"
                  "        0 <     age <     120\n",
    };
    auto result = kcl_lib::format_code(args);
    std::cout << result.formatted.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### format_path

格式化 KCL 文件或包含 KCL 文件的目录路径，并返回发生变更的文件路径。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::FormatPathArgs {
        .path = "../test_data/format_path/test.k",
    };
    auto result = kcl_lib::format_path(args);
    std::cout << result.changed_paths.size() << std::endl;
    return 0;
}
```

</p>
</details>

### lint_path

对文件执行 lint 检查，并返回包含错误和警告在内的错误信息。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::LintPathArgs {
        .paths = { "../test_data/lint_path/test-lint.k" }
    };
    auto result = kcl_lib::lint_path(args);
    std::cout << result.results[0].c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### validate_code

使用 schema 以及 JSON/YAML 数据字符串对代码进行校验。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int validate(const char* code_str, const char* data_str)
{
    auto args = kcl_lib::ValidateCodeArgs {
        .code = code_str,
        .data = data_str,
    };
    auto result = kcl_lib::validate_code(args);
    std::cout << result.success << std::endl;
    std::cout << result.err_message.c_str() << std::endl;
    return 0;
}

int main()
{
    const char* code_str = "schema Person:\n"
                           "    name: str\n"
                           "    age: int\n"
                           "    check:\n"
                           "        0 < age < 120\n";
    const char* data_str = "{\"name\": \"Alice\", \"age\": 10}";
    const char* error_data_str = "{\"name\": \"Alice\", \"age\": 1110}";
    validate(code_str, data_str);
    validate(code_str, error_data_str);
    return 0;
}
```

运行 ValidateAPI 示例。

```shell
./validate_api
```

</p>
</details>

### rename

重命名文件中目标符号的所有出现位置。如果文件中包含需要重命名的符号，
该 API 将重写这些文件，并返回发生变化的文件路径。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::RenameArgs {
        .package_root = "../test_data/rename",
        .symbol_path = "a",
        .file_paths = { "../test_data/rename/main.k" },
        .new_name = "a",
    };
    auto result = kcl_lib::rename(args);
    std::cout << result.changed_files[0].c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### rename_code

重命名目标符号的所有出现位置，并在代码发生变化时返回修改后的代码。
该 API 不会重写文件，而是返回修改后的代码。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::RenameCodeArgs {
        .package_root = "/mock/path",
        .symbol_path = "a",
        .source_codes = { {
            .key = "/mock/path/main.k",
            .value = "a = 1\nb = a\nc = a",
        } },
        .new_name = "a2",
    };
    auto result = kcl_lib::rename_code(args);
    std::cout << result.changed_codes[0].value.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### test

使用测试参数对 KCL 包运行测试。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::TestArgs {
        .pkg_list = { "../test_data/testing/..." },
    };
    auto result = kcl_lib::test(args);
    std::cout << result.info[0].name.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### load_settings_files

加载 `kcl.yaml` 中定义的配置文件配置。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::LoadSettingsFilesArgs {
        .work_dir = "../test_data/settings",
        .files = { "../test_data/settings/kcl.yaml" },
    };
    auto result = kcl_lib::load_settings_files(args);
    std::cout << result.kcl_cli_configs.value.files.size() << std::endl;
    std::cout << result.kcl_cli_configs.value.strict_range_check << std::endl;
    std::cout << result.kcl_options[0].key.c_str() << std::endl;
    std::cout << result.kcl_options[0].value.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### update_dependencies

下载并更新 `kcl.mod` 文件中定义的依赖，并返回外部包名及其位置列表。

<details><summary>示例</summary>
<p>

`module/kcl.mod` 文件内容如下：

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

C++ 代码：

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::UpdateDependenciesArgs {
        .manifest_path = "../test_data/update_dependencies",
    };
    auto result = kcl_lib::update_dependencies(args);
    std::cout << result.external_pkgs[0].pkg_name.c_str() << std::endl;
    std::cout << result.external_pkgs[1].pkg_name.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

使用外部依赖调用 `exec_program`

<details><summary>示例</summary>
<p>

`module/kcl.mod` 文件内容如下：

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

`module/main.k` 文件内容如下：

```cpp
import helloworld
import flask

a = helloworld.The_first_kcl_program
```

C++ 代码：

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::UpdateDependenciesArgs {
        .manifest_path = "../test_data/update_dependencies",
    };
    auto result = kcl_lib::update_dependencies(args);
    auto exec_args = kcl_lib::ExecProgramArgs {
        .k_filename_list = { "../test_data/update_dependencies/main.k" },
        .external_pkgs = result.external_pkgs,
    };
    auto exec_result = kcl_lib::exec_program(exec_args);
    std::cout << exec_result.yaml_result.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### get_version

返回 KCL 服务的版本信息。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto result = kcl_lib::get_version();
    std::cout << result.checksum.c_str() << std::endl;
    std::cout << result.git_sha.c_str() << std::endl;
    std::cout << result.version.c_str() << std::endl;
    std::cout << result.version_info.c_str() << std::endl;
    return 0;
}
```

（具体的 `version` / `checksum` / `git_sha` 值随发布版本而变化；
请仅断言其非空。）

</p>
</details>

### ping

通过调度器往返回送一个值。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::PingArgs { .value = "hello" };
    auto result = kcl_lib::ping(args);
    std::cout << result.value.c_str() << std::endl;  // -> "hello"
    return 0;
}
```

</p>
</details>

### list_method

列出底层运行时所支持的 KCL 服务方法名称。

<details><summary>示例</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto result = kcl_lib::list_method();
    for (const auto& name : result.method_name_list) {
        std::cout << name.c_str() << std::endl;
    }
    return 0;
}
```

</p>
</details>

## 注意事项

旧的 `BuildProgram` 与 `ExecArtifact` RPC 已在 v0.13.0 中从
`spec/spec.proto` 中移除（请参阅
[lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；
`kcl_lib::` 调度器不再识别它们。如果你之前调用过
`kcl_lib::build_program(...)` 或 `kcl_lib::exec_artifact(...)`，
请切换至 `kcl_lib::exec_program(...)`。