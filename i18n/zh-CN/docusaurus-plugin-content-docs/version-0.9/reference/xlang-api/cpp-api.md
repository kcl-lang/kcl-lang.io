---
sidebar_position: 9
---

# C++ API

KCL [C++ API](https://github.com/kcl-lang/lib/tree/main/cpp) 正在开发中，欢迎贡献。

## 前置依赖

- CMake >= 3.10
- C++ Compiler with C++17 Support
- Cargo

## 安装

### CMake

You can use FetchContent to add KCL C++ Lib to your project.

```shell
FetchContent_Declare(
  kcl-lib
  GIT_REPOSITORY https://github.com/kcl-lang/lib.git
  GIT_TAG        v0.9.3
  SOURCE_SUBDIR  cpp
)
FetchContent_MakeAvailable(kcl-lib)
```

Or you can download the source code and add it to your project.

```shell
mkdir third_party
cd third_party
git clone https://github.com/kcl-lang/lib.git
```

Update your CMake files.

```shell
add_subdirectory(third_party/lib/cpp)
```

```shell
target_link_libraries(your_target kcl-lib-cpp)
```

## API 参考

### exec_program

Execute KCL file with arguments and return the JSON/YAML result.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ExecProgramArgs();
    auto files = rust::Vec<rust::String>();
    files.push_back(rust::String("../test_data/schema.k"));
    args.k_filename_list = files;
    auto result = kcl_lib::exec_program(args);
    std::cout << result.yaml_result.c_str() << std::endl;
}
```

</p>
</details>

### parse_file

Parse KCL single file to Module AST JSON string with import dependencies and parse errors.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ParseFileArgs {
        .path = rust::String("../test_data/schema.k"),
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

Parse KCL program with entry files and return the AST JSON string.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ParseProgramArgs {
        .paths = rust::Vec({ rust::String("../test_data/schema.k") }),
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

load_package provides users with the ability to parse KCL program and semantic model information including symbols, types, definitions, etc.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto parse_args = kcl_lib::ParseProgramArgs {
        .paths = rust::Vec({ rust::String("../test_data/schema.k") }),
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

list_variables provides users with the ability to parse KCL program and get all variables by specs.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ListVariablesArgs {
        .files = rust::Vec({ rust::String("../test_data/schema.k") }),
    };
    auto result = kcl_lib::list_variables(args);
    std::cout << result.variables[0].value[0].value.c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### list_options

list_options provides users with the ability to parse KCL program and get all option information.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::ParseProgramArgs {
        .paths = rust::Vec({ rust::String("../test_data/option/main.k") }),
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

Get schema type mapping defined in the program.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto exec_args = kcl_lib::ExecProgramArgs {
        .k_filename_list = rust::Vec({ rust::String("../test_data/schema.k") }),
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

### override_file

Override KCL file with arguments. See [https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation) for more override spec guide.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::OverrideFileArgs {
        .file = rust::String("../test_data/override_file/main.k"),
        .specs = rust::Vec({ rust::String("b.a=2") }),
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

Format the code source.

<details><summary>Example</summary>
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

Format KCL file or directory path contains KCL files and returns the changed file paths.

<details><summary>Example</summary>
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

Lint files and return error messages including errors and warnings.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::LintPathArgs {
        .paths = rust::Vec { rust::String("../test_data/lint_path/test-lint.k") }
    };
    auto result = kcl_lib::lint_path(args);
    std::cout << result.results[0].c_str() << std::endl;
    return 0;
}
```

</p>
</details>

### validate_code

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int validate(const char* code_str, const char* data_str) {
    auto args = kcl_lib::ValidateCodeArgs();
    args.code = rust::String(code_str);
    args.data = rust::String(data_str);
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

Run the ValidateAPI example.

```shell
./validate_api
```

</p>
</details>

### rename

Rename all the occurrences of the target symbol in the files. This API will rewrite files if they contain symbols to be renamed. Return the file paths that got changed.

<details><summary>Example</summary>
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

Rename all the occurrences of the target symbol and return the modified code if any code has been changed. This API won't rewrite files but return the changed code.

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::RenameCodeArgs {
        .package_root = "/mock/path",
        .symbol_path = "a",
        .source_codes = rust::Vec { kcl_lib::HashMapStringValue {
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

Test KCL packages with test arguments.

<details><summary>Example</summary>
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

Load the setting file config defined in `kcl.yaml`

<details><summary>Example</summary>
<p>

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::LoadSettingsFilesArgs {
        .work_dir = rust::String("../test_data/settings"),
        .files = rust::Vec({ rust::String("../test_data/settings/kcl.yaml") }),
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

C++ Code

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::UpdateDependenciesArgs {
        .manifest_path = rust::String("module"),
    };
    auto result = kcl_lib::update_dependencies(args);
    std::cout << result.external_pkgs[0].pkg_name.c_str() << std::endl;
    std::cout << result.external_pkgs[1].pkg_name.c_str() << std::endl;
    return 0;
}
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

```cpp
import helloworld
import flask

a = helloworld.The_first_kcl_program
```

C++ Code

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::UpdateDependenciesArgs {
        .manifest_path = rust::String("module"),
    };
    auto result = kcl_lib::update_dependencies(args);
    auto exec_args = kcl_lib::ExecProgramArgs {
        .k_filename_list = rust::Vec({ rust::String("module/main.k") }),
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

Return the KCL service version information.

<details><summary>Example</summary>
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

</p>
</details>
