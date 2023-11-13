---
slug: 2023-new-version-feature-interpretation-kclvm-go-feature-overview
title: KCL 新版本功能解读系列 - Go SDK 功能速览！
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, kcl-go]
---

## KCL 是什么？

[KCL](https://github.com/kcl-lang/kcl) 是一个开源的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置和策略的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更快的自动化集成和良好的生态延展性。

## `KCL Go SDK` 是什么？

kclvm 是一个 KCL 语言的运行时库，它提供了一个与 KCL 编译器交互的编程接口。它是一个客户端库，可用于对 KCL源代码执行各种操作，例如 执行、格式化等。`KCL Go SDK`是 kclvm 的 Go 语言包装，提供了 Go 语言的 SDK，方便了在云原生环境下 KCL 语言的集成。

目前，`KCL Go SDK` 客户端构建在 kclvm json2 rpc API 之上，这意味着它使用和其他语言的 kclvm 客户端使用的相同 API 与 KCL 源代码交互，这与其他语言的 KCL SDK 工作方式类似，但提供了更加友好的 Go 语言风格的包装。

## 新版本 `KCL Go SDK` 解决了什么问题？

KCL 作为一门配置型语言，和云原生领域有着极其紧密的联系，而另一方面，Go 语言已经成为了云原生领域通用编程语言的事实标准。在这样的背景下，开发 KCL 的 Go SDK 来完成 KCL 编译器与 Go 语言的直接交互就有了必要，这也是`KCL Go SDK`诞生的原因。

最初版本的 KCL 编译器及运行时使用 python 编写，由于 python 语言本身的性能问题和其动态语言的特性，初版 KCL 语言的运行速度和安全性都有很大提升空间。出于安全与效率问题的考虑，后续版本 KCL 编译器又使用了 rust 语言编写，因此新版本的`KCL Go SDK`基于 Rust 实现的 KCL 核心进行包装，去除了 python 依赖，简化了安装，优化了使用体验。

新版本`KCL Go SDK`可以视为一个纯 Go 包使用，无需任何外置依赖，可以通过一键`go install`即可完成安装使用。

## 命令行 `KCL Go SDK`快速体验

`KCL Go SDK`提供了一个自带的 KCL Go 命令行，支持用户通过`go install`来一键安装 kclvm 的 Go 命令行工具 `kcl-go`，其要求本地 Go 版本为1.18+, 同时要求本地有完整的 CGO 工具链。

只需执行

```bash
go install kusionstack.io/kclvm-go/cmds/kcl-go@latest
```

新建 KCL 源文件 hello.k

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
}
spec = {
    replicas = 3
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "${metadata.name}:1.14.2"
            ports = [{ containerPort = 80 }]
        }
    ]
}
```

之后可以直接在命令行中执行 KCL

```shell
$ kcl-go run ./hello.k
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: "nginx:1.14.2"
          ports:
            - containerPort: 80
```

## Go 代码如何集成 KCL

以上一节的 hello.k 为例，构建以下的 main.go 代码：

```go
package main

import (
	"fmt"
	"kusionstack.io/kclvm-go"
)

func main() {
	result := kclvm.MustRun("./hello.k").GetRawYamlResult()
	fmt.Println(result)
}
```

- `kclvm.MustRun("./hello.k").GetRawYamlResult()`运行对应的kcl源文件
- `fmt.Println(result)`打印运行结果

本地环境要求 Go 版本为1.18+,与完整的 CGO 工具链。运行命令行添加 `KCL Go SDK`依赖

```bash
go get kusionstack.io/kclvm-go@main
```

执行 Go 程序，结果为：

```shell
$ go run main.go
name: kcl
age: 1
x0:
  name: kcl
  age: 1
x1:
  name: kcl
  age: 101
```

## 总结

通过这一次的 `KCL Go SDK` 的版本变更，我们去除了 python 依赖并切换至性能更加优秀的 rust 运行时。文章分别简单展示了如何使用  `kcl-go` 命令行工具执行 KCL 源代码, 以及如何将 KCL 集成至您的 Go 程序之中。

当然除了简单的编译并运行 KCL 源码之外，`KCL Go SDK` 还提供了丰富的功能以方便用户更好地在 Go 中集成 KCL ， 包括：

- KCL 静态错误分析（lint与格式化）
- KCL 依赖分析、
- Go 结构体和 KCL Schema 互相转换等等

## 其他资源

感谢所有 KCL 用户和社区小伙伴在此次版本更新过程中提出的宝贵反馈与建议。受限于文章篇幅，后续我们会撰写更多 KCL v0.4.6 新版本功能解读系列文章，敬请期待!

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [Kusion 网站](https://kusionstack.io/)
- [KCL Github 仓库](https://github.com/kcl-lang/kcl)
- [kclvm-go Github 仓库](https://github.com/kcl-lang/kcl-go)
- [Kusion Github 仓库](https://github.com/KusionStack/kusion)
- [Konfig Github 仓库](https://github.com/KusionStack/konfig)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/kcl-lang/community](https://github.com/kcl-lang/community) 👏👏👏
