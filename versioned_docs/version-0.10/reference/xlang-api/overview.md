---
sidebar_position: 1
---

# Introduction

The KCL language provides multiple general-purpose programming language interfaces, with identical API forms and features.

## C/Rust APIs

The core of KCL is developed in Rust, and the C language API is exported externally for packaging and integration in other high-level languages such as Go, Python, etc.

## REST-API

The C-API provided by KCL does not have a REST-API. The REST-API is defined by Protobuf.

### Start REST Service

The RestAPI service can be started in the following way:

```shell
kcl server
```

The service can then be requested via the POST protocol:

```shell
curl -X POST http://127.0.0.1:2021/api:protorpc/BuiltinService.Ping --data '{}'
```

The output is

```json
{
  "error": "",
  "result": {}
}
```

The POST request and the returned JSON data are consistent with the structure defined by Protobuf.

### `BuiltinService`

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

### `KclvmService`

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
  "data": "{\"key\": \"value\"}"
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
