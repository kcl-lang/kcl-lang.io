---
sidebar_position: 1
---

# 简介

KCL 是声明式配置策略语言，对于不方便通过配置直接描述的复杂的业务逻辑可以通过通用的编程语言开发 KCL 插件对语言进行扩展。KCL 支持通过通用语言开发插件，KCL 程序导入插件中的函数。KCL 通过插件运行时和辅助的命令行工具提供插件支持。KCL 插件框架目前支持 Python 语言和 Go 语言开发插件。

插件的 Git 仓库: [https://github.com/kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin)

## 使用 Go 编写插件

### 0. 前置依赖

使用 KCL Go 插件需要您的 `PATH` 中存在 `Go 1.21+` 并在 Go 代码中添加 KCL Go SDK 的依赖

### 1. 你好插件

编写如下 Go 代码并添加你好插件的依赖

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

在 KCL 代码中，可以通过 `kcl_plugin.hello` 导入 `hello` 插件。运行上述代码可以得到如下输出结果

```yaml
name: kcl
three: 3
```

### 2. 插件结构

KCL Go 插件本质上是一个简单的 Go 工程，主要包含插件代码的 Go 文件 `api.go`，其中定义了插件的注册以及实现函数

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

### 3. 插件测试

编写 `api_test.go` 文件对插件函数进行单元测试

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

## 使用 Python 编写插件

### 0. 先决条件

使用 KCL Python 插件需要在您的 PATH 中具有 Python 3.7+，并安装 KCL Python SDK。

```shell
python3 -m pip install kcl_lib
```

### 1. 你好插件

编写以下 Python 代码并添加名为 `my_plugin` 的插件。

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

test.k 的内容为：

```python
import kcl_plugin.my_plugin

result = my_plugin.add(1, 1)
```

## 使用 Java 编写插件

### 0. 先决条件

使用 KCL Java 插件需要在您的 PATH 中具有 Java 8+，并安装 KCL Java SDK。

### 1. 你好插件

编写以下 Java 代码并添加名为 `my_plugin` 的插件。

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

test.k 的内容为：

```python
import kcl_plugin.my_plugin

result = my_plugin.add(1, 1)
```
