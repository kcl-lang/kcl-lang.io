---
slug: 2022-kcl-0.4.5-release-blog
title: KCL v0.4.5 发布日志
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL, KusionStack, Kusion]
---

## 简介

KCL 团队很高兴地宣布 KCL v0.4.5 版本现在已经可用！本次发布主要为 KCL 语言编写便利性和稳定性提升，错误信息改进以及更多平台包括 windows 版本支持以及更多下载方式支持。在 KCL v0.4.5 版本中，用户可以通过编写更少的 KCL 代码消除更多的配置模版；在新版本中提供了初步的 KCL Playground 支持可用于在线免安装编写并运行 KCL 代码；此外此次更新还包含多项编译器报错信息优化和错误修复。

您可以在 [KCL v0.4.5 发布页面](https://github.com/KusionStack/kcl/releases/tag/v0.4.5) 或者 [KCL 官方网站](https://kcl-lang.io/) 获得 KCL 二进制下载链接和更多详细发布信息。

[KCL](https://github.com/KusionStack/kcl) 是一个开源的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置和策略的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更快的自动化集成和良好的生态延展性。

本文将会介绍 KCL v0.4.5 版本的更新内容以及 KCL 社区的近期动态。

## 语言更新

### KCL 语言编写便利性改进

#### 支持 Schema 非空属性惰性校验

在之前的 KCL 版本中，我们已经支持了 schema 属性互相引用（包含继承）以及 check 校验表达式的惰性求值与校验能力，在此次版本更新中，我们支持了更多的 schema 惰性求值能力: Schema 属性非空惰性校验。比如对于下述的 KCL 的代码：

```python
schema Spec:
    id: int
    value: str

schema Config:
    name?: str
    spec: Spec = Spec {
        id = 1
    }   # 在 KCL v0.4.5 版本之前，这个语句会报属性非空错误，v0.4.5 版本之后，支持 Schema 非空属性惰性校验能力

config = Config {
    spec.value = "value"
}
```

在 v0.4.5 之前的 KCL 版本中，直接执行上述代码会在 `schema Config` 语句块的 `spec: Spec = Spec {` 处抛出一个 `spec` 的 `value` 属性不能为空的错误，因为在该处只对 `spec` 的 `id` 属性赋值为 `1`，而没有对 `spec` 的 `value` 属性赋值。

在 KCL 的 v0.4.5 版本更新后，我们支持了 schema 属性的惰性非空校验能力之后会避免这个错误的抛出，即当在 `config` 属性的 `spec.value = "value"` 与 `spec.id = 1` 合并之后才会递归地对 `config` 的所有属性进行非空检查，此时 `spec` 属性的所有值是被完整赋值的 (`spec` 的 `id` 字段的值为 `1`, `value` 字段为 `"value"`，)，不会抛出必选属性字段为空错误。

因此在 v0.4.5 版本之后，执行上述 KCL 代码，我们会得到如下所示的完整 YAML 输出:

```yaml
config:
  spec:
    id: 1
    value: value
```

#### 支持配置块属性互相引用以消除更多的配置模版

在 v0.4.5 之前的版本中，KCL 尚未支持配置块内部的属性互相引用，导致在某些场景中会需要定义额外的配置变量或者模版来进行引用，会产生较多的配置模版和重复代码，比如对于如下所示的 KCL 代码：

```python
name = "app-name"
data = {
    name = name
    metadata.name = name  # `metadata.name` 不能直接引用 `data` 内部的 `name` 属性
}
```

`data` 配置块的 `metadata.name` 属性不能直接引用 `data` 内部的 `name` 属性，需要额外定义一个全局变量 `name` 进行引用。

而在 KCL 的 v0.4.5 版本更新后，我们支持了配置块属性互相引用的特性，可以用于消除更多的配置模版，比如如下所示的 KCL 代码：

```python
data = {
    name = "app-name"
    metadata.name = name  # 直接引用 `data` 配置的 name 属性
}
```

`data` 配置块的 `metadata.name` 属性可以直接引用 `data` 内部的 `name` 属性而无需定义额外的全局变量。

执行上述 KCL 代码可以获得如下 YAML 输出:

```yaml
data:
  name: app-name
  metadata:
    name: app-name
```

下面是一个更复杂的例子

```python
name = "global-name"
metadata = {
    name = "metadata-name"
    labels = {
        "app.kubernetes.io/name" = name  # 直接引用 `metadata.name`
        "app.kubernetes.io/instance" = name  # 直接引用 `metadata.name`
    }
}
data = {
    name = name  # 引用全局的 `name` 变量
    metadata = metadata  # 引用全局的 `metadata` 变量
    spec.template.metadata.name = metadata.name  # 引用 `data` 内部的 `metadata` 变量
}
```

执行上述代码可以获得如下 YAML 输出:

```yaml
name: global-name
metadata:
  name: metadata-name
  labels:
    app.kubernetes.io/name: metadata-name
    app.kubernetes.io/instance: metadata-name
data:
  name: global-name
  metadata:
    name: metadata-name
    labels:
      app.kubernetes.io/name: metadata-name
      app.kubernetes.io/instance: metadata-name
  spec:
    template:
      metadata:
        name: metadata-name
```

> ⚠️ 注意：当前 KCL 版本尚未支持配置块内部属性后向引用以及跳过内部作用域直接引用全局变量，需要将被引用的属性书写在配置引用处的前方

### KCL 语言新增功能

#### 字符串 format 成员函数支持索引格式化

在 KCL v0.4.5 版本更新后，KCL 支持了类似 Python 字符串 format 成员函数在 `{}` 格式化块中使用 `<format_ele_index>[<index_or_key>]` 索引标记样式对列表和字典类型的 KCL 变量进行格式化。其中

+ `<format_ele_index>` 表示需要需要序列化列表和字典类型元素的索引
+ `<index_or_key>` 表示对应列表和字典类型元素的列表子元素索引或者字典子元素键值

比如对于如下的 KCL 代码

```python
# 0[0] 表示取 ["Hello", "World"] 的第 0 个元素："Hello"
# 0[1] 表示取 ["Hello", "World"] 的第 1 个元素："World"
listIndexFormat = "{0[0]}{0[1]}".format(["Hello", "World"])
# 0[0] 表示取 ["0", "1"] 的第 0 个元素："1"
# 1[Hello] 表示取 {"Hello": "World"} 键值为 Hello 的字典元素："World"
dictIndexFormat = "0{0[0]}, 1{0[1]}, Hello{1[Hello]}".format(["0", "1"], {"Hello": "World"})
```

执行上述代码可以获得如下 YAML 输出:

```yaml
listIndexFormat: HelloWorld
dictIndexFormat: "00, 11, HelloWorld"
```

### KCL 语言 Playground 更新

在此次更新中，我们更新了 KCL Playground 的版本并支持 KCL 代码自动编译和格式化两项能力，您可以通过访问 [KCL 官网](https://kcl-lang.io/) 并点击 Playground 按钮进行体验。

![](/img/blog/2023-02-27-kcl-0.4.5-release-blog/kcl-website-playground.png)

![](/img/blog/2023-02-27-kcl-0.4.5-release-blog/kcl-playground.png)

在后续 KCL 版本中，我们会持续更新 KCL Playground 更多能力支持如 KCL 版本选择与代码分享等功能。

### KCL 更多平台和更多下载方式支持

#### Windows 版本支持

KCL Windows 二进制版本可以从 [Github](https://github.com/KusionStack/kcl/releases/) 手动下载并安装，下载完成后将 `{install-location}\kclvm\bin` 添加到环境变量 `PATH` 中。

```powershell
$env:PATH += ";{install-location}\kclvm\bin;"
```

此外，还可以通过如下所示的 Powershell 脚本进行安装:

```powershell
powershell -Command "iwr -useb https://kcl-lang.io/script/install.ps1 | iex"
```

我们后续会支持更多的 Windows 包管理下载方式，如 `Scoop` 等。

#### 更多下载方式支持

在此次版本更新中，我们支持了更多的 KCL 下载方式，包括脚本, Python, Go, Homebrew 和 Docker 一键安装，更多详细内容请参考 [KCL 下载与安装](https://kcl-lang.io/docs/user_docs/getting-started/install)，后续我们会支持更多 KCL 安装方式。

> ⚠️ 注意：对于上述所有操作系统和安装方式，如果要使用 [KCL Python 插件](https://kcl-lang.io/docs/reference/plugin/overview) 能力，需要确保已经安装了 Python 3.7+ 版本并将 python3 命令添加到您的 PATH 环境变量中。

## 错误修复

### 当存在非配置表达式的右值时配置合并顺序错误

```python
schema Resource:
    cpu: int
    memory: str

schema Config:
    resource: Resource

r = Resource {
    cpu = 4
    memory = "8Gi"
}

config: Config {
    resource: Resource {
        cpu = 2
        memory = "4Gi"
    }
}

config: Config {
    resource: r
}
```

在 KCL v0.4.5 版本之前，执行上述代码 (main.k) 会得到非预期的配置值，是因为 KCL 编译器错误地优化了如下形式等效合并配置块

```python3
config: Config {
    resource: r
    resource: Resource {
        cpu = 2
        memory = "4Gi"
    }
}
```

KCL v0.4.5 版本更新后，修正了不正确配置合并顺序，可以执行 main.k 并获得预期的 YAML 输出:

```yaml
r:
  cpu: 4
  memory: 8Gi
config:
  resource:
    cpu: 4
    memory: 8Gi
```

更多详情请参考 [KCL Issue #422](https://github.com/KusionStack/kcl/issues/422)

### 配置 if 表达式类型不匹配错误优化

```python
config: {"A"|"B": int} = {
    if True:
        A = "2"
}
```

在 KCL v0.4.5 版本之前，对于配置 if 表达式，执行上述代码会得到预期的配置值导致 Type Unsoundness 问题，是因为 KCL 编译器错误地没有检查出 `A` 属性的值 `"2"` 与声明的类型 `int` 不匹配，KCL v0.4.5 版本更新后，修正了此类问题，可以执行上述代码可以获得预期的类型不匹配错误:

```stderr
KCL Compile Error[E2G22] : The type got is inconsistent with the type expected
---> File main.k:1:1
1 |config: {"A"|"B": int} = {
 1 ^  -> got {str(A):str(2)}
expect {str(A)|str(B):int}, got {str(A):str(2)}
```

更多详情请参考 [KCL Issue #389](https://github.com/KusionStack/kcl/issues/389)

### Rule 语句校验不生效问题

在之前的 KCL 版本中，在使用如下 rule 规则代码时 (main.k)，`ServiceCheckRule` 的约束代码会不生效。

```python
protocol KubeResourceProtocol:
    svc: Service

schema Service:
    name: str

rule ServiceCheckRule for KubeResourceProtocol:
    svc.name != "name"

svc = Service {
    name = "name"
}

ServiceCheckRule {
    svc = svc
}
```

进行改进后，我们执行上述代码，会得到一个准确的校验不通过错误:

```stderr
KCL Runtime Error[E3B17] : Schema check is failed to check condition
---> File main.k:14
14 |ServiceCheckRule { -> Instance check failed
    ---> File main.k:8
    8 |    svc.name != "name" -> Check failed on the condition
Check failed on check conditions
```

### 配置块属性类型推导优化

```python
schema Id:
    id?: int = 1

schema Config:
    data?: {"A"|"B": Id}

c = Config {
    data = {
        A = Id()  # v0.4.5 版本之前，此处会得到一个类型不匹配错误
        B = Id()
    }
}
```

在 KCL v0.4.5 版本之前，执行上述代码会得到一个非预期的类型不匹配，是因为 KCL 编译器错误地将 `c.data.A` 属性的类型推导为 `str` 类型，导致与 `"A"|"B"` 字面值联合类型不匹配错误，KCL v0.4.5 版本更新后，修正了此类问题，可以执行上述代码可以获得预期的 YAML 输出:

```yaml
c:
  data:
    A:
      id: 1
    B:
      id: 1
```

### 赋值语句使用 schema 类型注解错误优化

```python
schema Foo:
    foo: int

schema Bar:
    bar: int

foo: Foo = Bar {  # v0.4.5 版本之前，此处会得到一个运行时类型不匹配错误
    bar: 1
}
```

在 KCL v0.4.5 版本之前，执行上述代码会得到一个运行时类型不匹配错误，版本更新后，会将此类类型不匹配错误优化到编译时，将错误左移，更早地发现此类错误。

### KCL 模块类型使用 ?. 运算符类型错误修复

```python
import math

data = math?.log(10)  # v0.4.5 版本之前，此处会得到一个非预期的 `math is not defined` 错误
```

在 KCL v0.4.5 版本之前，执行上述代码会得到一个非预期的变量未定义错误，是因为 KCL 编译器没有正确地处理 `math` module 类型和 `?.` 运算符结合使用的情况，版本更新后，此类问题得到修复。

## 其他更新与错误修复

更多更新与错误修复 [详见](https://github.com/KusionStack/kcl/milestone/3)

## 文档更新

[KCL 网站](https://kcl-lang.io/) 新增 KCL v0.4.5 文档内容并支持版本化语义选项，目前支持 v0.4.3, v0.4.4 和 v0.4.5 版本选择。

![](/img/blog/2023-02-27-kcl-0.4.5-release-blog/kcl-website-doc-version.png)

## 社区动态

+ KCL 社区新增两名外部贡献者 @thinkrapido, @Rishav1707, 感谢他们热情并积极地参与贡献。
+ 感谢 @Rishav1707 基于 KCL 建立了 Rust 语言版本的 [kcl-loader-rs](https://github.com/i-think-rapido/kcl-loader-rs) 子项目，当前版本支持根据 KCL 文件中的 Schema 和配置定义自动生成 Rust 结构体并支持 KCL 值到 Rust 结构体值的反序列化函数。

## 下一步计划

预计 2023 年 4 月中旬，我们将发布 **KCL v0.4.6 版本**，预期重点演进包括：

+ KCL 语言进一步编写便利性改进，用户界面持续优化与体验提升，用户支持和痛点解决
+ 全新版本的 KCL Language Server 和 [VSCode 语言插件](https://github.com/KusionStack/vscode-kcl)，性能预计**提升 20 倍**，并预期支持代码警告和错误波浪线提示，跳转，引用查找等核心基础能力
+ 针对 Kubernetes Manifests 配置管理场景痛点持续进行语言能力提升：如设计提供 [Helm](https://github.com/helm/helm) KCL Schema 插件以及为 [kpt](https://github.com/GoogleContainerTools/kpt) 工具提供 KCL SDK 等
+ [KCL 包管理工具 KPM](https://github.com/KusionStack/kpm) 发布，预期支持 Git 仓库代码依赖配置与更新，代码下载等基础能力
+ [KCL Playground](https://github.com/KusionStack/kcl-playground) 支持代码分享能力和 KCL 版本选择能力
+ [KCL Go SDK](https://github.com/KusionStack/kclvm-go) 更多能力支持：如支持 KCL Schema 和 Go 结构体的双向转换等
+ [KCL Python SDK](https://github.com/KusionStack/kclvm-py) 更多能力支持

更多详情请参考 [KCL v0.4.6 Milestone](https://github.com/KusionStack/kcl/milestone/4)

## 常见问题及解答

详见 [KCL 常见问题](https://kcl-lang.io/docs/user_docs/support/)

## 其他资源

感谢所有 KCL 用户在此次版本更新过程中提出的宝贵的反馈与建议。更多其他资源请参考：

+ [KCL 网站](https://kcl-lang.io/)
+ [Kusion 网站](https://kusionstack.io/)
+ [KCL Github 仓库](https://github.com/KusionStack/kcl)
+ [Kusion Github 仓库](https://github.com/KusionStack/kusion)
+ [Konfig Github 仓库](https://github.com/KusionStack/konfig)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/kcl-lang/community](https://github.com/kcl-lang/community)
