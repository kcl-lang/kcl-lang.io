---
slug: 2023-12-21-biweekly-newsletter
title: KCL 社区开源双周报 (2023 12.07 - 12.21) | KCL v0.7.2 发布和 KubeVela/OAM 集成
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

感谢所有贡献者过去两周 (2023 12.07 - 12.21) 的杰出工作，以下是重点内容概述

**📦 模型更新**

KCL 模型数量新增至 **300 个**，增加了 k8s 1.29 版本的 KCL 模型。

**🔧 工具链更新**

- **导入工具更新**

  - 导入工具支持 OpenAPI allOf 关键字校验表达式生成
  - 导入工具支持 KCL 数组和字典类型的 all/any 校验表达式生成
  - 导入工具修复 JSON Schema 数组生成 KCL 代码片段错误及字符串转义错误

- **🏄 包管理工具更新**
  - 增加对名称中包含横线的三方库的支持。
  - 修复了 update 功能无法自动通过 kcl.mod 和 kcl.mod.lock 的问题。

**💻 KCL 更新**

- KCL 编译缓存路径支持使用环境变量 KCL_CACHE_PATH 指定
- 修复了 KCL CLI 使用编译参数 -S 可能会导致的编译错误
- 修复了 kcl fmt 工具对 lambda 表达式进行格式化时，结尾增加一个空行的错误。
- 修复 Schema Doc 补全代码片段错误

**📒 IDE 更新**

- 修复了 check 语句中变量补全失效的问题
- VSCode Extension 更新至 0.1.3 版本，更新了部分关键字的高亮和补全
- 新增了 builtin 函数的补全
- 优化了函数补全的样式

## 精选更新

### 实现高效云原生应用部署运维 - KCL 与 KubeVela 快速集成指南

KCL 建立在一个完全开放的云原生世界当中，不与任何编排/引擎工具或者 Kubernetes 控制器绑定，可以同时为 Kubernetes 客户端和运行时提供 API 抽象、组合和校验的能力。用户可以根据场景选择合适的云原生工具比如 Kubectl, Helm, Kustomize, KPT, KusionStack, KubeVela, Helmfile, Crossplane 或 ArgoCD 等来和 KCL 结合将配置生效到集群。

KubeVela 是一个 CNCF 基金会托管的现代的应用交付系统，它基于 Open Application Model（OAM）规范构建，旨在屏蔽 Kubernetes 的复杂性，提供一套简单易用的命令行工具和 APIs，让开发者无需关心底层细节即可部署和运维云原生应用。

通过结合 KCL 与 KubeVela，可以为 KubeVela OAM 配置提供更强的模版化能力如条件，循环等，减少样板 YAML 书写，同时复用 KCL 模型库和工具链生态，提升配置及策略编写的体验和管理效率。

并且，相较于围绕 YAML 进行配置，通过 KCL 可以提供更有利于版本控制和团队协作的配置文件结构，搭配 KCL 编写的 OAM 应用模型，可以使得应用配置更易于维护和迭代。

结合 KCL 的配置简洁性和 KubeVela 的易用性，还可以简化日常的操作任务，比如部署更新、扩展或回滚应用。可以使开发者可以更加专注于应用本身，而不是部署过程中的繁琐细节。

通过 KCL 配置分块编写以及包管理能力与 KubeVela 结合使用，可以定义更清晰的界限，使得不同的团队（如开发、测试和运维团队）可以有条理地协作。每个团队可以专注于其职责范围内的任务，分别交付、分享和复用各自的配置，而不用担心其他方面的细节。

以 KCL Playground 应用为例（这是使用 Go 和 HTML5 编写的应用）展示如何使用 KCL 定义需要部署的 OAM 配置，并通过 KubeVela 发布应用配置。

- 准备工作

  - 配置 Kubernetes 集群
  - 安装 KubeVela
  - 安装 KCL

- 新建工程并添加 OAM 库依赖

```
kcl mod init kcl-play-svc && cd kcl-play-svc && kcl mod add oam
```

- 在 main.k 中编写代码

```
import oam

oam.Application {
    metadata.name = "kcl-play-svc"
    spec.components = [{
        name = metadata.name
        type = "webservice"
        properties = {
            image = "kcllang/kcl:v0.9.0"
            ports = [{port = 80, expose = True}]
            cmd = ["kcl", "play"]
        }
    }]
}
```

- 运行命令下发配置

```
kcl run | vela up -f -
```

- 端口转发

```
vela port-forward kcl-play-svc
```

然后我们可以在浏览器中看到 KCL Playground 应用成功运行

![kcl-play-svc](/img/blog/2023-12-15-kubevela-integration/kcl-play-svc.png)

### IDE 优化了函数补全的样式

![ide-func](/img/blog/2023-12-21-biweekly-newsletter/ide-func.gif)

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。后续我们会发布更多 KCL 云原生模型和工具集成文章，敬请期待! 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
