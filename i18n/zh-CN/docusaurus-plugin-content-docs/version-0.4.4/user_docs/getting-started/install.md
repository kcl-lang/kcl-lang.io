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

### 使用脚本安装最新版本

#### MacOS

将 KCL darwin 最新版本安装到 /usr/local/kclvm/bin

```bash
curl -fsSL https://kcl-lang.io/script/install.sh | /bin/bash
```

#### Linux

将 KCL linux 最新版本安装到 /usr/local/kclvm/bin

```bash
wget -q https://kcl-lang.io/script/install.sh -O - | /bin/bash
```

#### Windows

将 KCL windows 最新版本安装到 $Env:SystemDrive\kclvm\bin，并将该目录添加到用户 PATH 环境变量中。

```bash
powershell -Command "iwr -useb https://kcl-lang.io/script/install.ps1 | iex"
```

### Homebrew (MacOS)

```bash
brew install kcl-lang/tap/kclvm
```

### 使用 Python3 安装

通过 `Python3` 和 `pip` 安装 `kcl` (Python3 要求 3.7.3+)

```bash
python3 -m pip install kclvm --user && alias kcl='python3 -m kclvm'
```

### 使用 Go 安装

通过 `Go` 命令安装 (Go 要求 1.17+)

```bash
go install kusionstack.io/kclvm-go/cmds/kcl-go@main && alias kcl='kcl-go kcl'
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

### 注意

> ⚠️ 对于上述所有安装方式, 如果您想使用 [KCL Python 插件](https://kcl-lang.io/docs/reference/plugin/overview), 需要确保您已经安装了 Python 3.7+ 并将 python3 命令添加到您的 PATH 中

## 2. 安装 VS Code 插件

为了提高 IDE 开发 KCL 的效率，KCL 为 VS Code 在线版和本地版本提供了插件支持。在线版本可以从 https://vscode.dev 地址打开，然后安装“KCL for vscode.dev 插件”，效果如下:

![](/img/docs/user_docs/getting-started/install/ide-vscode.png)

本地 VS Code 可以安装完整的 [KCL 插件](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-extension)，提供了高亮、自动补全（部分：关键字补全等）、跳转、悬停、大纲等功能。插件虽然不是 KCL 必须的部分，但是可以提高效率推荐安装。

## 下一步

+ [KCL 快速开始](/docs/user_docs/getting-started/kcl-quick-start)
