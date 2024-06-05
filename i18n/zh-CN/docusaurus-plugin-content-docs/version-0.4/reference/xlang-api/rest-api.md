---
sidebar_position: 2
---

# Rest API

## 1. 启动 REST 服务

通过以下方式可以启动 RestAPI 服务：

```shell
python3 -m pip install kclvm -U
python3 -m gunicorn "kclvm.program.rpc-server.__main__:create_app()" -t 120 -w 4 -k uvicorn.workers.UvicornWorker -b :2021
```

或者

```shell
go install kcl-lang.io/kcl-go/cmds/kcl-go@main
kcl-go rest-server
```

然后可以通过 POST 协议请求服务：

```shell
$ curl -X POST http://127.0.0.1:2021/api:protorpc/BuiltinService.Ping --data '{}'
{
	"error": "",
	"result": {}
}
```

其中 POST 请求和返回的 JSON 数据和 Protobuf 定义的结构保持一致。

## 2. `BuiltinService` 服务

其中 `/api:protorpc/BuiltinService.Ping` 路径表示 `BuiltinService` 服务的 `Ping` 方法。

完整的 `BuiltinService` 由 Protobuf 定义：

```protobuf
service BuiltinService {
	rpc Ping(Ping_Args) returns(Ping_Result);
	rpc ListMethod(ListMethod_Args) returns(ListMethod_Result);
}

message Ping_Args {
	string value = 1;
}
message Ping_Result {
	string value = 1;
}

message ListMethod_Args {
	// empty
}
message ListMethod_Result {
	repeated string method_name_list = 1;
}
```

其中 `Ping` 方法可以验证服务是否正常，`ListMethod` 方法可以查询提供的全部服务和函数列表。

## 3. `KclvmService` 服务

`KclvmService` 服务是和 KCL 功能相关的服务。用法和 `BuiltinService` 服务一样。

比如有以下的 `Person` 结构定义：

```python
schema Person:
    key: str

    check:
        "value" in key  # 'key' is required and 'key' must contain "value"
```

然后希望通过 `Person` 来校验以下的 JSON 数据：

```json
{ "key": "value" }
```

可以通过 `KclvmService` 服务的 `ValidateCode` 方法完成。参考 `ValidateCode` 方法的 `ValidateCode_Args` 参数结构：

```protobuf
message ValidateCode_Args {
	string data = 1;
	string code = 2;
	string schema = 3;
	string attribute_name = 4;
	string format = 5;
}
```

根据 `ValidateCode_Args` 参数结构构造 POST 请求需要的 JSON 数据，其中包含 `Person` 定义和要校验的 JSON 数据：

```json
{
  "code": "\nschema Person:\n    key: str\n\n    check:\n        \"value\" in key  # 'key' is required and 'key' must contain \"value\"\n",
  "data": "{\"key\": \"value\"}"
}
```

将该 JSON 数据保存到 `vet-hello.json` 文件，然后通过以下命令进行校验：

```shell
$ curl -X POST \
    http://127.0.0.1:2021/api:protorpc/KclvmService.ValidateCode \
    -H  "accept: application/json" \
    --data @./vet-hello.json
{
    "error": "",
    "result": {
        "success": true
    }
}
```

说明校验成功。

## 4. 完整的 Protobuf 服务定义

跨语言的 API 通过 Protobuf 定义([https://github.com/kcl-lang/kcl-go/blob/main/pkg/spec/gpyrpc/gpyrpc.proto](https://github.com/kcl-lang/kcl-go/blob/main/pkg/spec/gpyrpc/gpyrpc.proto))：

```protobuf
// Copyright 2023 The KCL Authors. All rights reserved.
//
// This file defines the request parameters and return structure of the KCL RPC server.
// We can use the following command to start a KCL RPC server.

syntax = "proto3";

package gpyrpc;

import "google/protobuf/any.proto";
import "google/protobuf/descriptor.proto";

// ----------------------------------------------------------------------------

// kcl main.k -D name=value
message CmdArgSpec {
	string name = 1;
	string value = 2;
}

// kcl main.k -O pkgpath:path.to.field=field_value
message CmdOverrideSpec {
	string pkgpath = 1;
	string field_path = 2;
	string field_value = 3;
	string action = 4;
}

// ----------------------------------------------------------------------------
// gpyrpc request/response/error types
// ----------------------------------------------------------------------------

message RestResponse {
	google.protobuf.Any result = 1;
	string error = 2;
	KclError kcl_err = 3;
}

message KclError {
	string ewcode = 1; // See kclvm/kcl/error/kcl_err_msg.py
	string name = 2;
	string msg = 3;
	repeated KclErrorInfo error_infos = 4;
}

message KclErrorInfo {
	string err_level = 1;
	string arg_msg = 2;
	string filename = 3;
	string src_code = 4;
	string line_no = 5;
	string col_no = 6;
}

// ----------------------------------------------------------------------------
// service requset/response
// ----------------------------------------------------------------------------

// gpyrpc.BuiltinService
service BuiltinService {
	rpc Ping(Ping_Args) returns(Ping_Result);
	rpc ListMethod(ListMethod_Args) returns(ListMethod_Result);
}

// gpyrpc.KclvmService
service KclvmService {
	rpc Ping(Ping_Args) returns(Ping_Result);

	rpc ExecProgram(ExecProgram_Args) returns(ExecProgram_Result);

	rpc FormatCode(FormatCode_Args) returns(FormatCode_Result);
	rpc FormatPath(FormatPath_Args) returns(FormatPath_Result);
	rpc LintPath(LintPath_Args) returns(LintPath_Result);
	rpc OverrideFile(OverrideFile_Args) returns (OverrideFile_Result);

	rpc GetSchemaType(GetSchemaType_Args) returns(GetSchemaType_Result);
	rpc GetSchemaTypeMapping(GetSchemaTypeMapping_Args) returns(GetSchemaTypeMapping_Result);
	rpc ValidateCode(ValidateCode_Args) returns(ValidateCode_Result);

	rpc ListDepFiles(ListDepFiles_Args) returns(ListDepFiles_Result);
	rpc LoadSettingsFiles(LoadSettingsFiles_Args) returns(LoadSettingsFiles_Result);
}

message Ping_Args {
	string value = 1;
}
message Ping_Result {
	string value = 1;
}

message ListMethod_Args {
	// empty
}
message ListMethod_Result {
	repeated string method_name_list = 1;
}

message ParseFile_AST_Args {
	string filename = 1;
	string source_code = 2;
}
message ParseFile_AST_Result {
	string ast_json = 1; // json value
	KclError kcl_err = 2;
}

message ParseProgram_AST_Args {
	repeated string k_filename_list = 1;
}
message ParseProgram_AST_Result {
	string ast_json = 1; // json value
	KclError kcl_err = 2;
}

message ExecProgram_Args {
	string work_dir = 1;

	repeated string k_filename_list = 2;
	repeated string k_code_list = 3;

	repeated CmdArgSpec args = 4;
	repeated CmdOverrideSpec overrides = 5;

	bool disable_yaml_result = 6;

	bool print_override_ast = 7;

	// -r --strict-range-check
	bool strict_range_check = 8;

	// -n --disable-none
	bool disable_none = 9;
	// -v --verbose
	int32 verbose = 10;

	// -d --debug
	int32 debug = 11;

	// yaml/json: sort keys
	bool sort_keys = 12;
	// include schema type path in JSON/YAML result
	bool include_schema_type_path = 13;
}
message ExecProgram_Result {
	string json_result = 1;
	string yaml_result = 2;

	string escaped_time = 101;
}

message ResetPlugin_Args {
	string plugin_root = 1;
}
message ResetPlugin_Result {
	// empty
}

message FormatCode_Args {
	string source = 1;
}

message FormatCode_Result {
	bytes formatted = 1;
}

message FormatPath_Args {
	string path = 1;
}

message FormatPath_Result {
	repeated string changed_paths = 1;
}

message LintPath_Args {
	repeated string paths = 1;
}

message LintPath_Result {
	repeated string results = 1;
}

message OverrideFile_Args {
	string file = 1;
	repeated string specs = 2;
	repeated string import_paths = 3;
}

message OverrideFile_Result {
	bool result = 1;
}

message EvalCode_Args {
	string code = 1;
}
message EvalCode_Result {
	string json_result = 2;
}

message ResolveCode_Args {
	string code = 1;
}

message ResolveCode_Result {
	bool success = 1;
}

message GetSchemaType_Args {
	string file = 1;
	string code = 2;
	string schema_name = 3;
}
message GetSchemaType_Result {
	repeated KclType schema_type_list = 1;
}

message GetSchemaTypeMapping_Args {
	string file = 1;
	string code = 2;
	string schema_name = 3;
}
message GetSchemaTypeMapping_Result {
	map<string, KclType> schema_type_mapping = 1;
}

message ValidateCode_Args {
	string data = 1;
	string code = 2;
	string schema = 3;
	string attribute_name = 4;
	string format = 5;
}

message ValidateCode_Result {
	bool success = 1;
	string err_message = 2;
}

message Position {
	int64 line = 1;
	int64 column = 2;
	string filename = 3;
}

message ListDepFiles_Args {
	string work_dir = 1;
	bool use_abs_path = 2;
	bool include_all = 3;
	bool use_fast_parser = 4;
}

message ListDepFiles_Result {
	string pkgroot = 1;
	string pkgpath = 2;
	repeated string files = 3;
}

// ---------------------------------------------------------------------------------
// LoadSettingsFiles API
//    Input work dir and setting files and return the merged kcl singleton config.
// ---------------------------------------------------------------------------------

message LoadSettingsFiles_Args {
	string work_dir = 1;
	repeated string files = 2;
}

message LoadSettingsFiles_Result {
	CliConfig kcl_cli_configs = 1;
	repeated KeyValuePair kcl_options = 2;
}

message CliConfig {
    repeated string files = 1;
	string output = 2;
	repeated string overrides = 3;
	repeated string path_selector = 4;
	bool strict_range_check = 5;
	bool disable_none = 6;
	int64 verbose = 7;
	bool debug = 8;
}

message KeyValuePair {
	string key = 1;
	string value = 2;
}

// ----------------------------------------------------------------------------
// JSON Schema Lit
// ----------------------------------------------------------------------------

message KclType {
	string type = 1;                     // schema, dict, list, str, int, float, bool, any, union, number_multiplier
	repeated KclType union_types = 2 ;   // union types
	string default = 3;                  // default value

	string schema_name = 4;              // schema name
	string schema_doc = 5;               // schema doc
	map<string, KclType> properties = 6; // schema properties
	repeated string required = 7;        // required schema properties, [property_name1, property_name2]

	KclType key = 8;                     // dict key type
	KclType item = 9;                    // dict/list item type

	int32 line = 10;

	repeated Decorator decorators = 11;  // schema decorators
}

message Decorator {
	string name = 1;
	repeated string arguments = 2;
	map<string, string> keywords = 3;
}

// ----------------------------------------------------------------------------
// END
// ----------------------------------------------------------------------------
```
