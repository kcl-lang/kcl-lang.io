---
slug: 2024-04-30-newsletter
title: KCL 最新动态速递 (2024.04.17 - 2024.04.30)
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**

## 内容概述

感谢所有贡献者过去一段时间 (2024.04.17 - 2024.04.30) 的杰出工作，以下是重点内容概述

**🏄 语言更新**

- KCL 新增对 alpine linux 和 fedora linux 平台的支持。

- 支持 lambda 闭包的计算。

- 修复了在列表推导式中 schema 实例合并失败的 bug

- 修复了 schema 内 lambda 方法的调用过程。

- 修复了 windows 系统上API 找不到的bug。

- 修复了锁文件失败而导致的并行编译过程的错误。

**⛵️ API 更新**

- OverrideFile API 支持不存在变量的插入。

- Override API 支持通过变量名赋值。

- Override API 修复了因为空格导致的配置合并问题。

**🚪 CLI 更新**

- 优化了输出 json 的格式。

**🔥 SDK 更新**

- KCL Python SDK 发布至 pypi 仓库。

  仓库地址：**<https://pypi.org/project/kcl-lib/>**

- KCL Node JS SDK 发布至 npm 仓库。

  仓库地址：**<https://www.npmjs.com/search?q=kcl-lib>**

- KCL Java SDK 发布至 Github Maven 仓库。

  仓库地址：**<https://github.com/orgs/kcl-lang/packages?repo_name=lib>**

**💻 IDE 更新**

- KCL VScode 支持包管理清单文件 kcl.mod 和 kcl.mod.lock 的高亮。

![kclmod](/img/blog/2024-04-30-biweekly-newsletter/kclmod.png)
![kclmodlock](/img/blog/2024-04-30-biweekly-newsletter/kclmodlock.png)

**📬️ 包管理工具更新**

- api 增加了 downloader 结构，支持自定义三方库下载。

- 修复了使用 oci url 添加依赖时，url 中指定的仓库失效的问题。

- 修复了调用 api 输出日志失效的问题。

**📦️ 三方库更新**

- 新增 Argo-cd-order 用于排序 argocd 同步操作的模块。

- 增加了 crossplane-provider-gcp-upjet 的规范定义 crossplane-provider-upjet-gcp。

- crossplane 三方库更新到 1.15.2.

**📘 文档更新**

- 新增多语言 SDK 相关文档。

- 新增 rust api 相关文档。

- 新增 node-js api 相关文档。

- 更新了 OverrideFile API spec 规范。

- 新增 KCL Nix 安装文档。

- 新增包管理工具支持 Registry 列表。

- 补充了一些常见的问题 Q&A。

**🎈 社区活动**

- 知名 KOL、YouTuber、DevOpsToolkit 频道主理人 Viktor Farcic 为 KCL 做了测评，对于如何更好地管理 Kubernetes 配置清单和处理数据结构，他介绍了 KCL 作为解决方案并进行了深度使用。

![youtuber](/img/blog/2024-04-30-biweekly-newsletter/youtuber.png)

原视频链接：**<https://www.youtube.com/watch?v=Gn6btuH3ULw>**

## 特别鸣谢

感谢过去两周所有的社区参与者，以下排名不分先后

- 感谢 @shruti2522，@metacoma 对 KCL 的贡献 🙌
- 感谢 @metacoma，@aleeriz 为 KCL 贡献了更多的三方库 🙌
- 感谢 @XiaoK29 对 KCL go SDK 的贡献 🙌
- 感谢 @d4v1d03 对 KCL 官网 FAQ 文档的贡献 🙌
- 感谢 @shruti2522 对于 KCL IDE 的贡献 🙌
- 感谢 @Tom van Dinther 对于 Nix 支持 KCL Cli 的贡献 🙌
- 感谢 @steeling, @Stephen C, @Henri Williams, @Hai Wu, @Even Solberg, @Sergey Ryabin, @Shashank Mittal @Abhishek 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
