---
sidebar_position: 2
---

# 安装

## 1. 安装 KCL

### 二进制下载

KCL 的每个版本都包含各种操作系统和体系结构。这些二进制版本可以从 [Github](https://github.com/KusionStack/kcl/releases/) 或者 [Gitee](https://gitee.com/kusionstack/KCLVM/releases) 手动下载并安装，下载完成后将 `{install-location}/kclvm/bin` 添加到环境变量 PATH 中。

> ⚠️ 如果您不能成功访问 Github, 也可以访问 Gitee 获得二进制进行安装

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

+ 安装

```bash
brew install kcl-lang/tap/kclvm
```

+ 升级

```bash
brew upgrade kcl-lang/tap/kclvm
```

+ 卸载

```bash
brew uninstall kcl-lang/tap/kclvm
```

### Scoop (Windows)

首先安装 [Scoop](https://scoop.sh/), 然后通过如下命令安装 `kcl`:

```bash
scoop bucket add kcl-lang https://github.com/kcl-lang/scoop-bucket.git
scoop install kcl-lang/kclvm
```

### 使用 Go 安装

通过 `Go` 命令安装 (Go 要求 1.18+)

```bash
go install kcl-lang.io/kcl-go/cmds/kcl-go@main
```

添加一个 kcl 命令的别名 (可选)

```bash
alias kcl='kcl-go run'
```

### 使用 Docker 镜像安装

+ 基本命令

```bash
docker run --rm -it kusionstack/kclvm
```

+ 更新镜像

```bash
docker pull kusionstack/kclvm
```

### 注意

可以执行运行如下命令确保 KCL 已经正确安装

```bash
kcl -V
```

如果安装成功，输出可能为如下形式 (不同版本结果可能稍微不同):

```bash
Version: {kcl version}
Platform: {your platform}
GitCommit: {git commit}
```

对于上述所有安装方式, 如果您想使用 [KCL Python 插件](/docs/reference/plugin/overview), 需要确保您已经安装了 Python 3.7+ 并将 python3 命令添加到您的 PATH 中。

## 2. 安装 KCL IDE 插件

### VS Code

KCL 为 VS Code 本地版本提供了插件支持，并提供了高亮、自动补全、跳转、悬停、大纲等功能。您可以[点击这里](/docs/tools/Ide/vs-code)进行安装。

![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)

### IntelliJ IDEA

从[这里](https://github.com/KusionStack/intellij-kcl/releases)下载发行版，在 IntelliJ IDEA 中，点击 Preference -> plugins -> install Plugin from Disk... -> 选择 kcl-idea-plugin zip -> 重启 IDE。此插件需要 IntelliJ IDEA 2020.2+
