---
sidebar_position: 1
---

# 简介

KCL 语言目前提供了多个通用编程语言接口，API 的接口形式和功能完全相同。

## C/Rust 语言

KCL 核心采用 Rust 语言开发，对外导出 C 语言 API 供 Go/Python/Java 等其他高级语言包装和集成。

## 其他语言

Go 语言是通过 CGO 包装 KCL 提供的 C-API，同时提供更深度的定制特性以满足上层工具的需求。

## REST-API

KCL 提供的 C-API 并没有 REST-API，REST-API 是通过 Protobuf 定义，最终由上层的 提供实现的命令行工具

### 启动 REST 服务

通过以下方式可以启动 RestAPI 服务：

```shell
kcl server
```

然后可以通过 POST 协议请求服务：

```shell
curl -X POST http://127.0.0.1:2021/api:protorpc/BuiltinService.Ping --data '{}'
```

输出为：

```json
{
	"error": "",
	"result": {}
}
```

其中 POST 请求和返回的 JSON 数据和 Protobuf 定义的结构保持一致。

### `BuiltinService` 服务

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

### `KclvmService` 服务

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
