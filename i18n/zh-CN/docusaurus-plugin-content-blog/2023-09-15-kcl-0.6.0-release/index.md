---
slug: 2023-09-15-kcl-0.6.0-release
title: KCL v0.6.0 重磅发布 - 面向云原生场景更易用的语言、工具链，社区集成和扩展支持
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## 简介

KCL 团队很高兴地宣布 **KCL v0.6.0 新版本现在已经可用**！本次发布为大家带来了三方面的重点更新：**语言**、**工具链**、**社区集成 & 扩展支持**。

- _使用功能更完善错误更少的 KCL 语言、工具链和 IDE 提升代码编写体验和效率_
- _使用包管理 KPM 和 OCI Registry 等工具直接使用和共享您的云原生领域模型，降低学习和上手成本_
- _使用 Helmfile KCL 插件和 KCL Operator 等云原生集成扩展同时支持在客户端和运行时对 Kubernetes 资源进行原地修改和验证，避免配置硬编码_

进一步您可以在 [KCL v0.6.0 发布页面](https://github.com/kcl-lang/kcl/releases/tag/v0.6.0) 或者 [KCL 官方网站](https://kcl-lang.io) 获得下载安装指南和详细发布信息。

[KCL](https://github.com/kcl-lang/kcl) 是一个面向云原生领域开源的基于约束的记录及函数编程语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于围绕配置的模块化、扩展性和稳定性，打造更简单的逻辑编写体验，构建更简单的自动化和生态集成路径。

本文重点介绍 KCL v0.6.0 版本的更新内容以及 KCL 社区的近期动态。

## 语言更新

### 🔧 类型系统增强

支持 KCL 配置块属性类型自动推导，在 KCL v0.6.0 版本之前，下述代码中的 `key1` 和 `key2` 属性会被类型系统推导为 `str | int` 类型，版本更新之后，我们进一步增强了配置属性的类型精确推导，`key1` 和 `key2` 属性会获得范围更小更精确的对应类型

```python
config = {
    key1 = "value1"
    key2 = 2
}
key1 = config.key1  # key1 的类型为 str
key2 = config.key2  # key2 的类型为 int
```

此外，我们优化了 Schema 语义检查和联合类型检查等错误信息以及系统库函数的类型检查错误信息。

更多信息[详见](https://github.com/kcl-lang/kcl/pull/678)

### 🏄 API 更新

- KCL Schema 模型解析 GetSchemaType API 获取 KCL 包相关信息和 Schema 属性默认值

### 🐞 错误修复

#### KCL 必选属性检查错误修复

在之前的 KCL 版本中，KCL 必选属性检查会遗漏嵌套的 Schema 属性检查，在 KCL v0.6.0 版本中，我们修复了此类类似的问题

```python
schema S:
    a: int
    b: str

schema L:
    # 在之前的版本中，会遗漏 [S] 和 {str:S} 中的 S 的 a, b 属性必选检查
    # 在 KCL v0.6.0 版本之后，我们修复了此类问题
    ss?: [S]
    sss?: {str:S}

l = L {
    ss = [S {b = "b"}]
}
```

更多信息[详见](https://github.com/kcl-lang/kcl/pull/672)

## IDE & 工具链更新

### IDE 更新

#### 功能更新

- 跳转性能大幅度提升，支持毫秒级跳转
- 支持 KCL 包中的变量以及 Schema 属性补全
- 支持 KCL Schema 属性文档属性悬停提示
- 支持无用 Import 语句快速修复

![ide-quick-fix](/img/blog/2023-09-15-kcl-0.6.0-release/ide-quick-fix.png)

- 支持右键格式化文件和代码片段

![ide-format](/img/blog/2023-09-15-kcl-0.6.0-release/ide-format.png)

- 支持内置函数和系统库中函数信息的悬停提示

![ide-func-hover](/img/blog/2023-09-15-kcl-0.6.0-release/ide-func-hover.png)

#### 更多 IDE 支持

我们将 KCL 语言服务器 LSP 集成到了 NeoVim 和 Idea 中，使得可以在 NeoVim 和 IntelliJ IDEA 中体验到和 VS Code IDE 支持的补全、跳转和悬停等功能

- NeoVim KCL 插件

![kcl.nvim](/img/docs/tools/Ide/neovim/overview.png)

- IntelliJ 插件

![intellij](/img/docs/tools/Ide/intellij/overview.png)

更多 IDE 插件下载安装方式和功能说明可参考：

- https://kcl-lang.io/docs/user_docs/getting-started/install#neovim
- https://kcl-lang.io/docs/user_docs/getting-started/install#intellij-idea

### KCL 格式化工具更新

支持对缩进不正确的配置块进行格式化

- 格式化前

```python
config = {
a ={
x = 1
 y =2
}
b = {
 x = 1
 y = 2
}
}
```

- 格式化后

```python
config = {
    a = {
        x = 1
        y = 2
    }
    b = {
        x = 1
        y = 2
    }
}
```

### KCL 文档工具更新

- 新增 Markdown 文档导出支持
- 支持导出文档索引页
- 支持导出文档自定义样式模版
- 支持导出文档 HTML 转义
- 文档生成增强，支持对文档注释中示例代码片段的解析和渲染
- 通过在 Github workflow 中跟踪模型的更新，并重新生成文档，即可实现文档的自动同步。具体参考: https://github.com/KusionStack/catalog/pull/31/files

#### 从 kpm 包生成模型文档

1. 创建 kpm 包，为其中的 Service 模型添加文档注释（使用 docstring 表示）。在文档中可以包含对模型和属性的说明、示例代码和用法等，以帮助其他开发人员快速上手并正确地使用。

```

➜ kpm init demo

➜ cat > demo/server.k << EOF
schema Service:
    """
    Service is a kind of workload profile that describes how to run your application code. This
    is typically used for long-running web applications that should "never" go down, and handle
    short-lived latency-sensitive web requests, or events.

    Attributes
    ----------
    workloadType : str = "Deployment" | "StatefulSet", default is Deployment, required.
        workloadType represents the type of workload used by this Service. Currently, it supports several
        types, including Deployment and StatefulSet.
    image : str, default is Undefined, required.
        Image refers to the Docker image name to run for this container.
        More info: https://kubernetes.io/docs/concepts/containers/images
    replicas : int, default is 2, required.
        Number of container replicas based on this configuration that should be ran.

    Examples
    --------
    # Instantiate a long-running service and its image is "nginx:v1"

    svc = Service {
        workloadType: "Deployment"
        image: "nginx:v1"
        replica: 2
    }
    """
    workloadType: "Deployment" | "StatefulSet"
    image: str
    replica: int
EOF

```

2. 生成 Markdown 格式的包文档：
   以下命令将 demo 包文档输出到当前工作目录下的 doc/ 目录：

```
kcl-go doc generate --file-path demo
```

![docgen](/img/blog/2023-09-15-kcl-0.6.0-release/docgen.png)

> 更多使用方式请通过 `kcl-go doc generate -h` 查看

1. 通过流水线实现文档的自动同步

通过在 Github workflow 中跟踪模型的更新，并重新生成文档，即可实现文档的自动同步。可参照 [Kusionstack/catalog](https://github.com/KusionStack/catalog/pull/31/files) 中的做法，生成文档并自动向文档仓库提交变更 PR。

### KCL 导入工具更新

在 KCL v0.6.0 版本，KCL 导出 Import 工具新增支持了 JsonSchema, Terraform Provider Schema, Go 结构体 转换为 KCL，以及一键支持 JSON/YAML 配置数据转换为 KCL 配置代码，比如对于如下的 Terraform Provider Json (通过 `terraform providers schema -json > provider.json` 命令获得，详情请参考 [https://developer.hashicorp.com/terraform/cli/commands/providers/schema](https://developer.hashicorp.com/terraform/cli/commands/providers/schema))

```json
{
  "format_version": "0.2",
  "provider_schemas": {
    "registry.terraform.io/aliyun/alicloud": {
      "provider": {
        "version": 0,
        "block": {
          "attributes": {},
          "block_types": {},
          "description_kind": "plain"
        }
      },
      "resource_schemas": {
        "alicloud_db_instance": {
          "version": 0,
          "block": {
            "attributes": {
              "db_instance_type": {
                "type": "string",
                "description_kind": "plain",
                "computed": true
              },
              "engine": {
                "type": "string",
                "description_kind": "plain",
                "required": true
              },
              "security_group_ids": {
                "type": ["set", "string"],
                "description_kind": "plain",
                "optional": true,
                "computed": true
              },
              "security_ips": {
                "type": ["set", "string"],
                "description_kind": "plain",
                "optional": true,
                "computed": true
              },
              "tags": {
                "type": ["map", "string"],
                "description_kind": "plain",
                "optional": true
              }
            },
            "block_types": {},
            "description_kind": "plain"
          }
        },
        "alicloud_config_rule": {
          "version": 0,
          "block": {
            "attributes": {
              "compliance": {
                "type": [
                  "list",
                  [
                    "object",
                    {
                      "compliance_type": "string",
                      "count": "number"
                    }
                  ]
                ],
                "description_kind": "plain",
                "computed": true
              },
              "resource_types_scope": {
                "type": ["list", "string"],
                "description_kind": "plain",
                "optional": true,
                "computed": true
              }
            }
          }
        }
      },
      "data_source_schemas": {}
    }
  }
}
```

经过 KCL Import 工具可以输出为如下 KCL 代码

```python
"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""

schema AlicloudConfigRule:
    """
    AlicloudConfigRule

    Attributes
    ----------
    compliance: [ComplianceObject], optional
    resource_types_scope: [str], optional
    """

    compliance?: [ComplianceObject]
    resource_types_scope?: [str]

schema ComplianceObject:
    """
    ComplianceObject

    Attributes
    ----------
    compliance_type: str, optional
    count: int, optional
    """

    compliance_type?: str
    count?: int

schema AlicloudDbInstance:
    """
    AlicloudDbInstance

    Attributes
    ----------
    db_instance_type: str, optional
    engine: str, required
    security_group_ids: [str], optional
    security_ips: [str], optional
    tags: {str:str}, optional
    """

    db_instance_type?: str
    engine: str
    security_group_ids?: [str]
    security_ips?: [str]
    tags?: {str:str}

    check:
        isunique(security_group_ids)
        isunique(security_ips)
```

### 包管理工具 KPM 更新

#### kpm pull 支持通过包名拉取 kcl package

kpm 支持通过 kpm pull <package_name>:<package_version> 的方式拉取对应的包。
以 `k8s`包为例，你可以通过以下命令直接下载对应的包到本地。

```
kpm pull k8s
```

或者

```
kpm pull k8s:1.27
```

kpm pull 下载的包，将会为您保存在 `执行命令的目录/<oci registry>/<package_name>`目录下, 以 kpm 默认的 registry 为例，在使用 `kpm pull k8s`命令后，您能在`执行命令的目录/ghcr.io/kcl-lang/k8s`目录下找到您下载的内容。

```
$ tree ghcr.io/kcl-lang/k8s -L 1

ghcr.io/kcl-lang/k8s
├── api
├── apiextensions_apiserver
├── apimachinery
├── kcl.mod
├── kcl.mod.lock
├── kube_aggregator
└── vendor

6 directories, 2 files
```

#### kpm 支持添加本地路径作为依赖

"不同的项目对应的 KCL 包不一样，他们之间存在依赖关系，但是他们保存在不同的目录下，我希望这些保存在不同目录下的包能够被统一管理起来，而不是只有把他们放在一起他们才能通过编译。" 如果您也有这样的需求，您可以来试试这个功能。kpm add 目前支持将本地路径作为依赖添加到 kcl 包中，您只需要`kpm add <local_package_path>`这样的命令，便可以将您本地的包作为三方库添加到当前包的依赖中。

```shell
kpm pull k8s
```

完成后您可以在 “执行命令的目录/ghcr.io/kcl-lang/k8s” 找到下载的 k8s 包。
使用 kpm init mynginx 命令，创建一个新的 kcl 包。

```shell
kpm init mynginx
```

然后，进入这个包内

```shell
cd mynginx
```

在这个包内，您可以使用 kpm add 命令将您刚才下载到本地的 k8s 包作为三方库添加到 mynginx 的依赖中。

```shell
kpm add ../ghcr.io/kcl-lang/k8s/
```

接下来为 main.k 添加如下内容

```shell
import k8s.api.core.v1 as k8core

k8core.Pod {
    metadata.name = "web-app"
    spec.containers = [{
        name = "main-container"
        image = "nginx"
        ports = [{containerPort: 80}]
    }]
}
```

通过 kpm run 可以进行正常的编译

```shell
kpm run
```

#### kpm 增加对已经存在的包 tag 进行检查

kpm push 中增加了对 tag 重复的检查，为了避免出现相同 tag 的包存在不同的内容的情况，我们在 kpm 中增加了对 push 功能的限制，如果您 push 的 kcl 包的版本已经存在，那么，您将无法 push 当前的 kcl 包。您将会得到如下信息：

```shell
kpm: package 'my_package' will be pushed.
kpm: package version '0.1.0' already exists
```

对一个已经 push 到 Registry 中的 kcl 包，在不改变 tag 的情况下改动包的内容，会产生很大的风险，因为这个包有可能已经被其他人使用了，因此，如果您需要 push 您的包，我们建议

- 变更您的 tag, 并且建议您遵守语义化版本的规范。
- 如果迫不得已需要在 tag 不能变更的情况下改变包的内容，您只能到 Registry 上删除已有的 tag。

## 社区集成 & 扩展更新

### Helmfile KCL 插件

Helmfile 是用于部署 Helm Chart 的声明性规范和工具，通过 Helmfile KCL 插件您可以

- 通过无侵入的 Hook 方式编辑或者验证 Helm Chart 配置，将 Kubernetes 配置管理的数据部分和逻辑部分分离
  - 修改资源标签/注解, 注入 Sidecar 容器配置
  - 使用 KCL Schema 校验资源，定义自己的抽象模型并分享复用
- 优雅地维护多环境、多租户场景配置，而不是简单地复制粘贴

下面以一个简单示例进行详细说明，使用 Helmfile KCL 插件无需您安装与 KCL 任何相关的组件，只需本机具备 Helmfile 工具的最新版本即可。

我们可以编写一个如下所示 `helmfile.yaml` 文件

```yaml
repositories:
- name: prometheus-community
  url: https://prometheus-community.github.io/helm-charts

releases:
- name: prom-norbac-ubuntu
  namespace: prometheus
  chart: prometheus-community/prometheus
  set:
  - name: rbac.create
    value: false
  transformers:
  # Use KCL Plugin to mutate or validate Kubernetes manifests.
  - apiVersion: krm.kcl.dev/v1alpha1
    kind: KCLRun
    metadata:
      name: "set-annotation"
      annotations:
        config.kubernetes.io/function: |
          container:
            image: docker.io/kcllang/kustomize-kcl:v0.2.0
    spec:
      source: |
        [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "helmfile-kcl"}} for resource in option("resource_list").items]
```

在上述配置中，我们引用了 Prometheus Helm Chart, 并通过一行 KCL 代码就可以完成 Prometheus 的所有的 Deployment 资源注入标签 `managed-by="helmfile-kcl"`，通过如下命令我们可以将上述配置下发到集群

```shell
helmfile apply
```

更多用例可以参考[这里](https://github.com/kcl-lang/krm-kcl)

### KCL Operator

KCL Operator 提供了 Kubernetes 集群集成，允许您在将资源应用到集群时使用 Access Webhook 根据 KCL 配置生成、变异或验证资源。Webhook 将捕获创建、应用和编辑操作，并 `KCLRun` 在与每个操作关联的配置上执行资源，比如可以使用 KCL 语言完成如下功能

- 使用 KCL 对资源进行修改，如根据某个条件添加/修改 label 标签或 annotation 注释或在包含 PodTemplate 的所有 Kubernetes Resource Model (KRM) 资源中注入 Sidecar 容器配置等。
- 使用 KCL Schema 验证所有 KRM 资源，如约束只能以 Root 方式启动容器等。
- 使用抽象模型生成 KRM 资源或者对不同的 KRM API 进行组合并使用。

下面以一个简单的资源 annotation 注解修改示例介绍 KCL Operator 的使用方式

#### 0.前置条件

通过 k3d 等工具准备一个 Kubernetes 集群以及 kubectl 工具

#### 1. 安装 KCL Operator

```shell
kubectl apply -f https://raw.githubusercontent.com/kcl-lang/kcl-operator/main/config/all.yaml
```

使用以下命令观察并等待 pod 状态为 Running。

```shell
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

![registry](/img/blog/2023-09-15-kcl-0.6.0-release/registry.png)

此外，我们已经在 KCL 官方 Registry 中开箱提供了多达 30 个内置模型可以允许您在轻易完成对已有 Kubernetes 资源的编辑、校验和抽象。

比如使用 web-service 模型直接实例化出一个 web 应用所需的 Kubernetes 资源；使用 set-annotation 模型对已有的 k8s 资源添加 annotation；使用 https-only 模型校验您的 Ingress 配置只能设置为 https, 否则报错。

https://github.com/kcl-lang/krm-kcl/tree/main/examples

### Vault 集成

仅需三步，我们就可以使用 Vault 来存储并管理敏感信息并在 KCL 中使用。

首先我们安装并使用 Vault 存储 `foo` 和 `bar` 信息

```shell
vault kv put secret/foo foo=foo
vault kv put secret/bar bar=bar
```

然后编写如下 KCL 代码 (main.k)

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
    annotations: {
        "secret-store": "vault"
        # Valid format:
        #  "ref+vault://PATH/TO/KV_BACKEND#/KEY"
        "foo": "ref+vault://secret/foo#/foo"
        "bar": "ref+vault://secret/bar#/bar"
    }
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

最后可以通过 Vals 命令行工具获得解密后的配置

```shell
kcl main.k | vals eval -f -
```

更多详情和用例可以参考 [https://kcl-lang.io/docs/user_docs/guides/secret-management/vault](https://kcl-lang.io/docs/user_docs/guides/secret-management/vault)

### GitLab CI 集成

在之前的文章中，我们提到了使用 Github Action 作为 CI 通过 GitOps 方式进行应用发布，此次版本中我们进一步提供了 GitLab CI 集成，用例详情可参考：_[https://kcl-lang.io/docs/user_docs/guides/ci-integration/gitlab-ci](https://kcl-lang.io/docs/user_docs/guides/ci-integration/gitlab-ci)_

## 其他更新与错误修复

完整更新和错误修复列表[详见](https://github.com/kcl-lang/kcl/compare/v0.5.0...v0.6.0)

## 文档更新

[KCL 网站](https://kcl-lang.io/) 新增 KCL v0.6.0 文档内容并支持版本化语义选项，目前支持 v0.4.x, v0.5.x 和 v0.6.0 版本选择，同时欢迎社区同学进行文档共建。

## 社区动态

- 感谢 @jakezhu9 对 KCL Import 工具包括 Terraform Provider Schema, JsonSchema, Json, YAML 等配置格式/数据到 KCL Schema/配置的转换 🙌
- 感谢 @xxmao123 对 KCL LSP 语言服务器接入到 Idea IDE 插件的贡献 🙌
- 感谢 @starkers 对 KCL NeoVim 插件的贡献 🙌
- 感谢 @starkers 对 mason.nvim registry 增加 KCL 的安装支持 🙌
- 感谢 @Ekko 对 KCL 云原生工具集成以及 KCL Operator 的贡献 🙌
- 感谢 @prahaladramji 对 KCL Homebrew 安装脚本的升级更新与贡献 🙌
- 感谢 @yyxhero 在 Helmfile KCL 插件支持中提供的帮助与支持 🙌
- 感谢 @nkabir, @mihaigalos, @prahaladramji, @yamin-oanda, @dhhopen,@magick93, @MirKml, @kolloch, @steeling 等在过去两个月使用 KCL 过程中提出的宝贵反馈和讨论 🙌

## 常见问题及解答

详见 [KCL 常见问题](https://kcl-lang.io/docs/user_docs/support/faq-kcl)

## 其他资源

感谢所有 KCL 用户和社区小伙伴在此次版本更新过程中提出的宝贵反馈与建议。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [Kusion 网站](https://kusionstack.io/)
- [KCL GitHub 仓库](https://github.com/kcl-lang/kcl)
- [Kusion GitHub 仓库](https://github.com/KusionStack/kusion)

欢迎加入我们的社区进行交流 👏👏👏：[https://github.com/kcl-lang/community](https://github.com/kcl-lang/community)
