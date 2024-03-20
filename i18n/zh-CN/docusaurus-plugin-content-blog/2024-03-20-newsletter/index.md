---
slug: 2024-02-22-newsletter
title: KCL 最新动态速递 (2024 03.06 - 2024.03.20)
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

**📦 模型更新**

- 新增 kubeadm 配置模型
- 更新 Knative Operator 模型，对齐上游 Knative CRD 定义

**🏄 语言更新**

**KCL 发布 0.8.1 和 0.8.2 版本**，主要包含如下更新

- 体验简化增强二元表达式类型不匹配时的错误信息提示
- 修复高阶 lambda 函数对局部作用域闭包变量捕获不正常的错误
- 去除不常用的列表数据类型的不等式比较操作

**🔧 工具链更新**

- `kcl import` 工具修复当输入的 Kubernetes CRD 存在 regex 属性与 KCL regex 系统库冲突的错误
- `kcl import` 工具修复当输入的 Kubernetes CRD 属性存在复杂的默认值时输出的 KCL 文件语法错误
- `kcl mod init` 支持 `--version` 标签设置 KCL 新建模块的版本
- `kcl run`, `kcl mod add` 和 `kcl mod pull` 等命令支持对私有 Git 仓库的访问
- 修复在 Windows 上执行对本地 OCI Registry 执行 `kcl run` 命令时遇到的路径错误

**🔥 SDK 更新**

- KCL Rust, Go 和 Java SDK 发布 0.8 主要版本，同步 KCL 语法语义更新
- KCL Python SDK 发布 0.8.0.2 和 0.7.6 版本，修复 `protobuf`, `pyyaml` 等依赖版本过于低的问题

**💻 IDE 更新**

- 支持多个 Quick Fix 修复选项

![multiple-quick-fix](/img/blog/2024-03-20-newsletter/multiple-quick-fix.png)

**🎁 API 更新**

- 新增 `ListOptions` API，可以读取 KCL 工程中所有 `option` 函数调用信息。

**🚢 集成更新**

- Crossplane KCL Function 发布 v0.3.2 版本，支持非 https 协议 OCI Registry 访问和本地调试

**🌐 网站更新**

- 启用 `kcl-lang.dev` 域名，现在可以同时通过 `kcl-lang.io` 和 `kcl-lang.dev` 访问 KCL 网站
- KCL 网站加载速度优化，提升文档体验

## 特别鸣谢

感谢过去两周所有的社区参与者，以下排名不分先后

- 感谢 @bozaro 对 KCL Go SDK 带 Go 语言插件的 API 的贡献 🙌
- 感谢 @shashank-iitbhu 对 KCL IDE 快速修复功能的增强，支持多个修复选项 🙌
- 感谢 @octonawish-akcodes 对 KCL IDE 自动监听 kcl.mod 依赖变更并自动更新依赖功能的持续贡献 🙌
- 感谢 @liangyuanpeng 对 CLA Bot CI 自动锁定 PR 的修正，kubeadm 模型的贡献以及 kcl mod init 支持版本设置功能的支持 🙌
- 感谢 @Stefano Borrelli, @sfshumaker, @eshepelyuk, @vtomilov, @ricochet1k, @yjsnly, @markphillips100, @userxiaosi, @wilsonwang371, @steeling, @bozaro, @nizq, @reckless-huang, @folliehiyuki, @samuel-deal-tisseo, @MrGuoRanDuo, 和 @MattHodge 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
