---
slug: 2024-09-05-newsletter
title: KCL 最新动态速递 (2024.08.21 - 2024.09-05)
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

**🏄 语言更新**

- 加密标准库新增参数，支持对参数传入参数进行编码。

```kcl
sha512(value: str, encoding: str = "utf-8") -> str
```

- 新增 built-in API crypto.blake3 支持使用 Blake 算法进行哈希加密。

```kcl
import crypto
blake3 = crypto.blake3("ABCDEF")
```

- 新增 built-in API isnullish 支持判断字段是否为空。

```kcl
a = [100, 10, 100]
A = isnullish(a)
e = None
E = isnullish(e)
```

- 新增 built-in API datetime.validate 支持验证日期内容。

```kcl
import datetime
assert datetime.validate("2024-08-26", "%Y-%m-%d")
```

- 修复了 built-in API datetime 中日期格式的问题。
- KCL Plugin 支持通过 rust 开发。
- 修复了 Schema 配置合并参数解析错误的问题。
- KCL 发布了 0.10.0-rc.1 版本。
- KCL Plugin 增加了部分测试。

**💻 IDE 更新**

- 修复了第一行第一列代码高亮失效的问题。
- 修复了 IDE 偶发死锁的问题。
- IDE 增加了更多输出日志。
- 优化了 scehma index signature key 的语义高亮。
- IDE find ref 功能优化。
- IDE 修复了更新 kcl.mod 失效的问题。
- IDE 修复了 find ref 错误。
- IDE 修复了打开文件时代码高亮失败。
- LSP 部分代码结构重构，调整了部分 API 的作用域。
- IDE 修复了 kpm 更新依赖后，IDE 没有同步更新的问题。
- IDE 新增了对 schema 参数的 hints。

**📖 文档更新**

- 新增了 KCL 在 kubecon 2024 的回顾文章。
- 文档中增加了新增 built-in API 相关的文档。
- 调整了文档中包管理工具与 OCI registry 和 Git Repo 部分集成的文档。
- 新增了文档中关于 kcl.mod include 和 exclude 字段的描述。
- 修复了部分文档错误。

**📦️ SDK 更新**

- 新增 KCL wasm lib 支持 node.js 和 浏览器集成。
- 重构优化了 KCL python 的代码案例。

**📬️ 工具更新**

- kcl-openapi 对代码结构和文档结构进行了优化和调整。
- kcl-playground 添加了更多的测试用例，对工程结构体进行了优化和升级。
- 包管理工具修复了编译多个 \*.k 文件失败的 bug。
- 包管理工具支持添加 Git 仓库中子包作为三方库。
- 包管理工具新增部分测试用例。
- krm-kcl function 修复了部分测试和文档中的错误。
- kcl-operator 更新和修复了部分文档内容，优化了部分代码结构。
- kcl-operator 新增部分测试用例，优化了发布流程。
- kcl-operator 新增了初始化容器时的自动鉴权。
- KCL fmt 工具提供了 C api。

**⛵️ API 更新**

- kcl-go API 支持 jsonschema 的导入。

**🔥 社区集成更新**

- kcl-flux-controller 传入参数优化, 新增更多的测试用例，更加完整的 release 和测试流程。

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
