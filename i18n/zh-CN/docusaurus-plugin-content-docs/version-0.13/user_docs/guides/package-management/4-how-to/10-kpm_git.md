# 使用 Git 仓库

KCL 包管理工具支持通过 OCI registry 和 Git 仓库保存和分享 KCL 包。本文将介绍如何使用 KCL 包管理工具与私有 OCI registry 和 Git 仓库集成。由于 Git 命令行工具提供了登录/push/pull等功能，因此，KCL 包管理工具将不再提供同样的功能，KCL 包管理工具仅支持通过 `kcl mod add` 命令将 git 仓库添加为当前 KCL 包的三方库。

## 私有 Git 仓库

KCL 包管理工具依赖本地环境中的 Git 工具完成与 Git 仓库的交互。因此，在使用 KCL 包管理工具之前，确保本地环境中完成了 Git 工具的安装，并且在环境变量 $PATH 中能够找到 Git 命令。

更多信息 - [如何安装 Git 工具](https://git-scm.com/downloads)

KCL 包管理工具与本地环境中的 Git 工具公用一份登录凭证，当您使用 KCL 包管理工具与私有 Git 仓库交互时，您需要先检查 Git 工具能否正常与私有 Git 仓库交互。如果您使用 `git clone` 命令能够成功下载私有 Git 仓库，您可以直接使用 KCL 包管理工具而不需要进行任何登录操作。

更多信息 - [使用 Git 下载私有仓库](https://docs.github.com/zh/repositories/creating-and-managing-repositories/cloning-a-repository)

## 添加 Git 仓库作为一个三方库依赖

你可以使用 `kcl mod add` 命令将 Git 仓库添加为当前 KCL 包的三方库依赖。

以 `https://github.com/kcl-lang/konfig` 为例，命令如下：

```shell
kcl mod add git://github.com/kcl-lang/konfig --tag v0.4.0 # 添加一个带有 tag 的 Git 仓库
kcl mod add git://github.com/kcl-lang/konfig --commit 78ba6e9 # 添加一个带有 commit 的 Git 仓库
kcl mod add git://github.com/kcl-lang/konfig --branch main # 添加一个带有 branch 的 Git 仓库
```

如上所示的方式是使用 Https 协议将 Git 仓库添加为一个依赖。你也可以使用 `ssh` 协议或其他协议将 Git 仓库添加为一个依赖，如下所示：

```shell
kcl mod add --git https://github.com/kcl-lang/konfig --tag v0.4.0 # 添加一个带有 tag 的 Git 仓库和 Https 协议
kcl mod add --git https://github.com/kcl-lang/konfig --branch main # 添加一个带有 branch 的 Git 仓库和 Https 协议
kcl mod add --git ssh://github.com/kcl-lang/konfig --commit 78ba6e9 # 添加一个带有 commit 的 Git 仓库和 ssh 协议
```
