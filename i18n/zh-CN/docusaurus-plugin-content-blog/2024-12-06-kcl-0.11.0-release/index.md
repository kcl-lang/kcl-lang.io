---
slug: 2024-09-18-kcl-0.10.0-release
title: KCL v0.10.0 重磅发布 - 更稳定流畅的工具链和 IDE 体验，全新的 KCL Playground !
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## 简介

KCL 团队很高兴地宣布 **KCL v0.10.0 新版本现在已经可用**！本次发布为大家带来了两方面的重点更新

- _使用功能更完善和错误更少的 KCL 语言、工具链和 IDE 提升代码编写体验和效率_
- _更加全面丰富的标准库、三方库以及社区生态集成，涵盖不同应用场景和需求_

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

## ❤️ 特别鸣谢

**感谢 KCL 在 v0.10 - v0.11 版本迭代所有 80 位社区参与者，以下排名不分先后**


## 📚 重点更新内容

### 🔧 核心功能

#### 语言

- KCL 重构了 Parser 部分的实现，重新组织了 import 依赖的 parse 流程。
- KCL 优化了 schema attribute 中对 ** 表达式的类型解析。
- KCL 修复了 lambda 表达式嵌套调用时不生效的问题。
- KCL 修复了 schema mixin parse 内存泄露的问题。
- KCL 修复了在有类型声明的赋值语句中函数调用表达式中的类型提升。
- KCL 修复了 mixin 中调用 attr 的 lambda 函数的错误

#### 工具链

- 修复 `kcl fmt` 代码注释的格式化错误。
- 修复 `kcl fmt` 在处理行连接符和注释组合时的错误。

#### IDE

- KCL IntelliJ 插件发布 0.4.0 版本，支持 LSP4IJ。
- IDE 可以补全目录中未 import 的 schema，并且自动补充包的 import 语句
- IDE 能够监控工作目录中的配置文件变化，在 kpm 更新依赖后能自动更新 IDE 中的语义信息
- IDE 新增了 Config 块中 key 的类型 hint。
- IDE schema hover 中提供了 attr 默认值信息。
- 修复了 IDE 在 Windows 系统中的异常。
- 修复了 IDE 在复合赋值运算语句中异常的问题。
- 区分了 `any` 关键字和类型的高亮
- 修复了 IntelliJ 插件中格式化代码报错的问题。
- 优化了 IDE 编译流程中 parser 部分。
- 修复了函数参数 hint 不一致的问题。
- 优化了 hint 信息，增加了双击将 hint 插入代码的功能。

#### API

- 新增了 `kcl_run_with_log_message` API
- 新增了 `kcl_exec_program` capi
- 为 wasm 添加 `kcl_version` api

### 📦️ 标准库及三方库

#### 标准库

- 修复 `manifests.yaml_stream` 中 `ignore_private=False` 参数 不生效的问题。

#### 三方库

- k8s 更新至 1.31.2
- 修复 k8s 包中 import 别名的问题。
- konfig 中增加 DeploymentStrategy 模型
- helloworld 更新至 0.1.4
- gateway 更新至 0.3.2
- kubevirt 更新至 0.3.0
- cert-manager 更新至 0.3.0
- 新增 edp-keycloak-operator
- 新增 sealed-secrets

### ☸️ 生态集成

### 🧩 多语言 SDK 和插件

#### 多语言 SDK

#### 多语言插件更新


### 📖 文档更新

- 修复 argocd kcl plugin 配置的示例代码中的错误
- 新增了关于 plugin 相关的 FAQ 文档。
- 新增了更多关于系统包相关的示例文档。
- 新增了关于 json_merge_patch 相关的 FAQ 文档。
- 新增了关于 isnullish 函数 相关的 FAQ 文档。
- 新增了关于 oam app 继承相关的示例代码。
- 修复了 Windows 安装脚本。
- 修复了文档中部分 typo 和失效链接。
- 更新了 KCL IntelliJ 插件的说明文档。

## 🌐 其他资源

🔥 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们 🔥

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
