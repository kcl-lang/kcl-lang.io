---
sidebar_position: 3
---

# IntelliJ IDEA

## 快速开始

- **1.** [安装 KCL](https://kcl-lang.io/docs/user_docs/getting-started/install) 并检查 `kcl` 和 `kcl-language-server` 命令在您的 PATH 中:
  在 MacOs 和 Linux中：

  ```bash
  which kcl
  which kcl-language-server
  ```

  在 Windows 中:

  ```bash
  where kcl
  where kcl-language-server
  ```

- **2.** 安装 [IntelliJ IDEA KCL 插件](https://plugins.jetbrains.com/plugin/23378-kcl).
- **3.** 重新打开 IntelliJ IDEA 并创建一个 KCL 文件验证 IDE 插件功能

## Features

此插件基于 LSP 提供了许多编码帮助，包括以下功能：

- **高亮:** 语法和语义高亮
- **补全:** 关键字，变量名，属性等补全
- **跳转:** schema 定义，变量，schema 属性等跳转
- **大纲:** 显示 KCL 文件中的 schema 和 变量定义
- **悬停:** Identifier 信息 (type 和 schema 文档)
- **诊断:** KCL 文件中的警告和错误信息
- **快速修复:** 对一些错误进行快速修复
- **内联提示:** 变量类型，函数和 schema 参数等提示

其他一些有用的功能，如代码重构和智能感知等正在开发中。

## 最小依赖

我们建议您使用最新版本的 KCL，但此扩展所需的 KCL 最低版本为 v0.4.6。如果您使用的是更早期版本，则此扩展可能无法正常工作。

IntelliJ IDEA 的最低版本为 2022.1

## 已知问题

[详见](https://github.com/kcl-lang/kcl/issues)

## 寻求帮助

如果扩展没有如您所期望的那样工作，请通过[社区](https://kcl-lang.io/docs/community/intro/support)与我们联系和寻求帮助。

## 参与贡献

目前 VS Code KCL 插件处于早期版本，我们正在积极改进 VS Code KCL 插件体验，欢迎参考[贡献指南](https://kcl-lang.io/docs/community/contribute) 一起共建！

## 许可

Apache License 2.0
