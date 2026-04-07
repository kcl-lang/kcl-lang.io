---
slug: 2024-08-21-newsletter
title: KCL 最新动态速递 (2024.08.07 - 2024.08.21)
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

- 感谢 @officialasishkumar 对 KCL 包管理工具添加 Git 仓库子目录依赖能力的贡献 🙌
- 感谢 @Gmin2 对 KCL 包管理工具模块存放路径特性的贡献 🙌
- 感谢 @liangyuanpeng 对 karpenter, gateway-api 等模块以及 KCL OpenAPI 工具的贡献 🙌
- 感谢 @NishantBansal2003, @varshith257 对 KCL 包管理工具三方依赖 checksum 检查的调研和贡献。🙌
- 感谢 @Harsh4902, @Gmin2, @shishir-11, @RehanChalana 对 Intellij IDE KCL LSP 插件的调研和贡献。🙌
- 感谢 @Vishalk91-4 对 KCL tree-sitter 语法的持续贡献。🙌
- 感谢 @dennybaa 对 crossplane, crossplane-vault-provider 等模块的贡献 🙌
- 感谢 @Manoramsharma 对 KCL 包管理工具依赖别名特性，忽略 TLS 检查和外部 Git 依赖功能的贡献。🙌
- 感谢 @DavidChevallier 对 cilium, external-secrets 等模块的贡献 🙌
- 感谢 @suin 对 outdent 模块的贡献 🙌
- 感谢 @Lukáš Kubín, @ChrisK, @Sergey Ryabin, @Lan Liang, @Endre Karlson, @suin, @Zack Zhang, @v3xro, @soubinan, @juanzolotoochin, @mnacharov, @dennybaa, @ron1, @DavidChevallier, @wmcnamee-coreweave, @vfarcic, @phisco, @juanzolotoochin, @juanique, @zackzhangverkada, @warmuuh 和 @novohool 等在近两周使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 内容概述

**🏄 语言更新**

- 优化函数参数调用/返回值 Dict 转 Schema 类型推导和检查，可以省略 Schema 名称简化配置书写
- 优化配置合并运算符的类型检查，可以在编译时发现更多类型错误
- 对类型为单子面值常量 Schema 属性支持省略默认值

优化前

```kcl
schema Deployment:
    apiVersion: "apps/v1" = "apps/v1"
```

优化后

```kcl
schema Deployment:
    apiVersion: "apps/v1"  # 类型值与默认值相同，可以省略默认值
```

**📦️ 模块更新**

- `k8s` 更新至 1.31
- `gateway-api` 更新至 0.2.0
- `karpenter` 更新至 0.2.0
- `crossplane` 更新至 1.16.0
- `cilium` 更新至 0.3.0
- `external-secrets` 更新至 0.1.2
- 新增模型列表
  - `crossplane-provider-vault` 1.0.0
  - `outdent` 0.1.0
  - `kcl_lib` 0.1.0

**📬️ 工具更新**

- `kcl import` 工具支持导入整个 Go Package 并将其中所有的 Go 结构体定义转换为 KCL Schema 定义
- `kcl import` 工具新增对包含 AllOf 验证字段的 JSON Schema 格式导入为 KCL Schema 的支持
- `kcl fmt` 工具支持保留用户在多个代码片段之间的空行，不会全部删除
- 修复 `kcl fmt` 工具对 Schema 索引签名注释错误的格式化位置
- 修复 `kcl import` 导入 Kubernetes CRD 时设置 -o 参数非预期的报错
- 修复 `kcl import` 导入空 Go 结构体输出非预期的 KCL Schema 错误

**💻 IDE 更新**

- 支持使用 `kcl.work` 配置文件划分 IDE 工作空间
- 修复 Schema 示例化参数无法显示语义信息的问题

**⛵️ API 更新**

- Kotlin API 完整测试和用例更新，详见 [https://www.kcl-lang.io/docs/reference/xlang-api/kotlin-api](https://www.kcl-lang.io/docs/reference/xlang-api/kotlin-api)
- Lua API 产出初步版本，欢迎贡献，详见 [https://github.com/kcl-lang/lib/tree/main/lua](https://github.com/kcl-lang/lib/tree/main/lua)

**🔥 社区集成更新**

- Flux KCL Controller 发布 v0.4.0 版本，对齐绝大部份 Flux Kustomize Controller 功能，满足直接使用 KCL 代替 Kustomize 作 Flux GitOps 的需求
- KRM KCL 规范发布 v0.10.0 beta 版本，新增私有 Git 仓库拉取和忽略 TLS 检查等功能
- KCL Nix Package 发布 v0.9.8 版本
- Crossplane KCL Function 发布 v0.9.4 版本，具体内容详见 [https://github.com/crossplane-contrib/function-kcl](https://github.com/crossplane-contrib/function-kcl)
- KCL Bazel Rules 更新 KCL v0.10.0 beta 版本，具体内容详见 [https://github.com/kcl-lang/rules_kcl](https://github.com/kcl-lang/rules_kcl)

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
