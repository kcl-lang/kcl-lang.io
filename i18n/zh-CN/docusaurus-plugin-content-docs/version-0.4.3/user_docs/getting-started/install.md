---
sidebar_position: 2
---

# 安装

## 1. 安装 KCL

### 二进制下载

KCL 的每个版本都包含各种操作系统和体系结构。这些二进制版本可以从 [Github](https://github.com/KusionStack/KCLVM/releases/) 手动下载并安装，下载完成后将 `{install-location}/kclvm/bin` 添加到环境变量 PATH 中。

#### MacOS & Linux

```bash
export PATH=$PATH:{install-location}/kclvm/bin
```

#### Windows

```powershell
$env:PATH += ";{install-location}\kclvm\bin;"
```

### Homebrew (MacOS)

```bash
brew install kcl-lang/tap/kclvm
```

### 使用 Python3 安装

通过 `Python3` 和 `pip` 安装 `kcl` (Python3 要求 3.7.3+)

```bash
python3 -m pip install kclvm --user
```

添加一个 kcl 命令的别名 (可选)

```bash
alias kcl='python3 -m kclvm'
```

### 使用 Docker 镜像安装

+ 基本命令

```bash
docker run --rm -p 8080:8080 -it kusionstack/kclvm
```

+ 更新镜像

```bash
docker pull kusionstack/kclvm
```

## 2. 安装 VS Code 插件

为了提高 IDE 开发 KCL 的效率，KCL 为 VS Code 在线版和本地版本提供了插件支持。在线版本可以从 https://vscode.dev 地址打开，然后安装“KCL for vscode.dev 插件”，效果如下:

![](/img/docs/user_docs/getting-started/install/ide-vscode.png)

本地 VS Code 可以安装完整的 [KCL 插件](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-extension)，提供了高亮、自动补全（部分：关键字补全等）、跳转、悬停、大纲等功能。插件虽然不是 KCL 必须的部分，但是可以提高效率推荐安装。

## 下一步

+ [KCL 快速开始](/docs/user_docs/getting-started/kcl-quick-start)
