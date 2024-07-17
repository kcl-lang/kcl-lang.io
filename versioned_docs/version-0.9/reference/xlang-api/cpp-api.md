---
sidebar_position: 9
---

# C++ API

The [C++ API](https://github.com/kcl-lang/lib/tree/main/cpp) is in the development stage and contributions are welcome.

## Prerequisites

+ CMake >= 3.10
+ C++ Compiler with C++17 Support
+ Cargo

## Installation

### CMake

You can use FetchContent to add KCL C++ Lib to your project.

```shell
FetchContent_Declare(
  kcl-lib
  GIT_REPOSITORY https://github.com/kcl-lang/lib.git
  GIT_TAG        v0.9.1
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

## API Reference

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
    // Right case
    validate(code_str, data_str);
    // Error case
    validate(code_str, error_data_str);
    return 0;
}
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

C++ Code

```cpp
#include "kcl_lib.hpp"
#include <iostream>

int main()
{
    auto args = kcl_lib::OverrideFileArgs {
        .file = rust::String("main.k"),
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
        .manifest_path = rust::String("../test_data/update_dependencies"),
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

```python
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
        .manifest_path = rust::String("../test_data/update_dependencies"),
    };
    auto result = kcl_lib::update_dependencies(args);
    auto exec_args = kcl_lib::ExecProgramArgs {
        .k_filename_list = rust::Vec({ rust::String("../test_data/update_dependencies/main.k") }),
        .external_pkgs = result.external_pkgs,
    };
    auto exec_result = kcl_lib::exec_program(exec_args);
    std::cout << exec_result.yaml_result.c_str() << std::endl;
    return 0;
}
```

</p>
</details>
