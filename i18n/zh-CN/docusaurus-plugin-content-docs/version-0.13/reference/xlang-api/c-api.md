---
sidebar_position: 10
---

# C API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，了解 `call_native`、`"ERROR:"` 前缀、**4 MiB** 的 `BUFFER_SIZE` 以及 `kcl_ffi.h` 导出列表。
> 头文件 `kcl_lib.h` 是对该单一 ABI 的轻量级 C 包装；每个类型化辅助函数都通过 `kcl_call("KclService.<Name>", …)` 进行调用。

[C 绑定](https://github.com/kcl-lang/lib/tree/main/c) 以单头文件 `kcl_lib.h`（static-inline 实现）、由 nanopb 生成的 `spec.pb.{h,c}` 以及 `kcl_ffi.h` Rust 调度器导出文件的形式提供。它链接到通过 `cbindgen` 从 `crates/api` 构建的预编译共享库 `libkcl_lib_c.<so|dylib|lib>`。

## 前置条件

- `make`
- C11 编译器（`gcc` / `clang` / MSVC）
- `cargo`（Rust 工具链），用于构建 cdylib
- `cbindgen`（仅在重新生成头文件时需要）

## 构建

```bash
git clone --depth 1 https://github.com/kcl-lang/lib.git /tmp/lib
cd /tmp/lib/c
make             # builds the Rust cdylib and runs the C examples
```

cdylib 导出（`call_native`）由 `cbindgen` 生成；请参阅 `include/kcl_ffi.h` 顶部的权威来源。

## 缓冲区大小

```c
#define BUFFER_SIZE (4 * 1024 * 1024)   // 4 MiB
```

每个类型化辅助函数分配三个 4 MiB 的缓冲区（`buffer`、`result_buffer`，以及每次调用的临时缓冲区）。大于 4 MiB 的负载必须使用具有更大 `result_buffer` 的底层模式。请参阅 [`./ffi-abi.md`](./ffi-abi.md) 了解缓冲区大小契约。

## 快速开始

```c
#include <kcl_lib.h>
#include <stdio.h>

int main(void) {
    char yaml_out[BUFFER_SIZE] = {0};
    char err_out[BUFFER_SIZE] = {0};
    const char* files[] = {"./schema.k"};
    if (!kcl_exec_program(files, 1, yaml_out, sizeof(yaml_out),
                          err_out, sizeof(err_out))) {
        fprintf(stderr, "%s\n", err_out);
        return 1;
    }
    printf("%s\n", yaml_out);
    return 0;
}
```

编译：

```bash
cc -I include -L target/release -l kcl_lib_c -o hello hello.c
LD_LIBRARY_PATH=target/release ./hello
```

## API 参考

该头文件提供了 **8 个类型化包装函数**（`kcl_*`），以及底层 **`kcl_call`** 调度器和 nanopb 编/解码辅助函数。每个类型化包装函数都是一个 `static inline`，通过 nanopb 对其参数进行编码，调用 `kcl_call("KclService.<Name>", …)`，检查 `"ERROR:"` 前缀，然后解码响应。

| 辅助函数                                  | RPC                              | 响应                                       |
| --------------------------------------- | -------------------------------- | ----------------------------------------- |
| `kcl_ping(value, out, out_size)`        | `KclService.Ping`                | `out = PingResult.value`                  |
| `kcl_get_version(version)`              | `KclService.GetVersion`          | `struct KclVersion`                       |
| `kcl_exec_program(files, n, yaml, …, err, …)` | `KclService.ExecProgram`    | `yaml = yaml_result`，`err = err_message` |
| `kcl_validate_code(code, data, ok, err, …)`   | `KclService.ValidateCode`   | `*ok = success`，`err = err_message`      |
| `kcl_format_code(source, out, out_size)`| `KclService.FormatCode`          | `out = formatted`                         |
| `kcl_lint_path(paths, n, out, out_size)`| `KclService.LintPath`            | `out` 是以换行符分隔的结果                 |
| `kcl_parse_file(filename, ast, ast_size)`     | `KclService.ParseFile`     | `ast = ast_json`                          |
| `kcl_parse_program(files, n, ast, ast_size)` | `KclService.ParseProgram` | `ast = ast_json`（envelope）              |

每个辅助函数在失败时返回 `false`，并将错误消息拷贝到相应的 `out` / `err` 缓冲区中。

### `kcl_ping`

```c
#include <kcl_lib.h>
#include <stdio.h>

char out[BUFFER_SIZE];
if (kcl_ping("hello", out, sizeof(out))) {
    printf("%s\n", out);   // -> "hello"
}
```

### `kcl_get_version`

```c
#include <kcl_lib.h>

struct KclVersion v;
if (kcl_get_version(&v)) {
    printf("version=%s checksum=%s git_sha=%s\n", v.version, v.checksum, v.git_sha);
}
```

具体的 `version` / `checksum` / `git_sha` 值因发布版本而异；仅断言非空即可。`KclVersion` 结构体还包含一个用于人类可读摘要的 `version_info[1024]` 字段。

### `kcl_exec_program`

```c
#include <kcl_lib.h>

char yaml[BUFFER_SIZE] = {0};
char err[BUFFER_SIZE] = {0};
const char* files[] = {"./schema.k"};
if (!kcl_exec_program(files, 1, yaml, sizeof(yaml), err, sizeof(err))) {
    fprintf(stderr, "%s\n", err);
}
```

内部实现：对 `ExecProgramArgs{k_filename_list: […]}` 进行编码，发送到 `"KclService.ExecProgram"`，解码 `ExecProgramResult`，并将 `yaml_result` / `err_message` 写入所提供的缓冲区。

### `kcl_validate_code`

```c
#include <kcl_lib.h>

bool ok = false;
char err[BUFFER_SIZE] = {0};
if (kcl_validate_code(
        "schema Person:\n    age: int\n    check:\n        0 < age < 120\n",
        "{\"age\": 10}", &ok, err, sizeof(err))) {
    printf("ok=%d err=%s\n", ok, err);
}
```

### `kcl_format_code`

```c
#include <kcl_lib.h>

char out[BUFFER_SIZE];
if (kcl_format_code("schema A:\n  x:int\n", out, sizeof(out))) {
    printf("%s\n", out);
}
```

### `kcl_lint_path`

```c
#include <kcl_lib.h>

char out[BUFFER_SIZE];
const char* paths[] = {"./schema.k"};
if (kcl_lint_path(paths, 1, out, sizeof(out))) {
    puts(out);   // newline-separated lint results
}
```

### `kcl_parse_file` / `kcl_parse_program`

```c
#include <kcl_lib.h>

char ast[BUFFER_SIZE];
if (kcl_parse_file("./schema.k", ast, sizeof(ast))) {
    puts(ast);    // AST JSON string
}

char env[BUFFER_SIZE];
const char* files[] = {"./schema.k"};
if (kcl_parse_program(files, 1, env, sizeof(env))) {
    puts(env);    // AST envelope (paths, root, errors, …)
}
```

## 底层模式（`kcl_call` + nanopb）

对于没有类型化辅助函数的 RPC（例如 `format_path`、`override_file`、`rename` 等），可以直接使用 nanopb 驱动调度器。这是添加新 RPC 的规范方式，并且与每个类型化辅助函数在内部执行的操作完全一致。

### `exec_program` —— 端到端

来自 v0.13.0 头文件的完整模式：

```c
#include <kcl_lib.h>

int exec_file(const char* file_str) {
    uint8_t buffer[BUFFER_SIZE];
    uint8_t result_buffer[BUFFER_SIZE];
    size_t message_length;
    bool status;
    struct Buffer file = {
        .buffer = file_str,
        .len = strlen(file_str),
    };
    struct Buffer* files[] = { &file };
    struct RepeatedString strs = { .repeated = &files[0], .index = 0, .max_size = 1 };
    ExecProgramArgs args = ExecProgramArgs_init_zero;
    args.k_filename_list.funcs.encode = encode_str_list;
    args.k_filename_list.arg = &strs;

    pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
    status = pb_encode(&stream, ExecProgramArgs_fields, &args);
    message_length = stream.bytes_written;

    if (!status) {
        printf("Encoding failed: %s\n", PB_GET_ERROR(&stream));
        return 1;
    }

    const char* api_str = "KclService.ExecProgram";
    size_t result_length = kcl_call(api_str, buffer, message_length, result_buffer);
    if (check_error_prefix(result_buffer)) {
        printf("%s", result_buffer);
        return 1;
    }
    pb_istream_t istream = pb_istream_from_buffer(result_buffer, result_length);

    ExecProgramResult result = ExecProgramResult_init_default;

    uint8_t yaml_value_buffer[BUFFER_SIZE] = { 0 };
    result.yaml_result.arg = yaml_value_buffer;
    result.yaml_result.funcs.decode = decode_string;

    uint8_t json_value_buffer[BUFFER_SIZE] = { 0 };
    result.json_result.arg = json_value_buffer;
    result.json_result.funcs.decode = decode_string;

    uint8_t err_value_buffer[BUFFER_SIZE] = { 0 };
    result.err_message.arg = err_value_buffer;
    result.err_message.funcs.decode = decode_string;

    uint8_t log_value_buffer[BUFFER_SIZE] = { 0 };
    result.log_message.arg = log_value_buffer;
    result.log_message.funcs.decode = decode_string;

    status = pb_decode(&istream, ExecProgramResult_fields, &result);

    if (!status) {
        printf("Decoding failed: %s\n", PB_GET_ERROR(&istream));
        return 1;
    }

    if (result.yaml_result.arg) {
        printf("%s\n", (char*)result.yaml_result.arg);
    }

    return 0;
}

int main(void)
{
    return exec_file("./test_data/schema.k");
}
```

### `validate_code` —— 端到端

```c
#include <kcl_lib.h>

int validate(const char* code_str, const char* data_str)
{
    uint8_t buffer[BUFFER_SIZE];
    uint8_t result_buffer[BUFFER_SIZE];
    size_t message_length;
    bool status;

    ValidateCodeArgs validate_args = ValidateCodeArgs_init_zero;
    validate_args.code.funcs.encode = encode_string;
    validate_args.code.arg = (void*)code_str;
    validate_args.data.funcs.encode = encode_string;
    validate_args.data.arg = (void*)data_str;

    pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
    status = pb_encode(&stream, ValidateCodeArgs_fields, &validate_args);
    message_length = stream.bytes_written;

    if (!status) {
        printf("Encoding failed: %s\n", PB_GET_ERROR(&stream));
        return 1;
    }

    const char* api_str = "KclService.ValidateCode";
    size_t result_length = kcl_call(api_str, buffer, message_length, result_buffer);
    if (check_error_prefix(result_buffer)) {
        printf("%s\n", result_buffer);
        return 1;
    }
    pb_istream_t istream = pb_istream_from_buffer(result_buffer, result_length);
    ValidateCodeResult result = ValidateCodeResult_init_default;

    result.err_message.funcs.decode = decode_string;
    uint8_t value_buffer[BUFFER_SIZE] = { 0 };
    result.err_message.arg = value_buffer;

    status = pb_decode(&istream, ValidateCodeResult_fields, &result);

    if (!status) {
        printf("Decoding failed: %s\n", PB_GET_ERROR(&istream));
        return 1;
    }

    printf("Validate Status: %d\n", result.success);
    if (result.err_message.arg) {
        printf("Validate Error Message: %s\n", (char*)result.err_message.arg);
    }
    return 0;
}

int main(void)
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

## 注意事项

旧版的 `BuildProgram` 和 `ExecArtifact` RPC 已于 v0.13.0 中从 `spec/spec.proto` 移除（请参阅 [lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；`kcl_call` 不再识别它们。如果你之前调用的是 `kcl_call("KclService.BuildProgram", …)`，请切换到 `KclService.ExecProgram` 并解码 `ExecProgramResult`。