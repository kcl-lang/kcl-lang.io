---
slug: 2024-04-03-newsletter
title: KCL 最新动态速递 (2024 03.20 - 2024.04.03)
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

感谢所有贡献者过去一段时间 (2024 03.06 - 2024.03.20) 的杰出工作，以下是重点内容概述

**🏄 语言更新**

**KCL 发布 0.8.3 和 0.8.4 版本**，主要包含如下更新

- 增加了文件系统 built-in 方法 `file.abs` 计算文件绝对路径和 `file.exists` 判断文件是否存在。

**🔧 工具链更新**

- KCL 包管理工具: `kcl.mod` 文件中增加对 oci url 的支持。
- KCL 包管理工具: `kcl.mod` 中移除了间接依赖的更新。
- KCL 包管理工具: 移除了本地依赖的 checksum 检查。
- KCL 包管理工具: 修复了本地依赖版本号缺失的问题。
- KCL 包管理工具: 修复了本地依赖缺失的问题。
- KCL 包管理工具: 修复了符号链接创建失败的内部 bug。

**🔥 SDK 更新**

- KCL Go SDK 发布 0.8.3 版本。
- KCL Go SDK 修复了 ParseFile 过程中的 panic 问题。
- KCL Go SDK 支持通过环境变量设置 kcl 编译器自动下载。

**💻 IDE 更新**

- 修复了 IDE 对于未保存代码的 format 功能。

## 特别鸣谢

感谢过去两周所有的社区参与者，以下排名不分先后

- 感谢 @bozaro 对 KCL Go SDK 的贡献 🙌
- 感谢 @reckless-huang 对于 KCL Go SDK 的贡献 🙌
- 感谢 @vemoo 对 KCL IDE 的贡献 🙌
- 感谢 @wilsonwang371 对 KCL docker 镜像和 KCL 官网的贡献 🙌
- 感谢 @d4v1d03 对 KCL 官网的贡献 🙌
- 感谢 @liangyuanpeng 对 KCL github action 的贡献 🙌
- 感谢 @octonawish-akcodes 对 KCL IDE 的贡献 🙌
- 感谢 @AkashKumar7902 对 KCL 包管理工具的贡献 🙌
- 感谢 @empath-nirvana 对 crossplane function-kcl 的贡献 🙌
- 感谢 @markphillips100, @reckless-huang, @steeling, @vfarcic, @wilsonwang371, @M Slane, @Tertium, @Abhishek, @Akash Kumar, @Kim Sondrup, @rodrigoalvamat, @riven-blade, @userxiaosi 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
