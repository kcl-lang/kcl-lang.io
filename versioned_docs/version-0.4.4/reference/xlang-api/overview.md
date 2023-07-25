---
sidebar_position: 1
---

# Introduction

The KCL language provides general programming language interfaces such as C/Rust/Go/Python/Java, and the related languages are under development.

## C/Rust API

The core of KCL is developed in Rust, and the C language API is exported externally for packaging and integration in high-level languages such as Go/Python/Java.

## Go API

Go API is a C-API provided by CGO wrapping KCL, while providing deeper customization features to meet the needs of upper-level tools.

### Abstract Model

The abstract model of the KCL Go API is as follows:

```
┌─────────────────┐         ┌─────────────────┐           ┌─────────────────┐
│     kcl files   │         │    KCL-Go-API   │           │  KCLResultList  │
│  ┌───────────┐  │         │                 │           │                 │
│  │    1.k    │  │         │                 │           │                 │
│  └───────────┘  │         │                 │           │  ┌───────────┐  │         ┌───────────────┐
│  ┌───────────┐  │         │  ┌───────────┐  │           │  │ KCLResult │──┼────────▶│x.Get("a.b.c") │
│  │    2.k    │  │         │  │ Run(path) │  │           │  └───────────┘  │         └───────────────┘
│  └───────────┘  │────┐    │  └───────────┘  │           │                 │
│  ┌───────────┐  │    │    │                 │           │  ┌───────────┐  │         ┌───────────────┐
│  │    3.k    │  │    │    │                 │           │  │ KCLResult │──┼────────▶│x.Get("k", &v) │
│  └───────────┘  │    │    │                 │           │  └───────────┘  │         └───────────────┘
│  ┌───────────┐  │    ├───▶│  ┌───────────┐  │──────────▶│                 │
│  │setting.yml│  │    │    │  │RunFiles() │  │           │  ┌───────────┐  │         ┌───────────────┐
│  └───────────┘  │    │    │  └───────────┘  │           │  │ KCLResult │──┼────────▶│x.JSONString() │
└─────────────────┘    │    │                 │           │  └───────────┘  │         └───────────────┘
                       │    │                 │           │                 │
┌─────────────────┐    │    │                 │           │  ┌───────────┐  │         ┌───────────────┐
│     Options     │    │    │  ┌───────────┐  │           │  │ KCLResult │──┼────────▶│x.YAMLString() │
│WithOptions      │    │    │  │MustRun()  │  │           │  └───────────┘  │         └───────────────┘
│WithOverrides    │────┘    │  └───────────┘  │           │                 │
│WithWorkDir      │         │                 │           │                 │
│WithDisableNone  │         │                 │           │                 │
└─────────────────┘         └─────────────────┘           └─────────────────┘
```

The input file contains the KCL file and the `setting.yml` configuration file, and `Options` can be used to specify additional parameters and information such as working directory. The "KCL-Go-API" part is the provided KCL execution function. The execution function executes the KCL program according to the input file and additional parameters, and finally outputs the result of `KCLResultList`. `KCLResultList` is a list of `KCLResult`, each `KCLResult` corresponding to a generated configuration file or `map[string]interface{}`.

### Example

```go
package main

import (
	"fmt"

	"kcl-lang.io/kcl-go/api/kcl"
)


func main() {
	const k_code = `
import kcl_plugin.hello

name = "kcl"
age = 1

two = hello.add(1, 1)

schema Person:
    name: str = "kcl"
    age: int = 1

x0 = Person{}
x1 = Person{age:101}
`

	result := kcl.MustRun("hello.k", kcl.WithCode(k_code)).First()
	fmt.Println(result.YAMLString())

	fmt.Println("----")
	fmt.Println("x0.name:", result.Get("x0.name"))
	fmt.Println("x1.age:", result.Get("x1.age"))

	fmt.Println("----")

	var person struct {
		Name string
		Age  int
	}
	fmt.Printf("person: %+v\n", result.Get("x1", &person))
}
```

Output result:

```yaml
age: 1
name: kcl
two: 2
x0:
    age: 1
    name: kcl
x1:
    age: 101
    name: kcl

----
x0.name: kcl
x1.age: 101
----
person: &{Name:kcl Age:101}
```

## Python API

Using the Python SDK requires that you have a local Python version higher than 3.7.3 and a local pip package management tool. You can use the following command to install and obtain helpful information.

```bash
python3 -m pip install kclvm --user && python3 -m kclvm --help
```

### Command Line Tool

Prepare a KCL file named `main.k`

```python
name = "kcl"
age = 1

schema Person:
    name: str = "kcl"
    age: int = 1

x0 = Person {}
x1 = Person {
    age = 101
}
```

Execute the following command and get the output:

```shell
$ python3 -m kclvm hello.k
name: kcl
age: 1
x0:
  name: kcl
  age: 1
x1:
  name: kcl
  age: 101
```

### API

In addition, we can also execute KCL files through Python code.

Prepare a KCL file named `main.py`

```python
import kclvm.program.exec as kclvm_exec
import kclvm.vm.planner as planner

print(planner.plan(kclvm_exec.Run(["hello.k"]).filter_by_path_selector()))
```

Execute the following command and get the output:

```shell
$ python3 main.py
name: kcl
age: 1
x0:
  name: kcl
  age: 1
x1:
  name: kcl
  age: 101
```

You can see that the same output can be obtained through command line tools and APIs.

At present, the KCL Python SDK is still in the early preview version. The KCL team will continue to update and provide more functions in the future. For more information, see [https://github.com/kcl-lang/kcl-py](https://github.com/kcl-lang/kcl-py)

## REST-API

The C-API provided by KCL does not have a REST-API. The REST-API is defined by Protobuf and is finally implemented by the upper-layer Go-SDK.

### Start REST Service

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
{"key": "value"}
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

## APIs in other languages

Coming soon
