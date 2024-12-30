---
sidebar_position: 10
---

# C API

KCL [C API](https://github.com/kcl-lang/lib/tree/main/c) 正在开发中，欢迎贡献。

## 前置依赖

- Make
- C Compiler
- Cargo

## API 参考

### exec_program

Execute KCL file with arguments and return the JSON/YAML result.

<details><summary>Example</summary>
<p>

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
    ExecProgram_Args args = ExecProgram_Args_init_zero;
    args.k_filename_list.funcs.encode = encode_str_list;
    args.k_filename_list.arg = &strs;

    pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
    status = pb_encode(&stream, ExecProgram_Args_fields, &args);
    message_length = stream.bytes_written;

    if (!status) {
        printf("Encoding failed: %s\n", PB_GET_ERROR(&stream));
        return 1;
    }

    const char* api_str = "KclvmService.ExecProgram";
    size_t result_length = call_native((const uint8_t*)api_str, strlen(api_str), buffer, message_length, result_buffer);
    if (check_error_prefix(result_buffer)) {
        printf("%s", result_buffer);
        return 1;
    }
    pb_istream_t istream = pb_istream_from_buffer(result_buffer, result_length);

    ExecProgram_Result result = ExecProgram_Result_init_default;

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

    status = pb_decode(&istream, ExecProgram_Result_fields, &result);

    if (!status) {
        printf("Decoding failed: %s\n", PB_GET_ERROR(&istream));
        return 1;
    }

    if (result.yaml_result.arg) {
        printf("%s\n", (char*)result.yaml_result.arg);
    }

    return 0;
}

int main()
{
    exec_file("./test_data/schema.k");
    return 0;
}
```

</p>
</details>

### validate_code

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

```c
#include <kcl_lib.h>

int validate(const char* code_str, const char* data_str)
{
    uint8_t buffer[BUFFER_SIZE];
    uint8_t result_buffer[BUFFER_SIZE];
    size_t message_length;
    bool status;

    ValidateCode_Args validate_args = ValidateCode_Args_init_zero;
    validate_args.code.funcs.encode = encode_string;
    validate_args.code.arg = (void*)code_str;
    validate_args.data.funcs.encode = encode_string;
    validate_args.data.arg = (void*)data_str;

    pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
    status = pb_encode(&stream, ValidateCode_Args_fields, &validate_args);
    message_length = stream.bytes_written;

    if (!status) {
        printf("Encoding failed: %s\n", PB_GET_ERROR(&stream));
        return 1;
    }

    const char* api_str = "KclvmService.ValidateCode";
    size_t result_length = call_native((const uint8_t*)api_str, strlen(api_str), buffer, message_length, result_buffer);
    pb_istream_t istream = pb_istream_from_buffer(result_buffer, result_length);
    ValidateCode_Result result = ValidateCode_Result_init_default;

    result.err_message.funcs.decode = decode_string;
    uint8_t value_buffer[BUFFER_SIZE] = { 0 };
    result.err_message.arg = value_buffer;

    status = pb_decode(&istream, ValidateCode_Result_fields, &result);

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

</p>
</details>
