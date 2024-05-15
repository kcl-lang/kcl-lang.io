---
slug: 2024-05-14-lfs-guide
title: 2024 LFX Mentorship 再度来袭：KCL 开源社区欢迎你的参与 ！！！
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---
[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

- **_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**
- **_KCL Github 仓库：[https://github.com/kcl-lang](https://github.com/kcl-lang)_**

对云原生、平台工程、语言编译器、语言包管理工具和语言 IDE 感兴趣的小伙伴，我们邀请你申请 KCL 的 2024 夏季 Linux 基金会 LFX Mentorship 项目，完成项目有最低 3000 美金的奖励哦！快来申请吧！

## LFX Mentorship 项目

我们有三个 Mentorship 项目，内容涵盖包管理工具，语言编译器和语言 IDE 三个方面。

### 1. 为 KCL 包管理工具增加稀疏检出功能

KCL 包管理工具（kpm）目前支持上传，下载等分发 KCL 包的功能，但是随着 KCL 项目规模越来越大，KCL 项目依赖的三方库越来越多。kpm 每次在编译或者更新等需要下载三方库的过程中，都需要重新下载大量的 KCL 三方库，这导致工具的性能下降，因此，kpm 需要支持稀疏检出（Sparse-Checkout）功能，使 kpm 能够按需获取到需要的 KCL 程序，来提升 kpm 各个方面的性能。

- 查看详情：[https://github.com/kcl-lang/kpm/issues/304](https://github.com/kcl-lang/kpm/issues/304)
- 申请链接：[https://mentorship.lfx.linuxfoundation.org/project/09391266-0de5-426b-9e11-ceb4c28202ef](https://mentorship.lfx.linuxfoundation.org/project/09391266-0de5-426b-9e11-ceb4c28202ef)

### 2. 优化 KCL IDE 的提示信息

优化 KCL IDE 的提示信息，包括 type inlayhint 的实现和 hover 内容渲染的优化。目前，KCL 的悬停内容是纯文本格式，需要渲染成更美观的样式。

- 查看详情：[https://github.com/kcl-lang/kcl/issues/1244](https://github.com/kcl-lang/kcl/issues/1244)
- 申请链接：[https://mentorship.lfx.linuxfoundation.org/project/6d85e491-332b-4667-9b57-6ec052310494](https://mentorship.lfx.linuxfoundation.org/project/6d85e491-332b-4667-9b57-6ec052310494)

### 3. 为 KCL 编译器增加 tree-sitter 编译前端的支持

Tree-sitter 是一个支持增量编译的解析器生成器。为了支持 IDE 的更多特性，我们需要一个更完整的语法树，并且为了便于与社区集成，我们打算使用 tree-sitter 为 KCL 构建一个更完整的解析器系统。

- 查看详情：[https://github.com/kcl-lang/tree-sitter-kcl/issues/2](https://github.com/kcl-lang/tree-sitter-kcl/issues/2)
- 申请链接：[https://mentorship.lfx.linuxfoundation.org/project/47661e9d-d390-45d8-b05e-0fb3a30612f4](https://mentorship.lfx.linuxfoundation.org/project/47661e9d-d390-45d8-b05e-0fb3a30612f4)

### 4. 如何申请

在 LFX mentorship 平台上申请你钟意的项目，你可以通过以下链接访问 LFX mentorship 平台。申请从 2024 年 5 月 14 日开始，到 5 月 29 日结束。

- [https://mentorship.lfx.linuxfoundation.org/](https://mentorship.lfx.linuxfoundation.org/)

有任何的问题，欢迎直接到对应的 issue 中获取更多内容或者与我们讨论：

- KCL 包管理工具稀疏检出 [https://github.com/kcl-lang/kpm/issues/304](https://github.com/kcl-lang/kpm/issues/304)
- KCL IDE 提示信息优化 [https://github.com/kcl-lang/kcl/issues/1244](https://github.com/kcl-lang/kcl/issues/1244)
- KCL 支持 tree-sitter 编译前端 [https://github.com/kcl-lang/tree-sitter-kcl/issues/2](https://github.com/kcl-lang/tree-sitter-kcl/issues/2)

### 5. 时间节点

| 事件                                                               | 开始日期                             | 结束日期                    |
| ------------------------------------------------------------------ | ------------------------------------ | --------------------------- |
| 学员申请开放                                                       | 5 月 14 日(星期二)上午 9:00          | 5 月 29 日(星期三)上午 9:00 |
| 申请审查/录取决定/人力资源文书工作                                 | 5 月 30 日(星期四)上午 9:00          | 6 月 12 日(星期三)上午 9:00 |
| 导师计划开始并分配初始工作                                         | 6 月 17 日(星期一)(第一周)           |                             |
| 中期学员评估 / 第一笔津贴支付                                      | 7 月 24 日(星期三)(第六周)           |                             |
| 最终学员评估到期 / 学员反馈提交到期 / 批准第二笔和最后一笔津贴支付 | 8 月 29 日(星期四)上午 9:00 第十二周 |                             |
| 学期最后一天                                                       | 8 月 30 日                           |                             |
