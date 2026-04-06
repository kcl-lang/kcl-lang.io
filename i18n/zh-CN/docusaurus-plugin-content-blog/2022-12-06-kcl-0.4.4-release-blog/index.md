---
slug: 2022-kcl-0.4.4-release-blog
title: KCL v0.4.4 发布日志
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

KCL 团队很高兴地宣布 0.4.4 版本现在已经可用！本次发布主要为 KCL 语言增加了自定义 YAML Manifests 输出的能力，用户可以通过编写代码并调用系统函数来自定义 YAML 输出的样式而无需理解复杂的 schema settings 语义；此外本次发布提供了最新的 [KCL Python SDK](https://github.com/kcl-lang/kcl-py) 可用于 Python 用户对 KCL 直接集成；同时我们大大降低了 KCL 安装包的体积，平均安装包体积降低为之前版本的五分之一，并包含多项编译器报错信息优化和 bug 修复。您可以在 [KCL 发布页面](https://github.com/kcl-lang/kcl/releases/tag/v0.4.4-alpha.2) 获得更多详细发布信息和 KCL 二进制下载链接。

## 背景

KCL 是一个开源的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置和策略的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更快的自动化集成和良好的生态延展性。

本文将向读者介绍 KCL 社区的近期动态。

## 新增特性

### 自定义 YAML 格式输出

在过去的 KCL 版本中，YAML 输出的样式是在 KCL 编译器中是硬编码的，用户可以为 schema 的 `__settings__` 元属性设置为不同的值来决定 YAML 输出样式，这带来了较高的复杂度和记忆成本，因此在 0.4.4 版本中我们提供了一个系统库函数用于开发人员更简单地自定义 YAML 输出样式，这个函数的签名如下：

```kcl
manifests.yaml_stream(values: [any], opts: {str:} = {
    sort_keys = False
    ignore_private = True
    ignore_none = False
    sep = "---"
})
```

这个函数的功能是将 KCL 对象列表序列化为带 `---` 分隔符的样式 YAML 输出，它具有两个参数:

- `values` - 一个 KCL 对象列表
- `opts` - YAML 序列化选项
  - `sort_keys`：是否按属性名称的字典序对序列化结果进行排序（默认为 `False`）。
  - `ignore_private`：是否忽略名称以 `_` 开头的属性序列化输出（默认为 `True`）。
  - `ignore_none`：是否忽略值为 `None` 的属性（默认为 `False`）。
  - `sep`：在多个 YAML 文档之间选择怎样的分隔符（默认为 `"---"`）。

下面我们通过一个例子来说明:

```kcl
import manifests

schema Deployment:
    apiVersion: str = "v1"
    kind: str = "Deployment"
    metadata: {str:} = {
        name = "deploy"
    }
    spec: {str:} = {
        replica = 2
    }

schema Service:
    apiVersion: str = "v1"
    kind: str = "Service"
    metadata: {str:} = {
         name = "svc"
    }
    spec: {str:} = {}

deployments = [Deployment {}, Deployment {}]
services = [Service {}, Service {}]

manifests.yaml_stream(deployments + services)
```

首先我们通过 `import` 关键字导入 `manifests` 模块并定义 2 个 Deployment 以及 2 个 Service 资源，当我们想以 YAML stream 并以 `---` 作为分隔符的格式依次输出这 4 个资源时，我们可以将它们合并为一个 KCL 列表并作为 `manifests.yaml_stream` 函数的 `values` 形参进行传入 (如无特殊需求，opts 参数一般使用默认值即可)，最终得到 YAML 输出为:

```yaml
apiVersion: v1
kind: Deployment
metadata:
  name: deploy
spec:
  replica: 2
---
apiVersion: v1
kind: Deployment
metadata:
  name: deploy
spec:
  replica: 2
---
apiVersion: v1
kind: Service
metadata:
  name: svc
---
apiVersion: v1
kind: Service
metadata:
  name: svc
```

> 注：schema 的 `__settings__` 元属性设置 YAML 输出样式的特性仍然可以在 v0.4.4 版本中使用，大约后续两个小版本发布后在 KCL v0.4.6 版本中，我们会移除这个特性

更多信息请参阅：[https://github.com/kcl-lang/kcl/issues/94](https://github.com/kcl-lang/kcl/issues/94)

### Python SDK

除了已有的 [KCL Go SDK](https://github.com/kcl-lang/kcl-go), 本次发布还新增了 KCL Python SDK，使用 Python SDK 要求您本地具备高于 3.7.3 的 Python 版本和 pip 包管理工具，可以通过如下命令进行安装并获得帮助信息

```bash
python3 -m pip install kclvm --user && python3 -m kclvm --help
```

#### 命令行工具

编写名为 `main.k` 的 KCL 文件:

```kcl
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

执行如下命令并获得输出:

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

#### API

此外，我们还可以通过 Python 代码实现对 KCL 文件的执行

编写名为 `main.py` 的 python 文件:

```kcl
import kclvm.program.exec as kclvm_exec
import kclvm.vm.planner as planner

print(planner.plan(kclvm_exec.Run(["hello.k"]).filter_by_path_selector()))
```

执行如下命令并获得输出:

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

可以看出通过命令行工具和 API 可以获得同样的输出。

目前 KCL Python SDK 还处于早期预览版本，后续 KCL 团队会持续更新并提供更丰富的功能，更多信息请参阅：[https://github.com/kcl-lang/kcl-py](https://github.com/kcl-lang/kcl-py)

## 安装体积优化

在新的 KCL 版本中，我们将 KCL 内置的 Python3 剥离，使得 KCL 二进制压缩包的体积从平均 200M 降低为 35M，用户可以更快地下载并使用 KCL，并且 Python Plugin 成为一个可选项，如果您想启用 KCL Python 插件，一个额外要求是需要您本地具备高于 3.7.3 版本的 Python 以及 pip 包管理工具，更多详情请参考 [https://github.com/kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin)

## 错误修复

### 函数调用错误信息优化

在 0.4.4 版本中，KCL 优化了当函数参数个数不匹配时的错误信息输出，支持显示函数名称以及参数不匹配个数

```kcl
schema Foo[x: int]:
    bar?: int = x

f = lambda x {
    x + 1
}

foo = Foo(1,2,3)  # Error: "Foo" takes 1 positional argument but 3 were given
f(1,2)  # Error: "f" takes 1 positional argument but 2 were given
```

更多信息请参阅：[https://github.com/kcl-lang/kcl/issues/299](https://github.com/kcl-lang/kcl/issues/299)

### 插值三引号字符串格式化错误修复

在之前的 KCL 版本中，对如下代码进行格式化会错误将携带字符串插值的三引号格式化为单引号字符串并导致编译错误，在 0.4.4 版本中我们进行了修复

```kcl
# Before KCL v0.4.4, variable "bar" will be formatted as:
#
# foo = 1
# bar = "
# ${foo}
# "
foo = 1
bar = """
${foo}
"""
```

### 条件配置块格式化错误修复

在之前的 KCL 版本中，对如下代码进行格式化会导致错误的缩进，在 0.4.4 版本中我们进行了修复

```kcl
# Before KCL v0.4.4, variable "foo" will be formatted as:
#
# foo = [
#     if True:
#         {key = "value"}
#     {key = "value"}
# ]
foo = [
    if True:
        {key = "value"}
        {key = "value"}
]
```

### 字符串字面值类型检查错误

在之前的 KCL 版本中，执行如下代码会得到一个非预期的类型检查错误，在 0.4.4 版本中我们进行了修复

```kcl
# Before KCL v0.4.4, we will get a unexpected type mismatch error.
foo: {"A"|"B": int} = {A = 1}
```

更多信息请参阅：[https://github.com/kcl-lang/kcl/issues/294](https://github.com/kcl-lang/kcl/issues/294)

### 其他错误修复

更多错误修复详见：[https://github.com/kcl-lang/kcl/milestone/2?closed=1](https://github.com/kcl-lang/kcl/milestone/2?closed=1)

## 文档

[KCL 网站](https://kcl-lang.github.io/) 初步建立，并完善 Kubernetes 场景[相关文档](https://kcl-lang.github.io/docs/user_docs/guides/working-with-k8s/overview).

更多网站信息详见 [https://kcl-lang.github.io/](https://kcl-lang.github.io/)

## 社区动态

KCL 社区新增三名外部贡献者 @my-vegetable-has-exploded, @possible-fqz, @orangebees, 感谢他们热情并积极地参与贡献

## 下一步计划

预计 2023 年 1 月底，我们将发布 KCL v0.4.5 版本，预期重点演进包括

- 语言用户界面持续优化，体验持续提升和用户痛点解决
- 更多场景和生态如 Kubernetes 和 CI/CD Pipeline 场景 KCL 支持和文档更新
- KCL Windows 版本支持
- KCL 包管理工具 kpm 发布
- KCL 新版 playground 支持

更多详情请参考 [KCL v0.4.5 Milestone](https://github.com/kcl-lang/kcl/milestone/3)

## 常见问题及解答

常见问题及解答详见：[https://kcl-lang.github.io/docs/user_docs/support/](https://kcl-lang.github.io/docs/user_docs/support/)

## 其他资源

- [KCL 网站](https://kcl-lang.io/)
- [Kusion 网站](https://kusionstack.io/)
- [KCL 仓库](https://github.com/kcl-lang/kcl)
- [Kusion 仓库](https://github.com/KusionStack/kusion)
- [Konfig 仓库](https://github.com/KusionStack/konfig)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/kcl-lang/community](https://github.com/kcl-lang/community)
