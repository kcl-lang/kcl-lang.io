---
slug: 2024-02-05-lfs-guide
title: 2024 LFX Mentorship 实习开启：KCL 开源社区欢迎你的参与 ！！！
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**\
**_KCL Github 仓库：[https://github.com/kcl-lang](https://github.com/kcl-lang)_**

对云原生、平台工程、语言编译器、语言包管理工具和语言 IDE 感兴趣的小伙伴，我们邀请你申请 KCL 的 2024 春季 Linux 基金会 LFX Mentorship 项目，完成项目有最低 3000 美金的奖励哦！快来申请吧！

## LFX Mentorship 项目

我们有三个 Mentorship 项目，内容涵盖包管理工具，语言编译器和语言 IDE 三个方面。

### 1. 为 KCL 包管理工具添加版本管理支持

KCL 目前的包管理工具（kpm）目前支持上传，下载等分发 KCL 包的功能，不支持 KCL 包的版本管理。在使用 kpm 为 KCL 添加三方库依赖的过程中，kpm 会根据依赖关系自动下载全部的三方库依赖，如果在下载的过程中出现相同包的不同版本，应该根据包版本管理策略提供对应的选择策略，选择合适的版本下载。

在此项目中，你需要为 kpm 增加包版本管理部分的功能，使 kpm 在管理三方库的过程中能够根据依赖情况，选择合适的三方库进行下载，确保编译过程的正常进行。

- 查看详情：https://github.com/kcl-lang/kpm/issues/246
- Pretest：https://github.com/kcl-lang/kpm/issues/263
- 申请链接：https://mentorship.lfx.linuxfoundation.org/project/06b5baee-bdcd-4f5e-9a1a-454191445a01

### 2. KCL IDE 的快速修复

为 KCL IDE 开发快速修复功能，当 KCL 程序在 IDE 中出现编译错误时，Quick Fix 功能能够根据用户的错误类型，在 KCL 程序错误的位置提供快速的问题修复。

在此项目中，你需要根据 KCL 程序的错误类型，为用户 IDE 开发不同的 Quick Fix 功能，降低用户开发门槛。

- 查看详情：https://github.com/kcl-lang/kcl/issues/997
- Pretest：https://github.com/kcl-lang/kcl/issues/1020
- 申请链接：https://mentorship.lfx.linuxfoundation.org/project/391edda7-239d-4471-a36a-c03c24e024cb

### 3. KCL IDE 自动加载 KCL 三方库。

KCL IDE 作为 KCL 用户最直接的开发界面，要想提供良好的用户体验，除了提供语言的高亮，跳转，补全等基本功能外，还需要保证编译过程的稳定。但是目前 KCL 的 IDE 经常会因为三方库找不到而导致编译错误，目前 KCL 的包管理工具 kpm 已经提供了自动下载和更新三方库的能力，但是仍然需要用户通过命令行的方式更新三方库，这使得用户的开发体验受到影响，因此 KCL IDE 需要与 KCL 的包管理工具 kpm 进行集成，通过 kpm 为 IDE 提供三方库的自动下载更新的能力。

在此项目中，你需要借助 kpm 的能力，实现 IDE 中常见的如：加载 KCL 包自动下载三方库，kcl.mod 变更时自动更新三方库和 Quick Fix 触发三方库自动下载等功能，保证 KCL IDE 在包管理工具的支持下能够提供更加完整流畅的开发体验。

- 查看详情：https://github.com/kcl-lang/kcl/issues/998
- Pretest：https://github.com/kcl-lang/kcl/issues/1031
- 申请链接：https://mentorship.lfx.linuxfoundation.org/project/59d5fb6c-153d-4e46-9d1f-2948641b0471

### 4. 如何申请

在 LFX mentorship 平台上申请你钟意的项目，你可以通过以下链接访问 LFX mentorship 平台。申请从2024年1月29日开始，到2月13日结束。

- https://mentorship.lfx.linuxfoundation.org/

有任何的问题，欢迎直接到对应的 issue 中获取更多内容或者与我们讨论：

- KCL 包版本管理 https://github.com/kcl-lang/kpm/issues/246

- KCL 快速修复 https://github.com/kcl-lang/kcl/issues/997

- KCL IDE 依赖更新 https://github.com/kcl-lang/kcl/issues/998

### 5. 项目时间节点

| 事件                                                               | 开始日期                      | 结束日期                 |
| ------------------------------------------------------------------ | ----------------------------- | ------------------------ |
| 学员申请开放                                                       | January 29                    | February 13, 5:00 PM PDT |
| 申请审查/录取决定/人力资源文书工作                                 | February 13                   | February 27, 5:00 PM PDT |
| 导师计划开始并分配初始工作                                         | March 4 (Week 1)              |                          |
| 中期学员评估 / 第一笔津贴支付                                      | April 10 (Week 6)             |                          |
| 最终学员评估到期 / 学员反馈提交到期 / 批准第二笔和最后一笔津贴支付 | May 22, 5:00 PM PST (Week 12) |                          |
| 学期最后一天                                                       | May 31                        |                          |
