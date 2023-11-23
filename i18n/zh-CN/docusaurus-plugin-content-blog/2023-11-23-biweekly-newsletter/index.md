---
slug: 2023-11-23-biweekly-newsletter
title: KCL 社区开源双周报 (2023 11.09 - 11.23) | 云原生模型、语言和工具链更新速递!
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

感谢所有贡献者过去两周 (2023 11.09 - 11.23) 的杰出工作，以下是重点内容概述

**📦 模型更新**
- KCL 模型数量新增至 **200 个**，主要新增与 `Pod`, `RBAC` 相关的校验模型及 Kubernetes 1.14-1.28 版本的模型参考文档
- 可以在 `Artifact Hub` 中搜索浏览到所有模型的文档及使用方式: _[https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1)_

**💬 语言更新**
- **体验改进**
  - 优化配置代码块的语法缩进检查，不再强制报错
  - 支持通过文件路径通配符作为编译入口
- **错误修复**
  - 修复部分场景字典类型的类型推导错误
  - 修复 Schema 参数数量的检查

**🔧 工具链更新**
- **测试工具发布**
  - 支持使用 KCL 函数编写单元测试并使用工具执行测试
  - 支持使用正则表达式过滤待测试用例
  - 支持单元测试快速失败功能
- **导入工具更新**
  - 修复 patterns 到正则匹配表达式的生成: _[https://github.com/kcl-lang/kcl-openapi/pull/70](https://github.com/kcl-lang/kcl-openapi/pull/70)_
  - 修复 minItems/maxItems 到字段长度校验规则的生成: _[https://github.com/kcl-lang/kcl-openapi/pull/69](https://github.com/kcl-lang/kcl-openapi/pull/69)_
  - 修复 0 或空字符串为默认值的生成: _[https://github.com/kcl-lang/kcl-openapi/pull/69](https://github.com/kcl-lang/kcl-openapi/pull/69)_
  - 修复 Kubernetes CRD 到 KCL Package 转换中包名的生成为：`${apiVersion}_${kind}`: _[https://github.com/kcl-lang/kcl-openapi/pull/68](https://github.com/kcl-lang/kcl-openapi/pull/68)_
- **包管理工具更新**
  - 新增 update 命令用于自动更新本地依赖: _[https://github.com/kcl-lang/kpm/pull/212](https://github.com/kcl-lang/kpm/pull/212)_

**💻 IDE 更新**
- **体验改进**
  - 支持包管理工具引入的外部包依赖 import 语句补全
- **错误修复**
  - 修复函数参数未定义类型错误显示位置

**🏄 API 更新**
- 新增 KCL 单元测试 API: _[https://github.com/kcl-lang/kcl/pull/904](https://github.com/kcl-lang/kcl/pull/904)_
- 新增 KCL 符号重命名 API: _[https://github.com/kcl-lang/kcl/pull/890](https://github.com/kcl-lang/kcl/pull/890)_

**🔥 架构升级**
- KCL 设计并重构了新的语义模型以及支持最近符号查找和符号语义信息查询 API
- IDE 补全，跳转和悬停等功能实现迁移至新语义模型，显著降低 IDE 功能开发难度和代码量

**🚀 性能提升**
- KCL 编译器支持语法增量解析以及语义增量检查，大部分场景提升 KCL 编译构建和 IDE 插件使用性能 **5-10 倍**

## 特别鸣谢

以下排名不分先后

- 感谢 @cr7258 对 KCL 模型库以及 KCL 文档的贡献 🙌
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/203](https://github.com/kcl-lang/kcl-lang.io/pull/203)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/209](https://github.com/kcl-lang/kcl-lang.io/pull/209)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/210](https://github.com/kcl-lang/kcl-lang.io/pull/210)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/211](https://github.com/kcl-lang/kcl-lang.io/pull/211)_
  - _[https://github.com/kcl-lang/modules/pull/67](https://github.com/kcl-lang/modules/pull/67)_
- 感谢 @XiaoK29 为 KCL IDE 的悬停和引用查找功能代码架构重构以及 KCL 文档的贡献 🙌
  - _[https://github.com/kcl-lang/kcl/pull/887](https://github.com/kcl-lang/kcl/pull/887)_
  - _[https://github.com/kcl-lang/kcl/pull/899](https://github.com/kcl-lang/kcl/pull/899)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/205](https://github.com/kcl-lang/kcl-lang.io/pull/205)_
- 感谢 @MeenuyD, @negz 对 Crossplane KCL Composition Functions 集成的讨论与支持 🙌
  - _[https://github.com/kcl-lang/kcl/issues/885](https://github.com/kcl-lang/kcl/issues/885)_
- 感谢 @kolloch 对 Bazel KCL 构建规则脚本的宝贵反馈 🙌
  - _[https://github.com/kcl-lang/rules_kcl/pull/2](https://github.com/kcl-lang/rules_kcl/pull/2)_
- 感谢 @陆云, @Even Solberg, @Prahalad Ramji @Matt Gowie, @ddh 和 @mouuii 在使用推广 KCL 过程中的交流与宝贵反馈 🙌

## 精选更新

### 在 Artifact Hub 上检索 KCL 代码包及云原生模型

- 通过 k8s 模型编写或者校验 Kubernetes 配置

![](/img/blog/2023-11-23-biweekly-newsletter/k8s-module.png)

- 通过 Open Application Model (OAM) 开放应用模型配合 KubeVela 控制器进行应用发布与运维

![](/img/blog/2023-11-23-biweekly-newsletter/oam-module.png)

- 查找 KCL 代码库如 `jsonpatch` 进行配置操作

![](/img/blog/2023-11-23-biweekly-newsletter/jsonpatch-module.png)

- 通过引入 [KusionStack Modules 模型生态](https://github.com/KusionStack/catalog)并配合 KusionStack 增强客户端的应用交付体验

后续我们会通过一系列文章讲解各个模型更具体使用场景以及工作流程，敬请期待! 200+ 模型的源代码位于 _[https://github.com/kcl-lang/modules](https://github.com/kcl-lang/modules)_，欢迎社区的小伙伴进行共建。❤️

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。预计 11 月底我们会正式发布 KCL v0.7 新版本，敬请期待! 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.7.0 Milestone](https://github.com/kcl-lang/kcl/milestone/7)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
