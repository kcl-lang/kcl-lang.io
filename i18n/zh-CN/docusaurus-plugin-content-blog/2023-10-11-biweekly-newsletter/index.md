---
slug: 2023-10-11-biweekly-newsletter
title: KCL 社区开源双周报 (2023 09.07 - 10.11) | v0.6.0 版本发布 —— 更多 IDE 插件、包管理支持!
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

感谢所有贡献者过去两周 (2023 09.07 - 10.11) 的杰出工作，以下是重点合并内容概述

**🔧 语言及工具链更新**
- KCL v0.6.0 于 9.15 发布，更新内容包括语言、工具链、社区集成，详细内容请查看 [https://mp.weixin.qq.com/s/f6RCZqxS2iliRGIz0036yA](https://mp.weixin.qq.com/s/f6RCZqxS2iliRGIz0036yA)
- KCL IDE 更新 - 支持对标准库和内置函数的悬停提示，支持对 KCL 代码错误的快速修复；发布适配 Intellij IDEA 2023.2 的插件版本
- KCL 包管理工具 KPM 更新 - kpm run 支持编译 KCL 文件，并集成了导入工具
- KCL 文档工具更新 - 支持将 docstring Examples 章节输出到文档
- KCL 语言更新 - 优化了一些错误信息的输出，部分的错误信息中增加了修复建议

**📰 官网和用例更新**

- KCL 官网新增 v0.6.0 文档版本
- KCL 模型新增容器、服务和 Pod Security Policy (PSP) 相关的配置编辑、校验 20 个 [https://github.com/kcl-lang/krm-kcl/tree/main/examples](https://github.com/kcl-lang/krm-kcl/tree/main/examples)

## 特别鸣谢

以下排名不分先后

- 感谢 @jakezhu9 对 KCL Import 工具 Terraform Schema 到 KCL Schema 转换的贡献 🙌 *[https://github.com/kcl-lang/kcl-go/pull/152](https://github.com/kcl-lang/kcl-go/pull/152)*
- 感谢 @jakezhu9 对 kpm 集成 Import 工具的贡献 🙌 *[https://github.com/kcl-lang/kpm/pull/194](https://github.com/kcl-lang/kpm/pull/194)*
- 此外感谢 @prahaladramji 在过去两周使用 KCL IDEA 插件过程中提出的宝贵反馈和讨论 🙌

## 精选更新

### KCL IDE 插件更新

在最近的 0.6.0 发布中，KCL IDE 插件增加了标准库和 builtin 函数的悬停提示，新增支持对 KCL 代码错误的快速修复。此外，还增加了 language Server 侧的 e2e 测试及 konfig 仓库的集成测试，以保障 IDE 插件的稳定迭代。在尚未发布的版本中，还新增了 `kcl-language-server version` 子命令以输出版本信息。欢迎升级、使用 —— KCL 在各个 IDE 平台的插件安装方式请查看[https://kcl-lang.io/docs/user_docs/getting-started/install/#2-install-kcl-ide-extension](https://kcl-lang.io/docs/user_docs/getting-started/install/#2-install-kcl-ide-extension)

![](/img/docs/tools/Ide/vs-code/hover-built-in.png)

#### IntelliJ 插件

+ IntelliJ 插件现已适配 2023.2+ 版本，您可以在下面的链接中下载安装：

https://github.com/kcl-lang/intellij-kcl/releases

### KCL 包管理工具

kpm run 支持编译 KCL 文件，并集成了导入工具，同时增加了 —quiet 来屏蔽输出日志。

![](/img/docs/tools/kpm/kpm-run-file.png)

### KCL 语言更新

在尚未发布的版本中，KCL 的编译命令优化了一些错误信息的输出，部分的错误信息中增加了修复建议：
![](/img/blog/2023-10-11-kcl-biweekly-newsletter/error-suggestion.png)

### KCL Operator

KCL Operator 提供了 Kubernetes 集群集成，允许您在将资源应用到集群时使用 Access Webhook 根据 KCL 配置生成、变异或验证资源。Webhook 将捕获创建、应用和编辑操作，并在与每个操作关联的配置上执行 `KCLRun`。近几周内，我们提供了更多针对容器、服务和 Pod Security Policy (PSP) 配置编辑及校验的使用案例：

+ readonly-root-fs
+ allowed-image-repos
+ deny-all
+ deny-endpoint-edit-default-role
+ disallow-ingress-wildcard
+ disallow-svc-lb
+ disallow-svc-node-port
+ disallowed-image-repos
+ horizontal-pod-auto-scaler
+ psp-allow-privilege-escalation
+ psp-app-armor
+ psp-capabilities
+ psp-flexvolume-drivers
+ required-image-digests
+ required-probes
+ validate-auto-mount-service-account-token
+ validate-container-limits
+ validate-container-requests
+ validate-deprecated-api
+ k8s_manifests_containers

您可参照对应的示例引入以上配置和校验： [https://github.com/kcl-lang/krm-kcl/tree/main/examples](https://github.com/kcl-lang/krm-kcl/tree/main/examples)

更多 KCL Operator 使用指南，请查看 [https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/mutate-manifests/kcl-operator](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/mutate-manifests/kcl-operator)

### 社区动态

集成了 KCL 0.6 的 KusionStack 发布 0.9 版本，详细更新内容请查看：[https://mp.weixin.qq.com/s/nZOHdmgcfOMRf0XUXfSJ-g](https://mp.weixin.qq.com/s/nZOHdmgcfOMRf0XUXfSJ-g)

### 活动预告

#### KCD 杭州站 10.21 日线下活动

Kubernetes Community Days（KCD）杭州站将于 10.21 举行线下活动，活动详情及报名：https://mp.weixin.qq.com/s/rnNhmT4yoO66bGYNtFtG6g

#### KCL 开源双周会

近期 KCL 开源双周会将于 10.12 进行，欢迎社区小伙伴踊跃参与、交流：[https://github.com/kcl-lang/community/discussions/8](https://github.com/kcl-lang/community/discussions/8)

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
