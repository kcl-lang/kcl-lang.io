---
slug: 2023-10-25-biweekly-newsletter
title: KCL 社区开源双周报 (2023 10.12 - 10.25) | IDE 插件支持引用查找、包管理集成 ArtifactHub
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

感谢所有贡献者过去两周 (2023 10.12 - 10.25) 的杰出工作，以下是重点合并内容概述

**🔧 语言及工具链更新**
- KCL IDE 更新 - 支持对符号的引用跳转和重命名；优化了引用语句和 union 类型的格式化输出；修复了文件变更引发语言服务崩溃的问题
- KCL 包管理工具 KPM 更新 - kpm 正在集成 AritifactHub，支持将 KCL 包发布到 ArtifactHub
- KCL 语言更新 - 优化了方法的参数类型不匹配等报错信息，明确指出了不匹配的类型
- KCL 命令行统一界面 - 重新设计了 KCL 相关工具的命令行统一界面和工作流，进入实现阶段

## 特别鸣谢

以下排名不分先后

- 感谢 @jakezhu9 对 KCL 语法解析单元测试的改进，将部分测试用例统一迁移到使用 snaptest 框架 🙌 *[https://github.com/kcl-lang/kcl/pull/794](https://github.com/kcl-lang/kcl/pull/794)* 等
- 感谢 @opsnull 对 KCL 官网文档中代码示例的纠错和贡献 🙌 *[https://github.com/kcl-lang/kcl-lang.io/pull/182](https://github.com/kcl-lang/kcl-lang.io/pull/182)*
- 感谢 @prahaladramji 对 KCL IntelliJ 插件格式化功能的纠错和优化 🙌 *[https://github.com/kcl-lang/intellij-kcl/pull/15](https://github.com/kcl-lang/intellij-kcl/pull/15)*
- 感谢 @steeling, @prahaladramji, @liangyuanpen, @Kory Taborn 等在使用 KCL 及工具链过程中提出的宝贵反馈和讨论 🙌

## 精选更新

### KCL IDE 插件更新

在待发布的版本中，KCL IDE 插件支持了对符号的引用跳转及重命名功能；优化了对引用语句和union类型的格式化输出。同时修复了语言服务虚拟文件系统相关的bug：文件维度的变更引发会语言服务崩溃，必须重启 IDE 恢复，现已修复。

使用`转到引用`或`查找所有引用`：
![](/img/docs/tools/Ide/vs-code/FindRefs.png)

对符号进行`重命名`：
![](/img/docs/tools/Ide/vs-code/Rename.gif)

对引用语句和 union 类型的格式化：优化了引用语句与其他代码块之间的空行行为（格式化为一个空行）、union 类型的空格行为（多个类型之间格式化为以 ` | ` 间隔）：
![](/img/blog/2023-10-25-kcl-biweekly-newsletter/Format.gif)

### KCL 包管理工具

在待发布的版本中，kpm 支持与 [ArtifactHub](https://artifacthub.io/) 的集成，您可以通过向[kcl-lang Registry 仓库](https://github.com/kcl-lang/artifacthub) 提交 PR 的方式将您的 KCL 包发布到 ArtifactHub. 目前我们可以在 [ArtifactHub staging 页面](https://staging.artifacthub.io/packages/search?ts_query_web=kcl&sort=relevance&page=1)看到预上传的 KCL k8s 包的效果，该功能将在 v0.6.1 版本发布：

![](/img/docs/tools/kpm/artifacthubStaging.png)

### KCL 语言更新

KCL 的编译命令正在持续地优化错误信息的输出，致力于提供清晰易懂的指引，帮助开发者快速定位和修复问题，编写出正确的代码。近期，KCL 对方法类型和参数方面的错误信息进行了优化，例如：明确指出了方法的参数类型不匹配的报错：

![](/img/blog/2023-10-25-kcl-biweekly-newsletter/error-msg.png)

此外，还修复了属性赋值的惰性求值问题，将属性赋值的计算和约束校验延迟到配置合并完成后，避免不必要的编译报错。

### KCL 命令行统一界面

为向 KCL 用户提供一致和标准化的体验，我们正在对 KCL 的命令行界面进行设计改进，以达到统一的用户工作流、相关工具和多语言 API 的无缝集成、命令行工具的可扩展性。目前完成了初步设计进入实现阶段，欢迎感兴趣的小伙伴一起讨论：https://github.com/kcl-lang/kcl/issues/756

### 社区动态

随着加入 CNCF sandbox，CNCF KCL Slack 频道已经开通，与 KCL 语言相关的交流将逐步迁移到新的频道，欢迎大家加入交流：
1. 加入 CNCF 工作空间，填写个人邮箱即可: https://communityinviter.com/apps/cloud-native/cncf
2. 加入 CNCF KCL 频道: https://cloud-native.slack.com/archives/C05TC96NWN8

### 近期活动

#### KCD 杭州站活动顺利举行

Kubernetes Community Days（KCD）杭州站活动已于 10.21 顺利举行，现场收到了 KCL 用户交流互动和热情反馈。KCL 项目的徐鹏飞发表了《基于云原生供应链的配置策略管理新范式》议题的演讲，相关资料已上传 KCL 官网：https://kcl-lang.io/talks/kcl-cncf-kcd-hangzhou2023.pdf

#### KCL 开源双周会

近期 KCL 开源双周会将于 10.26 进行，欢迎社区小伙伴踊跃参与、交流：[https://github.com/kcl-lang/community/discussions/9](https://github.com/kcl-lang/community/discussions/9)

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
