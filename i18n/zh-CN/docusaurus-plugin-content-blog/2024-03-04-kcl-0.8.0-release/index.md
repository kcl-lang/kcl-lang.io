




---
slug: 2024-03-04-kcl-0.8.0-release
title: KCL v0.8.0 重磅发布 - 面向云原生场景更完善的生态模型、语言和工具链
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## 简介

KCL 团队很高兴地宣布 **KCL v0.8.0 新版本现在已经可用**！本次发布为大家带来了三方面的重点更新：**语言**、**工具链**、**社区集成 & 扩展支持**。

- _使用功能更完善错误更少的 KCL 语言、工具链和 IDE 提升代码编写体验和效率_
- _更加全面丰富的社区生态集成，改善运维体验_
- _更加丰富的 KCL 三方库模型，更加轻松的与云原生生态集成_

进一步您可以在 [KCL v0.8.0 发布页面](https://github.com/kcl-lang/kcl/releases/tag/v0.8.0) 或者 [KCL 官方网站](https://kcl-lang.io) 获得下载安装指南和详细发布信息。

[KCL](https://github.com/kcl-lang/kcl) 是一个 CNCF 基金会托管的面向云原生领域开源的基于约束的记录及函数编程语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于围绕配置的模块化、扩展性和稳定性，打造更简单的逻辑编写体验，构建更简单的自动化和生态集成路径。

## 语言更新

### 😸 新增 Linux arm64 版本

KCL 的 Release 产物中新增了对 Linux arm64 平台的支持。

可以在 [KCL Release Page](https://github.com/kcl-lang/kcl/releases) 中找到后缀为 `linux-arm64` 的压缩包。

### 🔧 诊断信息的优化

KCL 语法在 if 块中使用的是 `elif` 关键字，而不是 `else if`。

编译以下 KCL 程序：

```kcl
if True: a = 1
else if False: b = 1
```

KCL 在诊断信息中增加了错误修正的建议：

```shell
error[E1001]: InvalidSyntax
 --> main.k:2:6
  |
2 | else if False: b = 1
  |      ^ 'else if' here is invalid in KCL, consider using the 'elif' keyword
  |
```

### 🚀 语言编写体验优化

#### KCL 标准库新增文件系统访问方法

KCL 增加了访问文件系统的方法。在 v0.8.0 版本中支持了包括 `read`, `glob` 等访问文件系统的方法。

通过 `read` 方法，可以读取一个文件内容为字符串。

```kcl
import file

a = read("hello.txt")
```

在文件 `hello.txt` 中添加如下内容：

```shell
Hello World !
```

编译结果

```shell
a: Hello World !
```

通过结合 `json.decode` 方法，可以轻松的实现将 json 文件反序列化。

在 `hello.json` 文件中增加如下内容

```json
{
  "name": "John",
  "age": 10
}
```

KCL 程序如下所示：

```kcl
import file
import json

_a = json.decode(file.read("hello.json"))

name = _a.name
age = _a.age
```

编译结果如下所示：

```shell
name: John
age: 10
```

更多内容 - [https://kcl-lang.io/zh-CN/docs/reference/model/file/](https://kcl-lang.io/zh-CN/docs/reference/model/file/)

#### KCL 编译缓存路径支持使用环境变量 KCL_CACHE_PATH 指定

KCL 编译器会将缓存生成到环境变量`KCL_CACHE_PATH`指定的目录当中，如果没指定，将会生成到项目根目录中。

#### 插件系统支持使用 golang 编写 KCL 插件

使用 golang 定义 hello 插件。

```golang
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

借助 kcl-go 开发，扩展 KCL 编译器使用插件。

```kcl
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
three = hello.add(1,2) # 3
```

### 🏄 SDK & API 更新


TODO

### 🐞 其他更新及错误修复

TODO

## IDE & 工具链更新

### IDE 更新

体验改进
支持增量解析和异步编译功能，提升性能
错误修复
修复 assert 语句中字符串插值变量不能跳转的异常
修复了字符串中异常触发函数补全的异常
修复 import 语句别名语义检查和补全的异常
修复了 schema 中 check 表达式补全的异常

TODO

### 验证工具更新

本次更新中，我们对 KCL 验证工具的报错信息进行了优化，在使用 KCL 验证工具对 json/yaml 文件进行验证的工作中，将会准确定位到 json 文件的异常位置。

以 json 文件为例，我们将要对以下 hello.json 文件进行验证

```json
{
    "name": 10,
    "age": 18,
    "message": "This is Alice"
}
```

定义如下 main.k 文件来对 json 文件中的内容进行验证

```kcl
schema User:
    name: str
    age: int
    message?: str
```

通过以下命令对 json 文件内容进行验证

```shell
kcl vet hello.json main.k
```

可以看到在 json 文件中的错误位置：

```shell
error[E2G22]: TypeError
 --> test.json:2:5
  |
2 |     "name": 10,
  |     ^ expected str, got int(10)
  |

 --> main.k:2:5
  |
2 |     name: str
  |     ^ variable is defined here, its type is str, but got int(10)
  |
```

#### KCL cli 新增 git 仓库作为编译入口

通过以下命令，可以将 KCL 的 git 仓库作为编译入口

```shell
kcl run <git url>
```

#### kcl mod graph 支持输出 KCL 包依赖图

通过命令 `kcl mod graph` 输出 KCL 包的依赖图。

### KCL 包管理工具

#### KCL 包管理工具支持三方库名称带有“-”

KCL 包管理工具支持三方库名称中带有“-”，KCL 包管理工具会自动将 “-” 替换为 “_”。

以三方库 `set-annotation` 为例，通过以下命令添加 `set-annotation` 为依赖：

```shell
kcl mod add set-annotation
```

在 KCL 程序中，通过 `set_annotation` 引用：

```kcl
import set_annotation 
```

### KCL 导入工具更新，支持更多特性

- 支持 OpenAPI multiplyOf 规范映射到 KCL multiplyof 函数进行校验
- 支持 YAML Stream 格式的 Kubernetes CRD 文件输出为多个 KCL 文件
- 支持 OpenAPI allOf 关键字校验表达式生成
- 支持 KCL 数组和字典类型的 all/any 校验表达式生成

## 社区集成 & 扩展更新

### Flux KCL Controller 发布

我们开发了 [Flux KCL Controller](https://github.com/kcl-lang/flux-kcl-controller) 支持 KCL 与 Flux 集成。在集群中安装 Flux KCL Controller 后，通过以下资源就可以实现 KCL git 仓库通过 FluxCD 进行持续集成。

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kcl-deployment
  namespace: source-system
spec:
  interval: 30s
  # 需要持续集成的 github 仓库
  url: https://github.com/awesome-kusion/kcl-deployment.git
  ref:
    branch: main
---
apiVersion: krm.kcl.dev.fluxcd/v1alpha1
kind: KCLRun
metadata:
  name: kcl-deployment
  namespace: source-system
spec:
  sourceRef:
    kind: GitRepository
    name: kcl-deployment
```

更多内容详见: https://kcl-lang.io/zh-CN/blog/2024-02-01-biweekly-newsletter/

### CodeQL KCL 工具

初步支持 CodeQL KCL dbschema 定义以及对 KCL 语法语义进行数据提取，并可通过 CodeQL 进行数据查询对 KCL 代码进行静态分析和扫描，提升代码安全。

更多内容详见: https://github.com/kcl-lang/codeql-kcl

## 其他更新

完整更新和错误修复列表详见: https://github.com/kcl-lang/kcl/compare/v0.7.0...v0.8.0

## 文档更新

KCL 网站新增 KCL v0.7.0 文档内容并支持版本化语义选项，目前支持 v0.4.x, v0.5.x, v0.6.x, v0.7.0 和 v0.8.0 版本选择，同时欢迎社区同学进行文档共建。

## 社区动态

### KCL LFX 项目启动

恭喜 @AkashKumar7902, @octonawish-akcodes, @shashank-iitbhu 入选 CNCF KCL LFX 项目，同时感谢 @Vanshikav123, @Amit Pandey 的积极参与。

### KCL 登陆 Crossplane 官方函数市场

自 Crossplane v1.14 中的组合函数 Beta 版发布以来，使用 Crossplane 构建云原生平台的可能体验范围一直在迅速扩大。KCL 团队在第一时间进行跟进并主动构建了一个可重用的函数，整个 Crossplane 生态系统现在可以利用 KCL 提供的高水平经验和能力来构建自己的云原生平台。

更多内容详见: https://blog.crossplane.io/function-kcl/

### 特别鸣谢

感谢社区的小伙伴在 KCL v0.8.0 版本中的贡献，以下排名不分先后


## 下一步计划

感谢所有 KCL 用户和社区小伙伴在此次版本更新过程中提出的宝贵反馈与建议。预计 2024 年 2 月，我们将发布 KCL v0.9.0 版本，更多详情请参考 KCL 2024 路线规划 和 KCL v0.9.0 Milestone，如果您有更多的想法和需求，欢迎在 KCL Github 仓库发起 Issues 或讨论，也欢迎加入我们的社区进行交流 🙌 🙌 🙌

更多其他资源请参考：

- KCL 网站: https://kcl-lang.io/
- Kusion 网站: https://kusionstack.io/
- KCL GitHub 仓库: https://github.com/kcl-lang/kcl
- Kusion GitHub 仓库: https://github.com/KusionStack/kusion

- KCL v0.9.0 Milestone: https://github.com/kcl-lang/kcl/milestone/9
- KCL 2024 路线规划: https://github.com/kcl-lang/kcl/issues/882
- KCL 社区: https://github.com/kcl-lang/community

