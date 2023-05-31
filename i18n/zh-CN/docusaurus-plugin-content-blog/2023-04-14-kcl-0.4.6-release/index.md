---
slug: 2022-kcl-0.4.6-release-blog
title: KCL v0.4.6 发布日志
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL, KusionStack, Kusion]
---

<!-- KCL v0.4.6 重磅发布 - 全新的 IDE 插件，Helm/Kustomize/KPT 工具集成 -->

## 简介

KCL 团队很高兴地宣布 KCL v0.4.6 新版本现在已经可用！本次发布为大家带来了三方面的重点更新：**语言**、**工具链**、**社区集成 & 扩展支持**。

+ *使用 IDE 插件提升 KCL 代码编写体验和效率*
+ *Helm/Kustomize/KPT 云原生社区工具集成*
+ *完善 KCL 多语言 SDK，方便应用程序集成*

进一步您可以在 [KCL v0.4.6 发布页面](https://github.com/KusionStack/kcl/releases/tag/v0.4.6) 或者 [KCL 官方网站](https://kcl-lang.io) 获得下载安装指南和详细发布信息。

[KCL](https://github.com/KusionStack/kcl) 是一个开源的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置和策略的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更快的自动化集成和良好的生态延展性。

本文重点介绍 KCL v0.4.6 版本的更新内容以及 KCL 社区的近期动态。

## 语言更新

### 内置函数更新

KCL 字符串新增 `removeprefix` 和 `removesuffix` 成员函数用于去除字符串的前缀和后缀子字符串

```python
data1 = "prefix-string".removeprefix("prefix-") # "string" 
data2 = "string-suffix".removesuffix("-suffix") # "string"
```

更多使用方式 [详见](https://kcl-lang.io/docs/reference/model/builtin#string-builtin-member-functions)

### 编译器提示信息改进

在之前的 KCL 版本中，运行一次 KCL 命令行工具只会显示一个错误信息与警告，在 KCL v0.4.6 版本中，支持了一次编译显示多个错误与警告的能力并改善了错误提示信息，用于提升 KCL 代码错误排查效率，比如对于如下 KCL 代码 (main.k)

```python
metadata = {
    labels = {key = "kcl
}
```

执行如下 KCL 命令行，可以看到会同时提示字符串编写错误和花括号未正确匹配错误的语法错误信息

```shell
$ kcl main.k
error[E1001]: InvalidSyntax
 --> main.k:2:21
  |
2 |     labels = {key = "kcl
  |                     ^ unterminated string
  |

error[E1001]: InvalidSyntax
 --> main.k:2:24
  |
2 |     labels = {key = "kcl
  |                        ^ expected "}"
  |
```

### 顶级 schema 语句合并运算符

在之前的 KCL 版本中，在编写如下 KCL 代码时，会将两个 schema 配置进行合并后输出，在 KCL v0.4.6 版本中，要求显式使用属性合并运算符而不是属性覆盖运算符

+ 更新前

```python
schema Config:
    id?: int
    value?: str

config = Config {
    id = 1
}
config = Config {
    value = "value"
}
```

+ 更新后

```python
schema Config:
    id?: int
    value?: str

# Use the union operator `:` instead of the override operator
config: Config {
    id = 1
}
# Use the union operator `:` instead of the override operator
config: Config {
    value = "value"
}
```

### 路径选择器参数简化

我们使用 path selector CLI 参数 (-S) 不必再填入包路径，并且可以直接筛选内部变量

对于如下的 KCL 代码 (main.k):

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}
```

我们可以执行如下命令

```shell
$ kcl main.k -S person
name: Alice
age: 18
```

### 错误修复

#### 单行条件配置块语法解析错误

在之前的 KCL 版本中，在编写如下 KCL 代码时会出现非预期的语法错误，在 KCL v0.4.6 版本中，我们修复了此类类似的问题

```python
env = "prod"
config = {if env == "prod": labels = {"kubernetes.io/env" = env}}
```

#### Schema 必选属性检查

在之前的 KCL 版本中，在编写如下 KCL 代码时，没有按预期提示 `versions` 属性没有赋值的错误，在 KCL v0.4.6 版本中，我们修复了此类类似的问题

```python
schema App:
    data?: [int]
    version: Version

schema Version:
    versions: [str]

app = App {
    version = Version {}
}
```

## 工具链更新

### KCL VS Code 插件

在此次更新中，我们发布了全新的 KCL VS Code 插件和使用 Rust 语言重写的语言服务服务器，相比于之前 KCL 版本性能约提升 20 倍，并支持了 KCL 错误警告在 IDE 中实时显示，以及 KCL 代码补全等新功能。

+ **错误与告警实时显示**

![Diagnostics](/img/docs/tools/Ide/vs-code/Diagnostics.gif)

+ **跳转**

![Goto Definition](/img/docs/tools/Ide/vs-code/GotoDef.gif)

+ **补全**

![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)

+ **悬停**

![Hover](/img/docs/tools/Ide/vs-code/Hover.gif)

更多 KCL VS Code 插件安装方式及详细更新内容[详见](https://kcl-lang.io/docs/tools/Ide/vs-code)

### Kusion VS Code 插件

在 KCL VS Code 插件的基础上，我们还提供了与云原生运维发布场景结合更紧密的 Kusion VS Code 插件，支持一键应用配置预览与发布，[详见](https://github.com/KusionStack/vscode-kusion)

### 包管理工具

在 KCL v0.4.6 新版本中，我们提供了全新的 KCL 包管理工具 alpha 版本，用户可以通过几个命令即可获得社区中已经编写好的 KCL 模型。比如可以通过包管理工具一键导入 KCL Kubernetes 模型并使用

```shell
kpm init kubernetes_demo && kpm add -git https://github.com/awesome-kusion/konfig.git -tag v0.0.1
```

编写 KCL 代码 (main.k)

```python
import konfig.base.pkg.kusion_kubernetes.api.apps.v1 as apps

apps.Deployment {
    metadata.name = "nginx-deployment"
    spec = {
        replicas = 3
        selector.matchLabels.app = "nginx"
        template.metadata.labels = selector.matchLabels
        template.spec.containers = [
            {
                name = selector.matchLabels.app
                image = "nginx:1.14.2"
                ports = [
                    {containerPort = 80}
                ]
            }
        ]
    }
}
```

执行如下 KCL 命令即可获得一个 Nginx Deployment YAML 输出

```shell
$ kpm run
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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
        - image: "nginx:1.14.2"
          name: nginx
          ports:
            - containerPort: 80
```

+ 更多 KCL 包管理工具安装方式、详细内容及用例[详见](https://kcl-lang.io/docs/user_docs/guides/package-management/overview)
+ 更多 Konfig 模型库的内容和使用方式[详见](https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/overview)

## 社区集成 & 扩展更新

### Kubernetes 配置管理工具扩展支持

在 KCL v0.4.6 中，我们以统一的编程界面方式为 Kubernetes 社区的 Helm, Kustomize, KPT 等配置管理工具提供了插件支持，编写几行 KCL 代码即可无侵入地完成对存量 Kustomize YAML，Helm Charts 的编辑和校验，比如编写少量 KCL 代码修改资源标签/注解, 注入 sidecar 容器配置，使用 KCL schema 校验资源等。

下面以 Kustomize 工具对 KCL 的集成为例进行详细说明。使用 Kustomize KCL 插件无需安装任何与 KCL 相关的二进制，仅需您本地安装有 Kustomize 工具即可。

首先执行如下命令获取一个 Kustomize YAML 配置示例:

```shell
git clone https://github.com/KusionStack/kustomize-kcl.git &&cd ./kustomize-kcl/examples/set-annotation/
```

然后执行如下命令使用 KCL 代码仅为所有的 `Deployment` 资源添加一个 `managed-by=kustomize-kcl` 注解

```shell
sudo kustomize fn run ./local-resource/ --as-current-user --dry-run
```

可以得到如下 YAML 输出:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: test
  annotations:
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
spec:
  selector:
    app: MyApp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 9376
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
  annotations:
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
    # This annotation is added through the kcl code.
    managed-by: kustomize-kcl
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
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

在上述 YAML 配置中，我们仅编写了一行 KCL 代码就完成为 Deployment 资源添加一个 `managed-by=kustomize-kcl` 注解

```python
[resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kcl"}} for resource in option("resource_list").item]
```

此外我们为 Kustomize/Helm/KPT 三个工具均提供了常用的容器、服务配置修改校验 KCL 模型，并且会持续完善，欢迎社区小伙伴一起参与共建。

+ 更多 Kustomize KCL 插件详细内容以及用例 [详见](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/kustomize_kcl_plugin)
+ 更多 Helm KCL 插件详细内容以及用例 [详见](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/helm_kcl_plugin)
+ 更多 KPT KCL 插件详细内容以及用例 [详见](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/kpt_kcl_sdk)

### 多语言 SDK

在此次更新中，我们发布了全新的 kclvm-go SDK 将 KCL 集成到您的 Go 应用程序中，并提供丰富的 API 与 KCL 进行交互。您可以在 [这里](https://kcl-lang.io/docs/next/reference/xlang-api/go-api) 查询详细的 API 文档。此外我们还更新了如下特性和错误修复：

+ 感谢 @jakezhu9 修复了 kclvm-go 未预期的 KCL 格式化 API 在 CI Pipeline 中单元测试错误
+ 感谢 @Ekko 贡献 Go struct 和 KCL schema 双向转换支持，详见:
  + [Go struct -> KCL schema](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/genkcl.go#L23)
  + [KCL schema -> Go struct](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/gengo.go#L23)
+ KCL schema 到 protobuf message 的转换支持，[详见](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/genpb.go#L25)
+ KCL 新增获取 schema 类型和实例 API，[详见](https://kcl-lang.io/docs/reference/xlang-api/go-api#func-getschematype)

## 其他更新与错误修复

+ KCL python plugin 功能默认不开启，如需开启可参考 [KCL Plugin 文档](https://kcl-lang.io/docs/reference/plugin/overview)
+ KCL playground 支持代码分享能力，您可以通过访问 [KCL 官网](https://kcl-lang.io/) 并点击 Playground 按钮进行体验
+ 更多更新与错误修复，[详见](https://github.com/KusionStack/kcl/milestone/3?closed=1)

## 文档更新

[KCL 网站](https://kcl-lang.io/) 新增 KCL v0.4.6 文档内容并支持版本化语义选项，目前支持 v0.4.3, v0.4.4, v0.4.5 和 v0.4.6 版本选择。同时欢迎社区同学进行文档共建。

## 下一步计划

预计 2023 年年中，我们将发布 **KCL v0.5.0 版本**，预期重点演进包括：

+ 更多针对场景问题的 KCL 语言编写便利性改进，用户界面持续优化与体验提升，用户支持和痛点解决
+ 更多 IDE 插件、包管理工具、Helm/Kustomize/KPT 场景集成、功能支持和用户体验提升
+ 针对云原生场景提供更多开箱即用的 KCL 模型支持，主要包含容器、服务、计算、存储和网络等
+ 支持 KCL Schema 直接生成 Kubernetes CRD
+ 支持 kubectl 和 helmfile KCL plugin，通过 KCL 代码直接生成、编辑和校验 Kubernetes 原生资源
+ 支持在 Kubernetes 运行时通过 Admission Controller 运行 KCL 代码对 YAML 进行编辑和校验
+ 更多非 Kubernetes 场景支持，如通过 KCL Schema 对 AI 模型进行数据清理和数据库 Schema 集成支持

更多详情请参考 [KCL v0.5.0 Milestone](https://github.com/KusionStack/kcl/milestone/5)

如果您有更多的想法和需求，欢迎在 KCL Github 仓库发起 [Issues](https://github.com/KusionStack/kcl/issues)，也欢迎加入我们的社区进行交流 🙌 🙌 🙌

## 常见问题及解答

详见 [KCL 常见问题](https://kcl-lang.io/docs/user_docs/support/faq-kcl)

## 其他资源

感谢所有 KCL 用户和社区小伙伴在此次版本更新过程中提出的宝贵反馈与建议。受限于文章篇幅，后续我们会撰写更多 KCL v0.4.6 新版本功能解读系列文章，敬请期待!

更多其他资源请参考：

+ [KCL 网站](https://kcl-lang.io/)
+ [Kusion 网站](https://kusionstack.io/)
+ [KCL Github 仓库](https://github.com/KusionStack/kcl)
+ [Kusion Github 仓库](https://github.com/KusionStack/kusion)
+ [Konfig Github 仓库](https://github.com/KusionStack/konfig)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/KusionStack/community](https://github.com/KusionStack/community)
