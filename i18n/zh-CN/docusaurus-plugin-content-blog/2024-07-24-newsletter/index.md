---
slug: 2024-07-24-newsletter
title: KCL 最新动态速递 (2024.07.10 - 2024.07.24)
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

- 感谢 @Vishalk91-4 对 KCL tree-sitter 的贡献。🙌
- 感谢 @liangyuanpeng 对 kind, kubeadm 等 KCL 三方库的持续贡献。🙌
- 感谢 @DavidChevallier 对 cilium 等 KCL 三方库的持续贡献。🙌
- 感谢 @liangyuanpeng 对 KCL CLI 项目的持续贡献。🙌
- 感谢 @eshepelyuk, @haarchri, @liangyuanpeng, @logo749, @bilalba, @borgius, @patrick-hermann-sva, @ovk, @east4ming, @wmcnamee-coreweave, @steeling, @sschne, @Jacob Colvin, @Richard Holmes, @Christopher Haar, @Yvan da Silva, @Uladzislau Maher, @Sergey Ryabin, @Lukáš Kubín, @Alexander Fuchs, @Divyansh Choukse 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 内容概述

感谢所有贡献者过去一段时间 (2024.07.10 - 2024.07.24) 的杰出工作，以下是重点内容概述

**📦️ 三方库更新**

- 新增三方库 kind 支持集群的创建与管理。
- 三方库 kubeadm 更新部分字段。
- 三方库 external-secrets 版本更新到 0.1.1。
- 三方库 cilium 版本更新至 0.1.2, 去掉了 regex.match 的重复声明。
- Konfig 大库模型添加更多资源模型的示例。
- Konfig 添加额外的pod元数据标签示例。

**🏄 语言更新**

- 赋值语句中被赋值对象支持属性访问和索引访问。
- 修复了 KCL 嵌套多层 config 块语义检查时间过长的问题。
- 去掉了语义解析器中的 unwrap() 语句, 减少 panic 的问题。
- 修复了带有 list index 的字段合并运算的计算错误。

**💻 IDE 更新**

- 修复了 IDE 中 schema doc 的错误补全。
- 修复了 IDE 中 unification 块中定义的属性无法自动补全的问题。
- KCL vim 插件更新安装文档。
- KCL vscode 插件移除了 yaml 文件的响应。
- KCL vscode 插件补充了 Apache 2.0 License

**📬️ 工具链更新**

- 包管理工具修复了编译入口无法识别包相对路径 ${KCL_MOD} 的问题。
- 包管理工具将 plainHttp 选项调整为可选。
- 包管理工具修复了编译入口识别错误根目录的问题。
- 包管理工具添加登录凭证的缓存，以降低安全风险。
- 包管理工具修虚了由于虚拟编译入口导致的编译失败问题。
- 包管理工具修复了默认依赖在 kcl.mod 中的缺失。
- 包管理工具修复了 vendor path 计算错误导致的三方库重新下载的问题。
- 包管理工具修复了 push https 协议 OCI registry 失败的问题。
- KCL tree-sitter 新增 sequence operations, selector 支持。


**⛵️ API 更新**

- 重构了 override_file API 的错误信息。

**🔥 SDK 更新**

- 新增 KCL C/C++ 语言 SDK。
- 新增了 Go, Java, Python, Rust, .NET, C/C++ 等多语言 API Spec，相关文档，测试用例和使用案例。
- 代码结构调整，go 相关代码移动的 go 文件目录中。

**📚️ 文档更新**

- 新增 Python, Java, NodeJs, Rust, Wasm, .NET, C/C++ 等多语言 API 文档。
- 更新了 IDE Quick Start 文档。
- 新增博客 [A Comparative Overview of Jsonnet and KCL](https://www.kcl-lang.io/blog/2024-07-22-Jsonnet-kcl-comparison)
- 更新文档[Adapt From Kubernetes](https://www.kcl-lang.io/docs/user_docs/guides/working-with-k8s/adapt-from-kubernetes)中的 crd 资源。

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
