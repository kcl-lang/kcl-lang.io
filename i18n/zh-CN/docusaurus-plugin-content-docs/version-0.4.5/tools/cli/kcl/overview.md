---
sidebar_position: 1
---

# 概览

KCL 工具链是 KCL 语言的工具集合，旨在提升 KCL 的批量迁移、编写、编译和测试的效率。

| 类别         | 工具名称               | 说明                                                                                                                                     |
| ------------ | ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| 主工具集     | **kcl**                | kcl 命令行工具提供对基于 KCL 语言的配置编写、编译和测试。                                                                                |
|              | kcl build              | （未支持）kcl build 子命令提供对 KCL 代码的构建                                                                                          |
|              | kcl test               | kcl 测试工具，对 KCL 的单元测试（未支持）及集成测试                                                                                      |
|              | kcl fmt                | kcl-fmt 工具提供对 KCL 代码的格式化                                                                                                      |
|              | kcl list               | （目前为 kcl list-options 及 kcl list-attributes 子命令形态）kcl-list 工具解析 KCL 代码，并列表展示 option 参数/schema attributes 信息。 |
| 自动化工具集 | kcl-lint               | kcl-lint 工具提供对 KCL 代码的 lint 检查和自动修复                                                                                       |
|              | kcl-doc                | kcl-doc 工具提供对 KCL 代码的文档解析和生成                                                                                              |
|              | kcl-fmt                | 等同于 kcl fmt 子命令                                                                                                                    |
| ide 插件集   | IntelliJ IDEA KCL 插件 | 提供 IntelliJ IDEA 平台的 KCL 编写、编译辅助                                                                                             |
|              | VS Code KCL 插件       | 提供 VS Code 平台的 KCL 编写、编译辅助                                                                                                   |
