---
sidebar_position: 2
---

# Rest API

## 1. Start REST Service

The RestAPI service can be started in the following way:

```shell
kclvm -m gunicorn "kclvm.program.rpc-server.__main__:create_app()" -t 120 -w 4 -k uvicorn.workers.UvicornWorker -b :2021
```

The service can then be requested via the POST protocol:

```shell
$ curl -X POST http://127.0.0.1:2021/api:protorpc/BuiltinService.Ping --data '{}'
{
	"error": "",
	"result": {}
}
```

The POST request and the returned JSON data are consistent with the structure defined by Protobuf.

## 2. `BuiltinService`

Where the `/api:protorpc/BuiltinService.Ping` path represents the `Ping` method of the `BuiltinService` service.

The complete `BuiltinService` is defined by Protobuf:

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

The `Ping` method can verify whether the service is normal, and the `ListMethod` method can query the list of all services and functions provided.

## 3. `KclvmService`

The `KclvmService` service is a service related to KCL functionality. The usage is the same as the `BuiltinService` service.

For example, there is the following `Person` structure definition:

```python
schema Person:
    key: str

    check:
        "value" in key  # 'key' is required and 'key' must contain "value"
```

Then we want to use `Person` to verify the following JSON data:

```json
{ "key": "value" }
```

This can be done through the `ValidateCode` method of the `KclvmService` service. Refer to the `ValidateCode_Args` structure of the `ValidateCode` method:

```protobuf
message ValidateCode_Args {
	string data = 1;
	string code = 2;
	string schema = 3;
	string attribute_name = 4;
	string format = 5;
}
```

Construct the JSON data required by the POST request according to the `ValidateCode_Args` structure, which contains the `Person` definition and the JSON data to be verified:

```json
{
  "code": "\nschema Person:\n    key: str\n\n    check:\n        \"value\" in key  # 'key' is required and 'key' must contain \"value\"\n",
  "data": "{\"attr_name\": {\"key\": \"value\"}}"
}
```

Save this JSON data to the `vet-hello.json` file and verify it with the following command:

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

## 4. Complete Protobuf Service Definition

Cross-language APIs defined via Protobuf([https://github.com/kcl-lang/kcl-go/blob/main/pkg/spec/gpyrpc/gpyrpc.proto](https://github.com/kcl-lang/kcl-go/blob/main/pkg/spec/gpyrpc/gpyrpc.proto)):

````protobuf
// Copyright 2021 The KCL Authors. All rights reserved.
//
// This file defines the request parameters and return structure of the KCL RPC server.
// We can use the following command to start a KCL RPC server.
//
// ```
// kclvm -m kclvm.program.rpc-server -http=:2021
// ```
//
// The service can then be requested via the POST protocol:
//
// ```
// $ curl -X POST http://127.0.0.1:2021/api:protorpc/BuiltinService.Ping --data '{}'
// {
//    "error": "",
//    "result": {}
// }
// ```

syntax = "proto3";

package gpyrpc;

option go_package = "kcl-lang.io/kcl-go/pkg/spec/gpyrpc;gpyrpc";

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

	rpc ParseFile_LarkTree(ParseFile_LarkTree_Args) returns(ParseFile_LarkTree_Result);
	rpc ParseFile_AST(ParseFile_AST_Args) returns(ParseFile_AST_Result);
	rpc ParseProgram_AST(ParseProgram_AST_Args) returns(ParseProgram_AST_Result);

	rpc ExecProgram(ExecProgram_Args) returns(ExecProgram_Result);

	rpc ResetPlugin(ResetPlugin_Args) returns(ResetPlugin_Result);

	rpc FormatCode(FormatCode_Args) returns(FormatCode_Result);
	rpc FormatPath(FormatPath_Args) returns(FormatPath_Result);
	rpc LintPath(LintPath_Args) returns(LintPath_Result);
	rpc OverrideFile(OverrideFile_Args) returns (OverrideFile_Result);

	rpc EvalCode(EvalCode_Args) returns(EvalCode_Result);
	rpc ResolveCode(ResolveCode_Args) returns(ResolveCode_Result);
	rpc GetSchemaType(GetSchemaType_Args) returns(GetSchemaType_Result);
	rpc ValidateCode(ValidateCode_Args) returns(ValidateCode_Result);
	rpc SpliceCode(SpliceCode_Args) returns(SpliceCode_Result);

	rpc Complete(Complete_Args) returns(Complete_Result);
	rpc GoToDef(GoToDef_Args) returns(GoToDef_Result);
	rpc DocumentSymbol(DocumentSymbol_Args) returns(DocumentSymbol_Result);
	rpc Hover(Hover_Args) returns(Hover_Result);

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

message ParseFile_LarkTree_Args {
	string filename = 1;
	string source_code = 2;
	bool ignore_file_line = 3;
}
message ParseFile_LarkTree_Result {
	string lark_tree_json = 1;
}

message ParseFile_AST_Args {
	string filename = 1;
	string source_code = 2;
}
message ParseFile_AST_Result {
	string ast_json = 1; // json value
}

message ParseProgram_AST_Args {
	repeated string k_filename_list = 1;
}
message ParseProgram_AST_Result {
	string ast_json = 1; // json value
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
	repeated string changedPaths = 1;
}

message LintPath_Args {
	string path = 1;
}

message LintPath_Result {
	repeated string results = 1;
}

message OverrideFile_Args {
	string file = 1;
	repeated string specs = 2;
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
	string schema_name = 3; // emtry is all
}
message GetSchemaType_Result {
	repeated KclType schema_type_list = 1;
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

message CodeSnippet {
    string schema = 1;
    string rule = 2;
}

message SpliceCode_Args {
	repeated CodeSnippet codeSnippets = 1;
}

message SpliceCode_Result {
	string spliceCode = 1;
}

message Position {
	int64 line = 1;
	int64 column = 2;
	string filename = 3;
}

message Complete_Args {
	Position pos = 1;
	string name = 2;
	string code = 3;
}

message Complete_Result {
	string completeItems = 1;
}

message GoToDef_Args {
	Position pos = 1;
	string code = 2;
}

message GoToDef_Result {
	string locations = 1;
}

message DocumentSymbol_Args {
	string file = 1;
	string code = 2;
}

message DocumentSymbol_Result {
	string symbol = 1;
}

message Hover_Args {
	Position pos = 1;
	string code = 2;
}

message Hover_Result {
	string hoverResult = 1;
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
````
