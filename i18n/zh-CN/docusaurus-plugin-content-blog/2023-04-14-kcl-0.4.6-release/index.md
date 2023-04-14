---
slug: 2022-kcl-0.4.6-release-blog
title: KCL v0.4.6 重磅发布 - 全新的 IDE 插件，包管理工具，Helm/Kustomize/KPT 工具集成
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL, KusionStack, Kusion]
---

## 简介

KCL 团队很高兴地宣布 KCL v0.4.6 版本现在已经可用！本次发布主要内容为语言错误提示改进，支持错误警告实时显示，跳转，代码补全等功能的全新 KCL VS Code 插件，支持 Git 依赖拉取的 KCL 包管理工具，为 Helm/Kustomize/KPT 等主流 Kubernetes 配置管理工具提供 KCL 插件支持；此外此次更新还包含多项编译器报错信息优化和错误修复。

在 KCL v0.4.6 版本中，KCL 二进制的体积整体相比 KCL v0.4.5 体积减小约 100%，用户可以快速下载并进行安装；您可以在 [KCL v0.4.6 发布页面](https://github.com/KusionStack/KCLVM/releases/tag/v0.4.6) 或者 [KCL 官方网站](https://kcl-lang.io) 获得 KCL 二进制下载链接和更多详细发布信息。

[KCL](https://github.com/KusionStack/KCLVM) 是一个开源的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置和策略的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更快的自动化集成和良好的生态延展性。

本文将会介绍 KCL v0.4.6 版本的更新内容以及 KCL 社区的近期动态。

## 语言更新

### KCL 错误提示改进

在之前的 KCL 版本中，运行一次 KCL 命令行工具只会显示一个错误信息与警告，在 KCL v0.4.6 版本中，支持了一次编译显示多个错误与警告的能力并改善了错误提示信息，用于提升 KCL 代码错误排查效率，比如对于如下 KCL 代码 (main.k)

```python
metadata = {
    labels = {key = "kcl
}
```

我们执行如下 KCL 命令行，可以看到会同时提示字符串编写错误和花括号未正确匹配错误的语法错误信息

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

## IDE 插件

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

更多 KCL VS Code 插件安装方式及详细更新内容请参考：https://kcl-lang.io/docs/tools/Ide/vs-code

### Kusion VS Code 插件

在 KCL VS Code 插件的基础上，我们还提供了与云原生运维发布场景结合更紧密的 Kusion VS Code 插件，支持一键应用配置预览与发布，详细请参考：https://github.com/KusionStack/vscode-kusion

## 社区工具集成

在 KCL v0.4.6 中，我们以统一的编程界面方式为 Kubernetes 社区 Helm, Kustomize, KPT 等配置管理工具提供了插件支持，编写几行 KCL 代码即可无侵入地完成对存量 Kustomize YAML，Helm Charts 的编辑和校验，比如编写少量 KCL 代码修改资源 label/annotation, 注入 sidecar 容器配置，使用 KCL schema 校验资源等。

比如为 Deployment 资源添加一个 `managed-by=kcl` annotation，仅需编写一行 KCL 代码

```python
[resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kcl"}} for resource in option("resource_list").items]
```

下面介绍 Kustomize 工具对 KCL 的具体集成方式为例详细说明。使用 Kustomize KCL 插件无需安装任何与 KCL 相关的二进制，仅需您本地安装有 Kustomize 工具即可

首先执行如下命令获取一个 Kustomize YAML 配置示例:

```shell
git clone https://github.com/KusionStack/kustomize-kcl.git
cd ./kustomize-kcl/examples/set-annotation/
```

编辑其中的 `KCLRun` 资源:

```yaml
apiVersion: fn.kpt.dev/v1alpha1
kind: KCLRun
metadata:
  annotations:
    config.kubernetes.io/function: |
      container:
        image: docker.io/peefyxpf/kustomize-kcl:v0.1.0
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
# EDIT THE SOURCE!
# This should be your KCL code which preloads the `ResourceList` to `option("resource_list")
spec:
  source: |
    [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kustomize-kcl"}} for resource in option("resource_list").items]
```

然后执行如下命令使用 KCL 代码仅为所有的 `Deployment` 资源添加一个 `managed-by=kustomize-kcl` annotation

```shell
sudo kustomize fn run ./local-resource/ --as-current-user --dry-run
```

可以得到如下 YAML 输出:

```yaml
---
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
    # This annotation is added by kcl
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

此外我们为 Kustomize/Helm/KPT 三个工具均提供了常用的容器、服务配置修改校验 KCL 模型，并且会持续完善，欢迎社区小伙伴一起参与共建。

+ 更多 Kustomize KCL 插件详细内容以及用例详见：https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/kustomize_kcl_plugin
+ 更多 Helm KCL 插件详细内容以及用例详见：https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/helm_kcl_plugin
+ 更多 KPT KCL 插件详细内容以及用例详见：https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/kpt_kcl_sdk

## 包管理工具

在 KCL v0.4.6 新版本中，我们提供了全新的 KCL 包管理工具，用户可以通过几个命令即可获得，比如可以通过包管理工具一键导入 KCL Kubernetes 模型并使用

```shell
kpm init kubernetes_demo && kpm add -git https://github.com/awesome-kusion/konfig.git -tag v0.0.1
```

编写 KCL 代码 (main.k)

```python
import konfig.base.examples.native.nginx_deployment as nd

demo = nd.demo
```

执行如下 KCL 命令即可获得一个 Nginx Deployment YAML 输出

```shell
$ kcl main.k -S demo
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

+ 更多 KCL 包管理工具安装方式、详细内容及用例详见：https://kcl-lang.io/docs/user_docs/guides/package-management/overview
+ 更多 Konfig 模型库的内容和使用方式详见：https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/overview

## 错误修复

### 单行条件配置块语法解析错误

在之前的 KCL 版本中，在编写如下 KCL 代码时会出现非预期的语法错误，在 KCL v0.4.6 版本中，我们修复了此类类似的问题

```python
env = "prod"
config = {if env == "prod": labels = {"kubernetes.io/env" = env}}
```

### Schema 必选属性检查

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

## 其他更新与错误修复

+ KCL 字符串新增 `removeprefix` 和 `removesuffix` 成员函数，[详见](https://kcl-lang.io/docs/reference/model/builtin#string-builtin-member-functions)
+ Go struct 和 KCL schema 双向转换支持，详见
  + [Go Struct -> KCL Schema](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/genkcl.go#L23)
  + [KCL Schema -> Go Struct](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/gengo.go#L23)
+ KCL schema 到 protobuf message 的转换支持，[详见](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/genpb.go#L25)
+ KCL 新增获取 schema 类型和实例 API，[详见](https://kcl-lang.io/docs/reference/xlang-api/go-api#func-getschematype)
+ KCL python plugin 功能默认不开启，如需开启可参考 [KCL Plugin 文档](https://kcl-lang.io/docs/reference/plugin/overview)
+ KCL playground 支持代码分享能力，您可以通过访问 [KCL 官网](https://kcl-lang.io/) 并点击 Playground 按钮进行体验
+ 更多更新与错误修复，[详见](https://github.com/KusionStack/KCLVM/milestone/3?closed=1)

## 文档更新

[KCL 网站](https://kcl-lang.io/) 新增 KCL v0.4.6 文档内容并支持版本化语义选项，目前支持 v0.4.3, v0.4.4, v0.4.5 和 v0.4.6 版本选择。

## 社区动态

+ KCL 社区新增两名外部贡献者 @Ekko, @jakezhu9, 感谢他们热情并积极地参与贡献
  + 感谢 @Ekko 为 kclvm-go SDK 的贡献，支持 Go Struct 和 KCL Schema 双向转换能力，[PR 链接](https://github.com/KusionStack/kclvm-go/pull/97)
  + 感谢 @jakezhu9 修复了 kclvm-go 未预期的 KCL 格式化 API 在 CI Pipeline 中单元测试错误，[PR 链接](https://github.com/KusionStack/kclvm-go/pull/94)

## 下一步计划

预计 2023 年 6 月上旬，我们将发布 **KCL v0.5.0 版本**，预期重点演进包括：

+ 更多针对场景问题的 KCL 语言编写便利性改进，用户界面持续优化与体验提升，用户支持和痛点解决
+ 更多 IDE 插件、包管理工具、Helm/Kustomize/KPT 场景集成、功能支持和用户体验提升
+ 针对云原生场景提供更多开箱即用的 KCL 模型支持，主要包含容器、服务、计算、存储和网络等
+ 支持 KCL Schema 直接生成 Kubernetes CRD
+ 支持 kubectl 和 helmfile KCL plugin，通过 KCL 代码直接生成、编辑和校验 Kubernetes 原生资源
+ 支持在 Kubernetes 运行时通过 Admission Controller 运行 KCL 代码对 YAML 进行编辑和校验
+ 更多非 Kubernetes 场景支持，如通过 KCL Schema 对 AI 模型进行数据清理和数据库 Schema 集成支持

更多详情请参考 [KCL v0.5.0 Milestone](https://github.com/KusionStack/KCLVM/milestone/5)

## 常见问题及解答

详见 [KCL 常见问题](https://kcl-lang.io/docs/user_docs/support/faq-kcl)

## 其他资源

感谢所有 KCL 用户和社区小伙伴在此次版本更新过程中提出的宝贵的反馈与建议。受限于文章篇幅，后续我们会撰写更多 KCL v0.4.6 新版本功能解读系列文章，敬请期待!

更多其他资源请参考：

+ [KCL 网站](https://kcl-lang.io/)
+ [Kusion 网站](https://kusionstack.io/)
+ [KCL Github 仓库](https://github.com/KusionStack/KCLVM)
+ [Kusion Github 仓库](https://github.com/KusionStack/kusion)
+ [Konfig Github 仓库](https://github.com/KusionStack/konfig)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/KusionStack/community](https://github.com/KusionStack/community)
