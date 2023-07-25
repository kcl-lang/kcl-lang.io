---
slug: 2022-kcl-0.5.0-release-blog
title: KCL v0.5.0 发布日志
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

<!-- KCL v0.5.0 重磅发布 - 面向云原生场景更易用的语言、工具链，社区集成和扩展支持 -->

## 简介

KCL 团队很高兴地宣布 KCL v0.5.0 新版本现在已经可用！本次发布为大家带来了三方面的重点更新：**语言**、**工具链**、**社区集成 & 扩展支持**。

+ *使用功能更完善错误更少的 KCL 语言和 IDE 提升代码编写体验和效率*
+ *使用 KPM, KCL OpenAPI 和 OCI Registry 等工具直接使用和共享您的云原生领域模型，降低学习和上手成本*
+ *使用 Github Action, ArgoCD 和 Kubectl KCL 插件等社区工具集成和扩展支持提升自动化效率*

进一步您可以在 [KCL v0.5.0 发布页面](https://github.com/kcl-lang/kcl/releases/tag/v0.5.0) 或者 [KCL 官方网站](https://kcl-lang.io) 获得下载安装指南和详细发布信息。

[KCL](https://github.com/kcl-lang/kcl) 是一个开源的基于约束的记录及函数语言并通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本文重点介绍 KCL v0.5.0 版本的更新内容以及 KCL 社区的近期动态。

## 语言更新

### 顶级变量输出

在之前的 KCL 版本中，运行如下 KCL 代码不会得到 YAML 输出，在 KCL v0.5.0 版本中，我们对此进行了改进并支持了顶级变量导出为 YAML 配置，用于减少额外的 KCL 代码书写和命令行参数，比如对于如下 KCL 代码 (main.k)

```python
schema Nginx:
    http: Http

schema Http:
    server: Server

schema Server:
    listen: int | str
    location?: Location

schema Location:
    root: str
    index: str

Nginx {  # 这里的 Nginx 实例会直接输出为 YAML
    http.server = {
        listen = 80
        location = {
            root = "/var/www/html"
            index = "index.html"
        }
    }
}
```

在新版本中，运行 KCL 代码可以直接获得如下输出

```yaml
$ kcl main.k
http:
  server:
    listen: 80
    location:
      root: /var/www/html
      index: index.html
```

更多信息[详见](https://github.com/kcl-lang/kcl/pull/556)

### 索引签名更新

在之前的 KCL 版本中，尚未支持在 Schema 索引签名中直接引用，在 KCL v0.5.0 版本中，我们对此进行了改进并支持了顶级变量导出为 YAML 配置，用于减少额外的 KCL 样板配置代码书写，比如对于如下 KCL 代码 (main.k)

```python
schema TeamSpec:
    fullName: str
    name = id
    shortName: str = name

schema TeamMap:
    [n: str]: TeamSpec = TeamSpec {
        name = n  # n 作为 Schema 索引签名别名，可以直接使用
    }

teamMap = TeamMap {
    a.fullName = "alpha"
    b.fullName = "bravo"
}
```

在新版本中，运行 KCL 代码可以获得如下输出

```yaml
$ kcl main.k
teamMap:
  b:
    fullName: bravo
    name: b
    shortName: b
  a:
    fullName: alpha
    name: a
    shortName: a
```

更多信息[详见](https://github.com/kcl-lang/kcl/pull/582)

### KCL 支持运行时错误 Backtrace 打印

在新版本中，我们支持当 KCL 代码运行发生报错时输出 Backtrace 的特性，用于提升 KCL 代码错误排查效率，比如对于如下代码 (main.k)

```python
schema Fib:
    n1 = n - 1
    n2 = n1 - 1
    n: int
    value: int

    if n <= 1:
        value = [][n]  # 这里有索引溢出的运行时错误
    elif n == 2:
        value = 1
    else:
        value = Fib {n = n1}.value + Fib {n = n2}.value

fib8 = Fib {n = 4}.value
```

执行后会获得如下报错

```shell
$ kcl main.k -d
error[E3M38]: EvaluationError
EvaluationError
 --> main.k:8
  |
8 |         value = [][n]  # 这里有索引溢出的运行时错误
  |  list index out of range: 1
  |
note: backtrace:
        1: __main__.Fib
                at main.k:8
        2: __main__.Fib
                at main.k:12
        3: __main__.Fib
                at main.k:12
        4: main
                at main.k:14
```

更多信息[详见](https://github.com/kcl-lang/kcl/pull/528)

### 错误修复

#### filter 表达式返回值类型错误修复

在之前的 KCL 版本中，filter 表达式会返回错误的类型（应该返回被迭代对象的类型，而不是返回迭代对象的类型），在 KCL v0.5.0 版本中，我们修复了此类类似的问题

```python
schema Student:
    name: str
    grade: int

students: [Student] = [
    {name = "Alice", grade = 85}
    {name = "Bob", grade = 70}
]

studentsGrade70: [Student] = filter s in students {
    s.grade == 70
}  # 这里之前得到一个类型错误，版本更新后修复了此类问题
```

更多信息[详见](https://github.com/kcl-lang/kcl/pull/546)

#### lambda 函数闭包捕获

在之前的 KCL 版本中，在编写如下 KCL 代码时，会错误的捕获闭包变量的值。在 KCL v0.5.0 版本中，我们修复了此类类似的问题

```python
z = 1
add = lambda x { lambda y { x + y + z} }  # x 是内层 lambda 函数的闭包变量
res = add(1)(1)  # 3
```

更多信息[详见](https://github.com/kcl-lang/kcl/pull/548)

#### 包含 UTF-8 字符的字符串联合类型检查错误修复

在之前的 KCL 版本中，在编写如下包含 UTF-8 字符的字符串联合类型 KCL 代码时，会获得一个非预期的类型错误。在 KCL v0.5.0 版本中，我们修复了此类类似的问题

```python
msg: "无需容灾" | "标准型" | "流水型" = "流水型"
```

更多信息[详见](https://github.com/kcl-lang/kcl/pull/600)

## IDE & 工具链更新

### KCL OpenAPI 工具

kcl-openapi 命令行工具支持由 OpenAPI Spec 到 KCL 代码的转换。可通过 go install 或 curl 获得安装：

```bash
# go install
go install kcl-lang.io/kcl-openapi@latest

# curl install (MacOS & Linux)
curl -fsSL https://kcl-lang.io/script/install-kcl-openapi.sh | /bin/bash
```

#### Kubernetes KCL 包转换优化

v0.5.0 版本优化了使用 Kubernetes KCL 包的体验：

+ 免转换获得：KCL 提供了开箱即用的 Kubernetes 1.14-1.27 各个版本的 KCL 包，通过包管理工具 `kpm add k8s:<version>` 即可获得
+ 如需自行转换其他 Kubernetes 版本的 KCL 模型，可通过如下的预处理脚本一键从 Kubernetes 仓库下载的 swagger.json 文件转换为 KCL 包，将如下命令的 1.27 改为需要的 Kubernetes 版本即可

```bash
version=1.27
spec_path=swagger.json
script_path=main.py
wget https://raw.githubusercontent.com/kubernetes/kubernetes/release-${version}/api/openapi-spec/swagger.json -O swagger.json
wget https://raw.githubusercontent.com/kcl-lang/kcl-openapi/main/scripts/preprocess/main.py -O main.py
python3 ${script_path} ${spec_path} --omit-status --rename=io.k8s=k8s
kcl-openapi generate model -f processed-${spec_path}
```

脚本预期的执行输出为对应版本的 KCL Kubernetes 模型，生成的路径为 `<工作空间路径>/models/k8s`

```shell
$ tree models/k8s
models/k8s
├── api
│   ├── admissionregistration
│   │   ├── v1
│   │   │   ├── match_condition.k
│   │   │   ├── mutating_webhook.k
│   │   │   ├── mutating_webhook_configuration.k
│   │   │   ├── mutating_webhook_configuration_list.k
│   │   │   ├── rule_with_operations.k
│   │   │   ├── service_reference.k
│   │   │   ├── validating_webhook.k
...
```

#### 错误修复

+ 将带有-符号的属性名称转义为_符号，以符合 KCL v0.5.0 语法，[详见](https://github.com/kcl-lang/kcl-openapi/pull/43)
+ 自动识别并设置 import as 引用别名，避免引用冲突，[详见](https://github.com/kcl-lang/kcl-openapi/pull/45)
+ 修复 docstring 中属性描述缩进问题，对属性描述内部换行进行自动缩进，[详见](https://github.com/kcl-lang/kcl-openapi/pull/46)
+ 修复生成的引用路径为基于包的根目录的全引用路径，[详见](https://github.com/kcl-lang/kcl-openapi/pull/51)

### 包管理工具

在 KCL v0.5.0 新版本中，我们提供了全新的 KCL 包管理工具，用户可以通过几个命令即可获得社区中已经编写好的 KCL 模型。

#### 通过 kpm 命令行管理 KCL 程序

在使用 kpm 之前，需要确保您当前在一个 KCL 包中工作，您可以使用命令 kpm init 创建一个标准的 KCL 程序包。

```bash
kpm init kubernetes_demo && cd kubernetes_demo && kpm add k8s
```

然后，使用 k8s 包中的内容编写您的 KCL 代码（main.k）。

```python
# 导入 k8s 包中的内容
import k8s.api.apps.v1 as apps

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

通过 `kpm run` 和 `kubectl` 命令行结合使用，我们可以直接将资源配置下发到集群

```shell
$ kpm run | kubectl apply -f -

deployment.apps/nginx-deployment configured
```

#### OCI Registry 支持

kpm 支持通过 OCI Registry 保存 KCL 的程序包，kpm 目前提供的默认的 OCI Registry 为：[https://github.com/orgs/KusionStack/packages](https://github.com/orgs/KusionStack/packages)

您可以在这里浏览您需要的 KCL 包，我们目前提供了 k8s 的 KCL 程序包，支持 k8s 1.14 到 1.27 的全部版本。欢迎提 [Issues](https://github.com/kcl-lang/kpm/issues) 共建 KCL 模型

更多关于 kpm 包管理工具的内容[详见](https://kcl-lang.io/docs/user_docs/guides/package-management/quick-start)

## 社区集成 & 扩展更新

### CI 集成

在此次更新中我们提供了 **Github Actions 作为 CI 集成**的示例方案，希望通过使用容器、用于生成配置的持续集成 (CI) 和用于持续部署 (CD) 的 GitOps 来实现端到端应用程序开发流程。整体工作流程如下：

+ 应用代码开发并提交到提交到 GitHub 存储库触发 CI (这里使用 Python Flask Web 应用作为示例)

![app](/img/blog/2023-07-14-kcl-0.5.0-release/app.png)

+ GitHub Actions 从应用代码生成容器镜像，并将容器镜像推送到 docker.io 容器注册表

![app-ci](/img/blog/2023-07-14-kcl-0.5.0-release/app-ci.png)

+ GitHub Actions 根据 docker.io 容器注册表中容器镜像的版本号并自动同步更新 KCL 清单部署文件

![auto-update](/img/blog/2023-07-14-kcl-0.5.0-release/auto-update.png)

我们可以获得部署清单源码进行编译验证会得到如下 YAML 输出

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask_demo
  labels:
    app: flask_demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask_demo
  template:
    metadata:
      labels:
        app: flask_demo
    spec:
      containers:
        - name: flask_demo
          image: "kcllang/flask_demo:6428cff4309afc8c1c40ad180bb9cfd82546be3e"
          ports:
            - protocol: TCP
              containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flask_demo
  labels:
    app: flask_demo
spec:
  type: NodePort
  selector:
    app: flask_demo
  ports:
    - port: 5000
      protocol: TCP
      targetPort: 5000
```

从上述配置可以看出资源的镜像确实自动更新为了新构建的镜像内容 。此外，我们还可以使用 Argo CD KCL 插件自动从 Git 存储库同步或从中拉取数据并将应用部署到 Kubernetes 集群

更多详情请参考[这里](https://kcl-lang.io/docs/user_docs/guides/ci-integration/github-actions)

### CD 集成

此外我们还提供了 **ArgoCD 作为 CD 集成**的示例方案，通过 Github Action CI 集成和 ArgoCD KCL 插件，我们可以完成端到端的 GitOps 工作流，提升应用配置自动变更和部署效率。如下示出了使用 ArgoCD 应用 Kubernetes 配置的概览和同步情况，通过使用 ArgoCD 的能力，当业务代码发生变化时，自动同步更新并部署。

+ **应用概览**

![argocd-app](/img/blog/2023-07-14-kcl-0.5.0-release/argocd-app.png)

+ **配置同步**

![argocd-sync](/img/blog/2023-07-14-kcl-0.5.0-release/argocd-sync.png)

更多插件安装和使用方式请参考[这里](https://kcl-lang.io/docs/user_docs/guides/gitops/gitops-quick-start)

### Kubernetes 配置管理工具扩展支持

在 KCL v0.5.0 中，我们以统一的编程界面方式为 Kubernetes 社区的 Kubectl, Helm, Kustomize, KPT 等配置管理工具提供了插件支持，编写几行配置代码即可无侵入地完成对存量 Kustomize YAML，Helm Charts 的编辑和校验，比如修改资源标签/注解, 注入 Sidecar 容器配置，使用 KCL schema 校验资源，定义自己的抽象模型并分享复用等。

下面以 Kubectl 工具对 KCL 的集成为例进行详细说明。您可以在[这里](https://github.com/kcl-lang/kubectl-kcl)获取 Kubectl KCL 插件的安装方式

首先执行如下命令获取一个配置示例

```shell
git clone https://github.com/kcl-lang/kubectl-kcl.git && cd ./kubectl-kcl/examples/
```

然后执行如下命令显示配置

```shell
$ cat krm-kcl-abstration.yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: web-service-abtraction
spec:
  params:
    name: app
    containers:
      ngnix:
        image: ngnix
        ports:
        - containerPort: 80
    service:
      ports:
      - port: 80
    labels:
      name: app
  source: oci://ghcr.io/kcl-lang/web-service
```

在上述配置中，我们使用了在 OCI 上已经预定好的一个 Kubernetes Web 服务应用抽象模型 `oci://ghcr.io/kcl-lang/web-service`, 并通过 `params` 字段配置了该模型所需的配置字段。通过执行如下命令可以获得原始的 Kubernetes YAML 输出并下发到集群:

```shell
$ kubectl kcl apply -f krm-kcl-abstration.yaml

deployment.apps/app created
service/app created
```

更多 Kubernetes 配置管理工具详细介绍内容以及用例[详见](https://github.com/kcl-lang/krm-kcl/tree/main/examples)

目前 KCL 支持的 Kubernetes 配置管理工具集成仍处于早期，如果您有更多的想法和需求，欢迎发起 Issues 讨论共建

## 其他更新与错误修复

完整更新和错误修复列表[详见](https://github.com/kcl-lang/kcl/compare/v0.4.6...v0.5.0)

## 文档更新

[KCL 网站](https://kcl-lang.io/) 新增 KCL v0.5.0 文档内容并支持版本化语义选项，目前支持 v0.4.3, v0.4.4, v0.4.5, v0.4.6 和 v0.5.0 版本选择。同时欢迎社区同学进行文档共建。

## 社区动态

+ 感谢 @harri2012 对 KCL IDE 插件的首次贡献 🙌
+ 感谢 @niconical 对 KCL 命令行基础代码和 CI/CD 脚本的贡献 🙌
+ 感谢 @Ekko 对 KCL 云原生工具集成的贡献 🙌
+ 恭喜来自华中科技大学朱俊星同学成功入选 GitLink编程夏令营（GLCC）"Terraform/JsonSchema 转 KCL Schema" 课题 🎉
+ 恭喜来自东南大学的任一鸣同学成功入选 开源之夏 "IDE 插件增强和 Language Server 集成" 课题 🎉
+ 为便于 KCL 及其子项目的仓库检索和管理，我们将 KCL 30+ 仓库整体搬迁到了新的 Github **kcl-lang** 组织，牢记项目地址，防止迷路 [https://github.com/kcl-lang](https://github.com/kcl-lang) ❤️
+ KCL 加入 CNCF Landscape，算是云原生社区对我们小小的鼓励和认可，下一步计划是努力加入 CNCF Sadbox，为云原生社区作出更多的贡献 💪

## 下一步计划

预计 2023 年 9 月，我们将发布 **KCL v0.6.0 版本**，预期重点演进包括：

+ 更多针对场景问题的 KCL 语言编写便利性改进，用户界面持续优化与体验提升，用户支持和痛点解决
+ 更多 IDE 插件、语言工具链、包管理工具、Registry 功能支持和用户体验提升
+ 针对云原生场景提供更多开箱即用的 KCL 模型支持，主要包含容器、服务、计算、存储和网络等
+ 更多的 CI/CD 工具集成：如 Jenkins, Gitlab CI, FluxCD 等。
+ 支持 Helmfile KCL 插件，通过 KCL 代码直接生成、编辑和校验 Kubernetes 原生资源
+ 支持在 Kubernetes 运行时通过 KCL Operator 运行代码对 YAML 进行编辑和校验

更多详情请参考 [KCL 2023 路线规划](https://kcl-lang.io/docs/community/release-policy/roadmap) 和 [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)

如果您有更多的想法和需求，欢迎在 KCL Github 仓库发起 [Issues](https://github.com/kcl-lang/kcl/issues)，也欢迎加入我们的社区进行交流 🙌 🙌 🙌

## 常见问题及解答

详见 [KCL 常见问题](https://kcl-lang.io/docs/user_docs/support/faq-kcl)

## 其他资源

感谢所有 KCL 用户和社区小伙伴在此次版本更新过程中提出的宝贵反馈与建议。

更多其他资源请参考：

+ [KCL 网站](https://kcl-lang.io/)
+ [Kusion 网站](https://kusionstack.io/)
+ [KCL Github 仓库](https://github.com/kcl-lang/kcl)
+ [Kusion Github 仓库](https://github.com/KusionStack/kusion)
+ [Konfig Github 仓库](https://github.com/KusionStack/konfig)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/kcl-lang/community](https://github.com/kcl-lang/community)
