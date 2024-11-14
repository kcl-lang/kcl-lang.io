---
slug: 2024-11-14-newsletter
title: KCL 最新动态速递 (2024.11.01 - 2024.11.14)
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

- 感谢 @prakhar479 对 KCL built-api 支持 blake3 的贡献 🙌
- 感谢 @shruti2522 对 IDE hints 功能增强的贡献 🙌
- 感谢 @liangyuanpeng 对 kcl-openapi 工具的持续贡献 🙌
- 感谢 @trogowski 对 KCL 文档的贡献 🙌
- 感谢 @yonas 对 KCL 文档的贡献 🙌
- 感谢 @NishantBansal2003 对 KCL 包管理工具 sum check 功能的持续贡献 🙌
- 感谢 @officialasishkumar 对 KCL 包管理工具下载 Git 子包功能的贡献 🙌

- 感谢 @cx2c, @yonas, @NishantBansal2003, @shruti2522, @nwmcsween, @trogowski, @suin, @johnallen3d, @liangyuanpeng, @riven-blade, @officialasishkumar, @gesmit74, @prakhar479, @Lukáš Kubín, @Christopher Haar, @Alexander Fuchs, @Peter Boat, @Stéphane Este-Gracias, @Yvan da Silva, @Rehan Chalana, @Zack Zhang, @Josh West, @Brandon Nason, @suin, @Anany 等在近两周使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 内容概述

### 🏄 语言更新

- 修复因为 Schema 继承定义关系导致的非预期运行结果
- 重构 Parser 实现，在 400+ KCL 文件的条件下解析性能提升 40%

### 💻 IDE 更新

- 优化解包表达式 `**expr` 的静态分析，提供更丰富的诊断信息
- 优化 schema 类型的 `{}` 代码片段补全
- 新增对 `kcl.mod` 文件变更的监控，优化外部包补全体验
- 区分 `any` 类型和 `any` 关键字表达式的高亮颜色显示

### 📦️ 模型更新

- edp-keycloak-operator 发布 `v1.23` 版本

### 📬️ 工具更新

- `kcl mod` 命令支持 module spec 获得 OCI 和 Git 依赖中的子模块
- `kcl import` 工具修复多行 YAML 字符串的导入
- `kcl import` 工具修复当属性存在默认值的 Kubernetes CRD 导入
- `kcl run` 修复 `-o` 参数会截断文件输出的问题

### 🧩 SDK 更新

- 

### 🔥 社区集成更新

- Crossplane KCL 函数更新至 v0.10.8 版本，支持对 external resources 的读取

### 📖 文档更新

- 更新 FAQ 中的 KCL 插件使用文档
- 更新 FAQ 中的配置合并文档，新增 `json_merge_patch` 库的使用文档
- 为所有系统库函数添加使用样例
- 新增更多 OAM 模型的使用案例

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
