---
slug: 2023-09-06-biweekly-newsletter
title: KCL 社区开源双周报 (2023 08.24 - 09.06) | Kubernetes Operator，IDE 插件和 v0.5.6 版本正式发布!
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个开源的基于约束的记录及函数语言并通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

***KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)***

## 内容概述

感谢所有贡献者过去两周 (2023 08.24 - 09.06) 的杰出工作，以下是重点合并内容概述

**🔧 语言及工具链更新**

- KCL 导入工具更新 - 支持由 JSON/YAML 数据导出为 KCL 配置
- KCL IDE 更新 - 支持右键一键格式化能力，支持直接格式化单个文件或部分 KCL 代码
- KCL 文档工具更新 - 导出文档支持 HTML 转义
- KCL 包管理工具 KPM 更新 - kpm run 运行命令以及错误信息优化，支持直接运行位于本地路径的 KCL 包
- KCL 语言更新 - 优化系统库类型检查等错误信息及错误信息代码统一

**📰 官网和用例更新**

- KCL 官网新增 v0.5.6 文档版本
- 新增通过 Github Action 发布 KCL 代码包直接发布到 docker.io 和 ghcr.io 等 Registry 用例: *[https://github.com/kcl-lang/kpm/blob/main/docs/push_by_github_action.md](https://github.com/kcl-lang/kpm/blob/main/docs/push_by_github_action.md)*
- 新增 KCL Operator 集成用例: *[https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/mutate-manifests/kcl-operator](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/mutate-manifests/kcl-operator)*

## 特别鸣谢

以下排名不分先后

- 感谢 @jakezhu9 对 KCL Import 工具 JSON 和 YAML 配置数据到 KCL 配置块转换的贡献 🙌 *[https://github.com/kcl-lang/kcl-go/pull/141](https://github.com/kcl-lang/kcl-go/pull/141)*
- 感谢 @xxmao123 和 @starkers 对 KCL NeoVim 以及 Idea IDE 插件的贡献 🙌 *https://github.com/kcl-lang/intellij-kcl/pull/12*
- 此外感谢 @kolloch, @prahaladramji 等在过去两周使用 KCL 过程中提出的宝贵反馈和讨论 🙌

**祝贺 @jakezhu9 祝贺 jakezhu9 成为 KCL 社区 Maintainer** 🎉

## 精选更新

### KCL Operator

KCL Operator 提供了 Kubernetes 集群集成，允许您在将资源应用到集群时使用 Access Webhook 根据 KCL 配置生成、变异或验证资源。Webhook 将捕获创建、应用和编辑操作，并 `KCLRun` 在与每个操作关联的配置上执行资源，比如可以使用 KCL 语言完成如下功能

+ 使用 KCL 对资源进行修改，如根据某个条件添加/修改 label 标签或 annotation 注释或在包含 PodTemplate 的所有 Kubernetes Resource Model (KRM) 资源中注入 Sidecar 容器配置等。
+ 使用 KCL Schema 验证所有 KRM 资源，如约束只能以 Root 方式启动容器等。
+ 使用抽象模型生成 KRM 资源或者对不同的 KRM API 进行组合并使用。

使用 KCL Operator, 通过几个步骤您就可以在 Kubernetes 集群内部以很轻量的方式地通过 KCL 代码自动化地完成资源配置的管理和安全验证，无需重复开发 Webhook Server 在运行时动态修改和验证配置。

此外借助 KCL 良好的建模和抽象能力，我们可以为不同的资源 API 定义进行功能抽象/组合并以 KCL Schema 的形式对外透出，并且可以由 KCL Schema 进一步自动生成 OpenAPI Schema 定义供集群其他客户端调用，而无需为 API 抽象/组合手动维护复杂的 OpenAPI Schema 定义。

下面以一个简单的资源 annotation 注解修改示例介绍 KCL Operator 的使用方式

#### 0.前置条件

通过 k3d 等工具准备一个 Kubernetes 集群以及 kubectl 工具

#### 1. 安装 KCL Operator

```shell
kubectl apply -f https://raw.githubusercontent.com/kcl-lang/kcl-operator/main/config/all.yaml
```

使用以下命令观察并等待 pod 状态为 Running。

```
kubectl get po
```

#### 2. 部署注解修改模型

```shell
kubectl apply -f- << EOF
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
spec:
  # 设置注解修改模型所需的动态参数，在此处我们可以添加我们想要修改/添加的标签
  params:
    annotations:
      managed-by: kcl-operator
  # 引用 OCI 上注解修改模型
  source: oci://ghcr.io/kcl-lang/set-annotation
EOF
```

#### 3. 部署一个 Pod 资源验证模型结果

执行如下命令部署一个 Pod 资源

```shell
kubectl apply -f- << EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  annotations:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
EOF
kubectl get po nginx -o yaml | grep kcl-operator
```

我们可以看到如下输出

```shell
    managed-by: kcl-operator
```

我们可以发现 Nginx Pod 上自动添加了 `managed-by=kcl-operator` 注解

此外，除了为 `KCLRun` 资源 `source` 字段引用已有的模型，我们可以直接为 `source` 字段设置 KCL 代码也可以达到同样的效果，比如

```yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
spec:
  params:
    annotations:
      managed-by: kcl-operator
  # 仅通过一行 KCL 代码就可完成资源的修改
  source: |
    items = [item | {metadata.annotations: option("params").annotations} for item in option("items")]
```

我们已经开箱提供了多达 30+ 的内置模型，您可以在下面的链接中获得更多代码示例

https://github.com/kcl-lang/krm-kcl/tree/main/examples

### KCL IDE 插件更新

过去两周，我们将 KCL 语言服务器 LSP 集成到了 NeoVim 和 Idea 中，使得可以在 NeoVim 和 IntelliJ IDEA 中体验到和 VS Code IDE 支持的补全、跳转和悬停等功能

+ NeoVim KCL 插件

![kcl.nvim](/img/docs/tools/Ide/neovim/overview.png)

+ IntelliJ 插件

![intellij](/img/docs/tools/Ide/intellij/overview.png)

更多 IDE 插件下载安装方式和功能说明可参考：

+ https://kcl-lang.io/docs/user_docs/getting-started/install#neovim
+ https://kcl-lang.io/docs/user_docs/getting-started/install#intellij-idea

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。预计 9 月中旬我们会正式发布 KCL v0.6 新版本，敬请期待!

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)

- [KCL 2023 路线规划](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
