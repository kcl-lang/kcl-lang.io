---
slug: 2024-06-27-newsletter
title: KCL 最新动态速递 (2024.06.12 - 2024.06.27)
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

- 感谢 @liangyuanpeng 对 KCL bug 的反馈与测试用例的补齐。🙌
- 感谢 @MatisseB 对 KCL PROTOC环境变量设置功能的贡献。🙌
- 感谢 @DavidChevallier 对 KCL argo-cd 三方库的贡献。🙌
- 感谢 @kukacz 对 KCL cluster-api-provider-metal3, cluster-api-provider-gcp 等三方库的贡献。🙌
- 感谢 @dennybaa 对 victoria-metrics-operator, istio 等三方库的贡献。🙌
- 感谢 @ihor-hrytskiv 对 jsonpatch 三方库的贡献。🙌
- 感谢 @XiaoK29 对 kcl-go SDK 代码的贡献。🙌
- 感谢 @patrycju, @kukacz, @dennybaa, @LinYunling, @liangyuanpeng, @riven-blade, @bozaro, @MatisseB, @ealap, @tvandinther, @leon-andria, @Wes McNamee, @Uladzislau Maher, @M Slane, @Tom van Dinther, @Lukáš Kubín, @Mohamed Asif, @Sergei Iakovlev, @Korada Vishal, @Asish Kumar 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 内容概述

感谢所有贡献者过去一段时间 (2024.06.12 - 2024.06.27) 的杰出工作，以下是重点内容概述

**📦️ 三方库更新**

- 新增 argo-cd 包 0.1.1 版本。
- 新增三方库 cluster-api 支持通过 cluster api 管理集群。
- 新增三方库 cluster-api-provider-metal3 支持通过 cluster api 管理 Metal3。
- 新增三方库 cluster-api-provider-gcp 支持通过 cluster api 管理 gcp。
- 新增三方库 cluster-api-addon-provider-helm 支持通过 Addon 管理 helm chart。
- 新增三方库 cluster-api-addon-provider-aws 支持通过 cluster api 管理 aws。
- 新增三方库 cluster-api-provider-azure 支持通过 cluster api 管理 azure。
- 三方库 k8s 升级到 1.30 版本。
- 三方库 victoria-metrics-operator 升级到 0.45.1 版本，新增了一些检查语句的提示信息。
- 三方库 istio 升级到 1.21.2 版本，调整了一些 check 规则，新增了文档。
- 三方库 jsonpatch 升级到 0.0.5 版本，支持 rfc6901Decode。

**🏄 语言更新**

- 增加了 centos7 amd64 的构建环境。
- 修正了代码注释中的一些拼写错误。
- 修复了 file.modpath 和 file.workdir 的缓存导致性能过慢的问题。
- 修复了带有继承结构的 schema 实例类型识别错误的问题。
- 修复了多个 if 语句中，分支部分重复执行的问题。
- 修复了环境变量 PROTOC 设置无法生效的问题。

**💻 IDE 更新**

- 支持在 lambda 表达式中 schema 参数和 schema 返回值的属性跳转。
- 修复了 IDE 中 import 内部包无法补全的问题。
- 修复了嵌套 schema 内部，属性补全的错误提示。
- 修复了表达式内部，自动补全提示缺失的问题。
- 修复了因为缓存导致的 kcl.mod 修改无法生效。
- 修复了 IDE 中字面值类型提示错误。
- 修复了长字符串高亮问题。

**📬️ 工具链更新**

- 包管理工具修复了 kcl.mod 中将默认三方依赖替换为 oci 依赖的问题。
- kcl-openapi 用例更新, 修复了一些编译错误，并且新增 schema 时可选属性值是否存在的检查。

**⛵️ API 更新**

- 修复了 OverrideFile API 插入配置错误的问题。
- ListVariable API 支持编译时配置合并。

**🔥 SDK 更新**

- go SDK 支持从 go 导入 schema。
- go SDK 清理了一些过时代码，新增了部分测试。
- Java SDK 对齐 API 更新。

**📚️ 文档更新**

- 新增 kcl doc 生成 html/markdown 文件的格式错误问题解决方案。
- 增加了 import 语句中导入包名中带有`-` 导致编译错误的解决方案。
- 调整文档用例适配更新。

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
