---
slug: 2023-11-8-biweekly-newsletter
title: KCL 社区开源双周报 (2023 10.26 - 11.8) | 大量体验提升！IDE 插件新增所处补全、更流畅的包管理和开箱即用模型
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言并通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

***KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)***

## 内容概述

感谢所有贡献者过去两周 (2023 10.26 - 11.8) 的杰出工作，以下是重点合并内容概述

**🔧 语言及工具链更新**
- KCL IDE 更新 - 更智能的配置值补全、属性列表补全、函数参数补全、内置包引用补全和 docstring 补全等
- KCL 包管理工具 KPM 更新 - 更流畅的创建、发布 KCL 包的工作流：支持基于版本系统的包更新和发布的自动化流程；此外，现已允许对KCL包的元信息自定义配置
- KCL 模型更新 - 开箱即用的 KCL 模型新增至 120+
- KCL 语言更新 - 优化了 schema 字段类型不匹配的报错信息，支持 lambda 类型注解，以及个别编译问题修复；系统库支持对 JSON/YAML 字符串的验证、序列化和反序列化
- KCL 导入工具发布：支持从 YAML/JSON/CRD/Terraform Schema 一键生成 KCL 配置/模型，实现自动化迁移

## 特别鸣谢

以下排名不分先后

- 感谢 @jakezhu9 对 KCL benchmark 由单线程 Rc 到 Arc 的改进，对 KCL 导入工具中关于引用路径的 bug修复 🙌 *[https://github.com/kcl-lang/kcl-go/pull/170](https://github.com/kcl-lang/kcl-go/pull/170)* 等
- 感谢 @liangyuanpeng 为 KCL 模型贡献 karmada 模型包，欢迎！🙌 *[https://github.com/kcl-lang/artifacthub/pull/48/files](https://github.com/kcl-lang/artifacthub/pull/48/files)*
- 此外，感谢 @Matt Gowie, @ddh 对 KCL 的关注和宝贵反馈 🙌

## 精选更新

### KCL IDE 插件更新

KCL IDE 插件基于新增了大量补全提示，重点针对**配置定义**这一核心环节，简化用户基于模型编写配置的心智、提升配置编辑的效率。此外，增强了调用内置函数时参数补全。talk is cheap，我们直接来看效果：

![](/img/blog/2023-11-08-biweekly-newsletter/config-completion.gif)

而对于**模型设计**环节，也新增了对 docstring 的快速生成，减少手敲 boilerplate：

![](/img/blog/2023-11-08-biweekly-newsletter/docstring-gen.gif)

### KCL 包管理工具

包管理工具现已串联起 KCL 包创建-更新-代码审查-发布的核心工作流，并基于此新增开箱即用的 KCL 模型包至 120+，用户可参照[编写并发布 Kubernetes KCL 代码包](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/publish-modules/) 即刻使用。

### KCL 语言更新

KCL 的编译命令对错误信息的输出优化继续推进，致力于提供清晰易懂的指引，帮助开发者快速定位和修复问题，编写出正确的代码。近期，KCL 优化了 schema 字段类型不匹配的报错信息：

- before:
![](/img/blog/2023-11-08-biweekly-newsletter/schema-expr-type-error-before.png)

- after:
![](/img/blog/2023-11-08-biweekly-newsletter/schema-expr-type-error-after.png)

此外，还支持了 `-—recursive` 选项允许 kcl 递归编译子目录，支持在 lambda 表达式中添加类型注解，系统库支持了对 JSON/YAML 字符串的验证、序列化和反序列化；修复了带有三方库的 KCL 程序缓存失效的问题；修复了编译入库文件跨 kcl.mod 情况下的路径冲突错误；修复 KCL 函数默认值语义检查错误等。

### KCL 导入工具

支持从 YAML/JSON/CRD/Terraform Schema 一键生成 KCL 配置/模型，实现自动化迁移，相关指南请参照[一键从 Kubernetes 生态迁移到 KCL](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/adopt-from-kubernetes)

### 近期活动

#### KCL 开源双周会

近期 KCL 开源双周会将于 11.9 进行，欢迎社区小伙伴踊跃参与、交流：[https://github.com/kcl-lang/community/discussions/10](https://github.com/kcl-lang/community/discussions/10)

点击链接入会，或添加至会议列表：
https://meeting.tencent.com/dm/Hc6sNpqTWnPb

#腾讯会议：778-2381-6338

复制该信息，打开手机腾讯会议即可参与

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。预计 11 月底我们会正式发布 KCL v0.7 新版本，敬请期待!

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)

- [KCL 2023 路线规划](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.7.0 Milestone](https://github.com/kcl-lang/kcl/milestone/7)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
