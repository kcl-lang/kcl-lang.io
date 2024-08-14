---
sidebar_position: 1
---

# Introduction

KCL provides plugin support through a plugin agent and auxiliary command line tools, and the KCL plugin framework supports different general-purpose languages to develop plugins. The KCL plugin framework currently supports the development of plugins in Python and Go languages.

KCL plugin Git repository: [https://github.com/kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin)

## Use Go to Write Plugins

### 0. Prerequisites

Using the KCL Go plugin requires the presence of `Go 1.21+` in your `PATH` and add the dependency of KCL Go SDK

### 1. Hello Plugin

Write the following Go code and add the dependency of the hello plugin

```go
package main

import (
	"fmt"

	"kcl-lang.io/kcl-go/pkg/kcl"
	"kcl-lang.io/kcl-go/pkg/native"                // Import the native API
	_ "kcl-lang.io/kcl-go/pkg/plugin/hello_plugin" // Import the hello plugin
)

func main() {
	// Note we use `native.MustRun` here instead of `kcl.MustRun`, because it needs the cgo feature.
	yaml := native.MustRun("main.k", kcl.WithCode(code)).GetRawYamlResult()
	fmt.Println(yaml)
}

const code = `
import kcl_plugin.hello

name = "kcl"
three = hello.add(1,2)  # hello.add is written by Go
`
```

In KCL code, the `hello` plugin can be imported via `import kcl_plugin.hello`. The output result is

```yaml
name: kcl
three: 3
```

### 2. Plugin Directory Structure

The KCL Go plugin is essentially a simple Go project, mainly containing the Go file `api.go` for the plugin code, which defines the registration and implementation functions of the plugin.

```go
package hello_plugin

import (
	"kcl-lang.io/kcl-go/pkg/plugin"
)

func init() {
	plugin.RegisterPlugin(plugin.Plugin{
		Name: "hello",
		MethodMap: map[string]plugin.MethodSpec{
			"add": {
				Body: func(args *plugin.MethodArgs) (*plugin.MethodResult, error) {
					v := args.IntArg(0) + args.IntArg(1)
					return &plugin.MethodResult{V: v}, nil
				},
			},
		},
	})
}
```

### 3. Test Plugin

Write a file called `api_test.go` to perform unit testing on plugin functions.

```go
package hello_plugin

import (
	"testing"

	"kcl-lang.io/kcl-go/pkg/plugin"
)

func TestPluginAdd(t *testing.T) {
	result_json := plugin.Invoke("kcl_plugin.hello.add", []interface{}{111, 22}, nil)
	if result_json != "133" {
		t.Fatal(result_json)
	}
}
```

## Use Python to Write Plugins

### 0. Prerequisites

Using the KCL Python plugin requires the presence of `Python 3.7+` in your `PATH` and install the KCL python SDK.

```shell
python3 -m pip kcl_lib
```

### 1. Hello Plugin

Write the following Python code and add the the plugin named `my_plugin`.

```python
import kcl_lib.plugin as plugin
import kcl_lib.api as api

plugin.register_plugin("my_plugin", {"add": lambda x, y: x + y})

def main():
    result = api.API().exec_program(
        api.ExecProgram_Args(k_filename_list=["test.k"])
    )
    assert result.yaml_result == "result: 2"

main()
```

The content of `test.k` are:

```python
import kcl_plugin.my_plugin

result = my_plugin.add(1, 1)
```

## Use Java to Write Plugins

### 0. Prerequisites

Using the KCL Java plugin requires the presence of `Java 8+` in your `PATH` and install the KCL Java SDK.

### 1. Hello Plugin

Write the following Java code and add the the plugin named `my_plugin`.

```java
package com.kcl;

import com.kcl.api.API;
import com.kcl.api.Spec.ExecProgram_Args;
import com.kcl.api.Spec.ExecProgram_Result;

import java.util.Collections;

public class PluginTest {
    public static void main(String[] mainArgs) throws Exception {
        API.registerPlugin("my_plugin", Collections.singletonMap("add", (args, kwArgs) -> {
            return (int) args[0] + (int) args[1];
        }));
        API api = new API();

        ExecProgram_Result result = api
                .execProgram(ExecProgram_Args.newBuilder().addKFilenameList("test.k").build());
        System.out.println(result.getYamlResult());
    }
}
```

The content of `test.k` are:

```python
import kcl_plugin.my_plugin

result = my_plugin.add(1, 1)
```
