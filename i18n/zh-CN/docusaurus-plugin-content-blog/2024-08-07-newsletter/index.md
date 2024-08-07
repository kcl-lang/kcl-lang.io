---
slug: 2024-08-07-newsletter
title: KCL 最新动态速递 (2024.07.25 - 2024.08.07)
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

## 特别鸣谢

感谢过去两周所有的社区参与者，以下排名不分先后

- 感谢 @briheet 对 kcl.mod 文件格式化输出的贡献。🙌
- 感谢 @Vishalk91-4 对 KCL tree-sitter 的持续贡献。🙌
- 感谢 @liangyuanpeng 对 KCL cli, kpm 和 modules 等仓库 CI 的持续贡献。🙌
- 感谢 @kukacz 对 KCL 模型库的持续贡献。🙌
- 感谢 @Moulick 对 Crossplane KCL Function 的贡献。🙌
- 感谢 @stmcginnis 对 KCL 文档的贡献。🙌
- 感谢 @YvanDaSilva 对 KCL Nix Package 的贡献。🙌
- 感谢 @DavidChevallier 对 KCL 模型库的持续贡献。🙌
- 感谢 @Manoramsharma 对 KCL 包管理工具依赖别名特性和外部 Git 依赖功能的贡献。🙌
- 感谢 @NishantBansal2003, @varshith257 对 KCL 包管理工具三方依赖 checksum 检查的调研和贡献。🙌
- 感谢 Harsh4902, @Gmin2, @shishir-11, @RehanChalana 对 Intellij IDE KCL LSP 插件的调研和贡献。🙌
- 感谢 @Shruti78 对 KCL 文档的贡献。🙌
- 感谢 @jianzs 对 KCL Playground 的贡献。🙌
- 感谢 @vinayakjaas 对 KPM 错误信息的贡献。🙌
- 感谢 @wmcnamee-coreweave, @dennybaa, @bozaro, @eshepelyuk, @liangyuanpeng, @vietanhtwdk, @hoangndst, @sschne, @patpicos, @metacoma, @YvanDaSilva, @ovk, @karlderkaefer, @kukacz, @Matthew Hodgkins, @Christopher Haar, @Gao Jun 和 @Zack Zhang 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 内容概述

感谢所有贡献者过去两周的杰出工作，以下是重点内容概述

**📦️ 模型更新**

- `cluster-api-provider-azure` 更新至 v1.16.0
- `cluster-api` 更新至 v1.7.4
- `konfig` 更新至 v0.6.0
- `karmada` 更新至 v0.1.1
- 新增模型列表
  - `fluxcd-kcl-controller`
  - `fluxcd-kustomize-controller`
  - `fluxcd-helm-controller`
  - `fluxcd-source-controller`
  - `fluxcd-image-reflector-controller`
  - `fluxcd-image-automation-controller`
  - `fluxcd-notification-controller`
  - `kwok`

**🏄 语言更新**

- 修复 `as` 关键字在外部包存在时类型转换的错误
- 修复在 `lambda` 函数中 config 到 schema 的类型检查错误
- 新增 `file.current()` 函数用以获取当前运行 KCL 文件的全路径
- 赋值语句支持形如 `_config["key"] = "value"` 或 `_config.key = "value"`的语法对配置进行原地修改

**💻 IDE 更新**

- 修复 Schema 使用 `:` 合并运算符定义属性实例化时的补全
- 修复在 Schema Doc 中非预期的补全
- 修复 `kcl-language-server` 命令行版本显示问题
- 支持 NeoVim, VS Code 等插件禁用保存时格式化配置
- 支持 Schema 实例化时区分属性和值语义的细粒度补全
- KCL NeoVim 插件移除默认的 key bindings, 支持用户自定以

**📬️ 工具更新**

- `kcl test` 测试工具支持测试用例中的 `print` 函数输出
- 修复 `kcl import` 在 Kubernetes CRD 和 OpenAPI 导入 Schema 的编译错误
- 优化 `kcl mod init` 的输出格式

**⛵️ API 更新**

- 修复 KCL C API 非预期的数据格式化错误
- `OverrideFile` API 支持使用 `:` 合并运算符在编译时对配置进行自动合并修改

**🔥 SDK 更新**

- KCL Go SDK 支持通过 build tags 区分以 RPC 模式还是 CGO 模式与 KCL 核心 Rust API 进行交互，默认为 CGO 模式，可以通过 `-tags rpc` 开启 RPC 模式
- KCL 多语言 SDK 发布 v0.10.0 预览版本
- 新增 KCL Kotlin 和 Swift 语言初版 SDK，尚未正式发布依赖包，欢迎参与贡献

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
