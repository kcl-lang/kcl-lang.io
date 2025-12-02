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
	rpc Ping(PingArgs) returns(PingResult);
	rpc ListMethod(ListMethodArgs) returns(ListMethodResult);
}

message PingArgs {
	string value = 1;
}
message PingResult {
	string value = 1;
}

message ListMethodArgs {
	// empty
}
message ListMethodResult {
	repeated string method_name_list = 1;
}
```

The `Ping` method can verify whether the service is normal, and the `ListMethod` method can query the list of all services and functions provided.

### `KclService`

The `KclService` service is a service related to KCL functionality. The usage is the same as the `BuiltinService` service.

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

This can be done through the `ValidateCode` method of the `KclService` service. Refer to the `ValidateCodeArgs` structure of the `ValidateCode` method:

```protobuf
message ValidateCodeArgs {
	string data = 1;
	string code = 2;
	string schema = 3;
	string attribute_name = 4;
	string format = 5;
}
```

Construct the JSON data required by the POST request according to the `ValidateCodeArgs` structure, which contains the `Person` definition and the JSON data to be verified:

```json
{
  "code": "\nschema Person:\n    key: str\n\n    check:\n        \"value\" in key  # 'key' is required and 'key' must contain \"value\"\n",
  "data": "{\"key\": \"value\"}"
}
```

Save this JSON data to the `vet-hello.json` file and verify it with the following command:

```shell
$ curl -X POST \
    http://127.0.0.1:2021/api:protorpc/KclService.ValidateCode \
    -H  "accept: application/json" \
    --data @./vet-hello.json
{
    "error": "",
    "result": {
        "success": true
    }
}
```
