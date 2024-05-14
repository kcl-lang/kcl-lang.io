---
slug: 2024-05-15-newsletter
title: KCL 最新动态速递 (2024.05.01 - 2024.05.15)
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

感谢所有贡献者过去一段时间 (2024.05.01 - 2024.05.15) 的杰出工作，以下是重点内容概述

**📦️ 三方库更新**

- `argo-cd-order` 更新到 0.2.0 版本，新增资源过滤功能
- `crossplane` 模块 KCL 代码更新，与 crossplane 1.15 版本 CRD Webhook 校验规则匹配
- `json-merge-patch` 模块更新到 0.1.1 版本，支持 Schema 类型过滤

**🏄 语言更新**

- 修复 `yaml.decode_all` 函数返回值的类型错误
- 修复 `as` 关键字在某些三方库存在会断言失败的情况
- `file` 模块函数列表更新，详见[文档](https://www.kcl-lang.io/docs/reference/model/file)
- 为 `typeof` 函数新增 Schema 类型的支持用于区分 schema 类型和实例

```python
schema Foo:
    bar?: str

foo = Foo {}
type_schema = typeof(foo) # schema
type_type = typeof(Foo) # type
```

**💻 IDE 更新**

- 修复 IDE 在 Windows 操作系统上路径错误以及偶发崩溃的问题
- Intellij KCL 插件根据功能不同拆分为带/不带 kcl-language-server 两种版本

**📬️ 工具链更新**

- 修复 `kcl run` 编译相对路径模块时找不到三方库的问题
- 修复 `kcl vet` 验证工具不能导入外部库的问题
- 修复 `kcl fmt` 格式化工具在插入外部 import 语句时的格式化错误问题
- 修复 `kcl completion bash` 命令补全非预期的错误

**⛵️ API 更新**

- `OverrideFile` API 优化变量自动修改时的格式输出
- `ListVariables` API 支持变量属性运算符类型和 Schema 类型返回
- `GetSchemaType` API 支持 Schema 父类返回

**🔥 SDK 更新**

- KCL Rust SDK 发布 v0.9.0-alpha.1 预览版本
- KCL Python SDK 发布 v0.9.0-alpha.1 预览版本
- KCL Node.js SDK 发布 v0.9.0-alpha.1 预览版本
- KCL Java SDK 发布 v0.9.0-SNAPSHOT 版本

**🚪 集成更新**

- 修复 ArgoCD KCL Plugin 并发同步资源报错的问题
- 新增 KCL arm64 docker 镜像 `kcllang/kcl-arm64`
- KRM KCL 规范新增权限访问字段、Kubernetes 资源过滤字段和编译配置字段，支持私有 OCI Registry 访问以及灵活的编译配置，详见[文档](https://github.com/kcl-lang/krm-kcl)
- Crossplane KCL 函数发布 v0.8.0 版本并更新更多使用样例，详见[文档](https://github.com/crossplane-contrib/function-kcl)

## 特别鸣谢

感谢过去两周所有的社区参与者，以下排名不分先后

- 感谢 @Blarc 和 @prahaladramji 对 KCL Intellij IDE 插件支持最新 Intellij 版本的贡献 🙌
- 感谢 @jgascon-nx 对 KCL Crossplane 模块的贡献 🙌
- 感谢 @Gmin2 对 KCL VS Code IDE 重启 KCL Language Server 命令的贡献 🙌
- 感谢 @Gmin2 对 KCL GetSchemaType API 支持返回父类字段的贡献 🙌
- 感谢 @metacoma 对 KCL argo-cd-order 模块的贡献 🙌
- 感谢 @shruti2522 对 KCL file 模块的贡献 🙌
- 感谢 @shruti2522 对 KCL Import 和 Doc 工具的贡献 🙌
- 感谢 @shruti2522 对 KRM KCL 规范 Kubernetes 资源过滤功能的贡献 🙌
- 感谢 @JeevaRamanathan 对 KCL file 模块的贡献 🙌
- 感谢 @AkashKumar7902 对 KCL 包管理工具 MVS 最小版本选择算法的贡献 🙌
- 感谢 @bozaro 对 KCL Go SDK Native API 的贡献 🙌
- 感谢 @officialasishkumar 对 KCL 包管理工具配置支持 exclude 参数和 include 参数的贡献 🙌
- 感谢 @beholdenkey 对 KCL 文档的贡献 🙌
- 感谢 @d4v1d03 对 KCL IDE 悬停功能的贡献 🙌
- 感谢 @ibishal 对 KCL IDE Preview 功能的贡献 🙌
- 感谢 @bradkwadsworth-mw 对 KRM KCL 规范中访问权限字段以及的贡献 🙌
- 感谢 @jgascon-nx 和 @metacoma 对使用 KCL 和 Crossplane KCL 函数的经验和案例分享 🙌
- 感谢 @mintu, @Sergei Iakovlev, @HAkash Kumar, @HStéphane Este-Gracias, @Korada Vishal, @Bishal, @metacoma, @NAVRockClimber, @nkabir, @dennybaa, @dopesickjam, @vfarcic, @sestegra, @jgascon-nx, @zargor, @markphillips100, @evensolberg, @borgius, @bradkwadsworth-mw, @reedjosh, @patrycju, @PrettySolution, @selfuryon, @steeling, @empath-nirvana, @CC007, @M Slane, @MOHAMED FAWAS 和 @Even Solberg 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
