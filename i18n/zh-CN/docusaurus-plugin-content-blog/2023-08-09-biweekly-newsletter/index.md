---
slug: 2023-08-09-biweekly-newsletter
title: KCL 社区开源双周报 (2023 07.26 - 08.09) | KCL 0.5.1 和 0.5.2 版本正式发布
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个开源的基于约束的记录及函数语言并通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**

## 内容概述

过去两周 (2023 07.26 - 08.09)，KCL 所有项目中总计有 **34** 个 PR 被合并，感谢所有贡献者的杰出工作，以下是重点合并内容概述

- **🔧 语言及工具链更新**
  - KCL Doc 文档工具新增 Markdown 文档导出支持
  - KCL Import 导入工具更新 - 支持 JsonSchema 转换为 KCL Schema
  - KCL 包管理工具 KPM 支持在 kcl.mod 中设置编译参数，优化命令行提示信息
  - KCL IDE 插件优化补全、跳转和悬停文档显示等功能，并支持 NeoVim 编辑器
- **🏄 API 更新**
  - KCL Schema 模型解析 GetSchemaType API 新增装饰器信息和包信息字段
- **🏠 社区扩展更新**
  - Helmfile KCL 插件支持
- **📰 官网和用例更新**
  - KCL 官网新增 v0.5.x 文档版本选择
  - 新增 KCL 用例仓库: *[https://github.com/kcl-lang/examples](https://github.com/kcl-lang/examples)*

## 特别鸣谢

- 感谢 @jakezhu9 对 KCL Import 工具 JsonSchema 转换的贡献 🙌
- 感谢 @xxmao123 对 Vim 和 NeoVim KCL 插件的贡献 🙌
- 感谢 @yyxhero 在 Helmfile KCL 插件支持中提供的帮助与支持 🙌
- 感谢 @nkabir, @mihaigalos, @prahaladramji, @dhhopen 等在使用 KCL 过程中提出的宝贵建议和讨论 🙌

## 精选更新

### KCL Import 工具更新

KCL Import 工具在 Protobuf, OpenAPI 模型和 Go 结构体转换为 KCL Schema 的基础上，新增 JsonSchema 到 KCL Schema 的转换支持，比如对于如下的 JsonSchema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://example.com/schemas/customer.json",
  "type": "object",
  "$defs": {
    "address": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string"
        },
        "state": {
          "$ref": "#/$defs/state"
        }
      }
    },
    "state": {
      "type": "object",
      "properties": {
        "name": {
          "type": "string"
        }
      }
    }
  },
  "properties": {
    "name": {
      "type": "string"
    },
    "address": {
      "$ref": "#/$defs/address"
    }
  }
}
```

经过 KCL Import 工具可以输出为如下 KCL 代码

```kcl
schema Customer:
    """
    Customer

    Attributes
    ----------
    name: str, optional
    address: Address, optional
    """

    name?: str
    address?: Address

schema Address:
    """
    Address

    Attributes
    ----------
    city: str, optional
    state: State, optional
    """

    city?: str
    state?: State

schema State:
    """
    State

    Attributes
    ----------
    name: str, optional
    """

    name?: str
```

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

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。后续我们会撰写更多 KCL v0.5.x 新版本功能解读系列文章，敬请期待!

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)

- [KCL 2023 路线规划](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
- [KCL v0.5.0 Release](https://github.com/kcl-lang/kcl/releases/tag/v0.5.0)
- [KCL v0.5.1 Release](https://github.com/kcl-lang/kcl/releases/tag/v0.5.1)
- [KCL v0.5.2 Release](https://github.com/kcl-lang/kcl/releases/tag/v0.5.2)
