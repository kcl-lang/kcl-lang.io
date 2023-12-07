---
slug: 2023-12-07-biweekly-newsletter
title: KCL 社区开源双周报 (2023 11.24 - 12.07) | 如何在 KCL 中使用不同 Kubernetes 配置合并策略?
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**

## 内容概述

感谢所有贡献者过去两周 (2023 11.24 - 12.07) 的杰出工作，以下是重点内容概述

**📦 模型更新**

KCL 模型数量新增至 **240 个**，主要新增与 Crossplane Provider 相关的模型和与 JSON 合并操作相关的库
- KCL JSON Patch 库：_[https://artifacthub.io/packages/kcl/kcl-module/jsonpatch](https://artifacthub.io/packages/kcl/kcl-module/jsonpatch)_
- KCL JSON Merge Patch 库：_[https://artifacthub.io/packages/kcl/kcl-module/json_merge_patch](https://artifacthub.io/packages/kcl/kcl-module/json_merge_patch)_
- KCL Kubernetes Strategy Merge Patch 库：_[https://artifacthub.io/packages/kcl/kcl-module/strategic_merge_patch](https://artifacthub.io/packages/kcl/kcl-module/strategic_merge_patch)_
- KCL Crossplane 及 Crossplane Provider 系列模型：_[https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1&ts_query_web=crossplane](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1&ts_query_web=crossplane)_

**🔧 工具链更新**

- **文档工具更新**
  - 支持模型依赖的三方库的文档生成，比如 `k8s` 模型
- **验证工具更新**
  - 支持验证结果和错误定位到 YAML/JSON 文件，输出错误行列号信息
- **导入工具更新**
  - 支持 OpenAPI `multiplyOf` 规范映射到 KCL `multiplyof` 函数进行校验
  - 支持 YAML Stream 格式的 Kubernetes CRD 文件输出为多个 KCL 文件
  - 优化 KCL 代码生成，去除空的 check 语句

**🏄 SDK 更新**

- 在 KCL 已有 Go 和 Python SDK 的基础上新增 Rust SDK (不需要 LLVM 依赖), 初步包含 KCL 文件编译、校验、测试和格式化代码等 API

**💻 IDE 更新**

- **体验改进**
  - 支持增量解析和异步编译功能，提升性能
- **错误修复**
  - 修复 assert 语句中字符串插值变量不能跳转的异常
  - 修复了字符串中异常触发函数补全的异常
  - 修复 import 语句别名语义检查和补全的异常
  - 修复了 schema 中 check 表达式补全的异常

**📒 文档更新**

- KCL 系统库文档添加索引卡片，一键导航: _[https://kcl-lang.io/docs/reference/model/overview](https://kcl-lang.io/docs/reference/model/overview)_
- KCL CLI 参考文档更新: _[https://kcl-lang.io/docs/tools/cli/kcl/overview](https://kcl-lang.io/docs/tools/cli/kcl/overview)_
- KCL API 参考文档更新: _[https://kcl-lang.io/docs/reference/xlang-api/overview](https://kcl-lang.io/docs/reference/xlang-api/overview)_
- KCL 2023 & 2024 Roadmap 文档: _[https://kcl-lang.io/docs/community/release-policy/roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)_
- Intellij KCL 仓库补充项目结构介绍和 FAQ: _[https://github.com/kcl-lang/intellij-kcl/pull/18](https://github.com/kcl-lang/intellij-kcl/pull/18)_

## 特别鸣谢

以下排名不分先后

- 感谢 @professorabhay 支持 KCL 测试 Diff 功能 🙌
  - _[https://github.com/kcl-lang/kcl/issues/940](https://github.com/kcl-lang/kcl/issues/940)_
- 感谢 @patrycju, @Callum Lyall, @Even Solberg, @Matt Gowie, @ShiroDN 在使用 KCL 过程中的交流与宝贵反馈 🙌

## 精选更新

### 在 KCL 中使用 Kubernetes Strategy Merge Patch 更新配置

在目前的 KCL 版本中支持使用各种**属性运算符**对配置进行更新和覆盖操作，但是能力还比较原子，无法很好地覆盖云原生常规的配置策略场景，对于 Kubernetes 配置，会频繁地使用到 Kubernetes 原生支持的 Json Merge Patch 和 Strategy Merge Patch 能力，比如使用 `kubectl patch`, `kustomize` 和大部分与云原生配置/策略工具开箱支持的 Patch 能力。

因此，为了避免在 KCL 中处理 Kubernetes 配置时反复使用 KCL 属性运算符编写配置 Patch 的模版代码，我们提供了 Kubernetes Strategy Merge Patch 库用于 Kubernetes 配置更新，并且支持所有 Kubernetes 原生对象定义的合并策略，比如列表对象的覆盖，修改和添加等。下面是使用方式

- 新建工程并添加 `Strategy Merge Patch` 库依赖

```shell
kcl mod init && kcl mod add strategic_merge_patch
```

- 在 `main.k` 中编写配置 Patch 代码 (以 `Deployment` 模版的 `labels`, `replicas` 和 `container` 字段为例)

```python
import strategic_merge_patch as s

original = {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
        name = "my-deployment"
        labels.app = "my-app"
    }
    spec: {
        replicas = 3
        template.spec.containers = [
            {
                name = "my-container-1"
                image = "my-image-1"
            }
            {
                name = "my-container-2"
                image = "my-image-2"
            }
        ]
    }
}
patch = {
    apiVersion = "apps/v1"
    kind = "Deployment"
    metadata = {
        name = "my-deployment"
        labels.version = "v1"
    }
    spec: {
        replicas = 4
        template.spec.containers = [
            {
                name = "my-container-1"
                image = "my-new-image-1"
            }
            {
                name = "my-container-3"
                image = "my-image-3"
            }
        ]
    }
}
got = s.merge(original, patch)
```

- 运行命令获得输出

```shell
kcl run
```

输出为

```yaml
original:
  metadata:
    name: my-deployment
    labels:
      app: my-app
  spec:
    replicas: 3
    template:
      spec:
        containers:
        - name: my-container-1
          image: my-image-1
        - name: my-container-2
          image: my-image-2
patch:
  metadata:
    labels:
      version: v1
  spec:
    replicas: 4
    template:
      spec:
        containers:
        - name: my-container-1
          image: my-new-image-1
        - name: my-container-3
          image: my-image-3
got:
  metadata:
    name: my-deployment
    labels:
      app: my-app
      version: v1
  spec:
    replicas: 4
    template:
      spec:
        containers:
        - name: my-container-1
          image: my-new-image-1
        - name: my-container-2
          image: my-image-2
        - name: my-container-3
          image: my-image-3
```

可以看到 `Deployment` 模版的 `labels`, `replicas` 和 `container` 字段都被更新为了正确的值，更多文档和使用方式请查阅 _[https://artifacthub.io/packages/kcl/kcl-module/strategic_merge_patch](https://artifacthub.io/packages/kcl/kcl-module/strategic_merge_patch)_

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。后续我们会发布更多 KCL 云原生模型和工具集成文章，敬请期待! 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
