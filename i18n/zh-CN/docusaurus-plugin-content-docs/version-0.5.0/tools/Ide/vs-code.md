# Visual Studio Code KCL 插件

## 快速开始

- 1. [安装 KCL](https://kcl-lang.io/docs/user_docs/getting-started/install) 并检查 `kcl` 和 `kcl-language-server` 命令在您的 PATH 中:

  ```bash
  which kcl
  which kcl-language-server
  ```

- 2. 安装 [VS Code KCL 插件](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-extension). 需要您的 VS Code 版本大于 1.50+
- 3. 重新打开 VS Code 并创建一个 KCL 文件验证 IDE 插件功能

## 特性

此扩展提供了一些 KCL 编码帮助，包括以下功能：

- **语法高亮**
  ![Highlight](/img/docs/tools/Ide/vs-code/Highlight.png)
- **跳转**
  ![Goto Definition](/img/docs/tools/Ide/vs-code/GotoDef.gif)
- **补全**
  ![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)
- **大纲**
  ![Outline](/img/docs/tools/Ide/vs-code/Outline.gif)
- **悬停**
  ![Hover](/img/docs/tools/Ide/vs-code/Hover.gif)
- **诊断**
  ![Diagnostics](/img/docs/tools/Ide/vs-code/Diagnostics.gif)

> 提示：您可以通过安装 [Error Lens 插件](https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens) 来增强诊断效果

其他一些有用的功能，如代码重构和智能感知等正在开发中。

## 最小依赖

我们建议您使用最新版本的 KCL，但此扩展所需的 KCL 最低版本为 v0.4.6。如果您使用的是更早期版本，则此扩展可能无法正常工作。

## 已知问题

[详见](https://github.com/kcl-lang/kcl/issues/524)

## 寻求帮助

如果扩展没有如您所期望的那样工作，请通过[社区](https://kcl-lang.io/docs/community/intro/support)与我们联系和寻求帮助。

## 参与贡献

目前 VS Code KCL 插件处于早期版本，我们正在积极改进 VS Code KCL 插件体验，欢迎参考[贡献指南](https://kcl-lang.io/docs/community/contribute) 一起共建！

## 许可

Apache License 2.0
