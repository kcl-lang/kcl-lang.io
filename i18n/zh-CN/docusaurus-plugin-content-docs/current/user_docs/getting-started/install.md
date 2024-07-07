---
sidebar_position: 2
---

# 安装

## 1. 安装 KCL

### 二进制下载

KCL 的每个版本都包含各种操作系统和体系结构。这些二进制版本可以从 [Github](https://github.com/kcl-lang/cli/releases/) 手动下载并安装，下载完成后将 `{install-location}/kclvm/bin` 添加到环境变量 PATH 中。

> ⚠️ 如果您不能成功访问 Github, 也可以访问 Gitee 获得二进制进行安装

#### MacOS & Linux

```bash
export PATH=$PATH:{install-location}
```

#### Windows

```powershell
$env:PATH += ";{install-location};"
```

### 使用脚本安装最新版本

#### MacOS

将 KCL darwin 最新版本安装到 /usr/local/bin

```bash
curl -fsSL https://kcl-lang.io/script/install-cli.sh | /bin/bash
```

卸载

```bash
curl -fsSL https://kcl-lang.io/script/uninstall-cli.sh | /bin/bash
```

#### Linux

将 KCL linux 最新版本安装到 /usr/local/bin

```bash
wget -q https://kcl-lang.io/script/install-cli.sh -O - | /bin/bash
```

卸载

```bash
wget -q https://kcl-lang.io/script/uninstall-cli.sh -O - | /bin/bash
```

#### Windows

将 KCL windows 最新版本安装到 $Env:SystemDrive\kclvm\bin，并将该目录添加到用户 PATH 环境变量中。

```bash
wget -q https://kcl-lang.io/script/uninstall-cli.sh -O - | /bin/bash
```

卸载

```shell
powershell -Command "iwr -useb https://kcl-lang.io/script/uninstall-cli.ps1 | iex"
```

#### Homebrew (MacOS)

- 安装最新版本

```bash
# 安装最新版本
brew install kcl-lang/tap/kcl@0.8.0

# 安装固定版本
brew install kcl-lang/tap/kcl@x.y.z
```

- 升级

```bash
brew upgrade kcl-lang/tap/kcl
```

- 卸载

```bash
brew uninstall kcl-lang/tap/kcl
```

#### Scoop (Windows)

首先安装 [Scoop](https://scoop.sh/), 然后通过如下命令安装 `kcl`:

```bash
scoop bucket add kcl-lang https://github.com/kcl-lang/scoop-bucket.git
scoop install kcl-lang/kcl
```

### 使用 Go 安装

通过 `Go` 命令安装 (Go 要求 1.19+)

```bash
go install kcl-lang.io/cli/cmd/kcl@latest
```

### 使用 Docker 镜像安装

- 基本命令

```bash
docker run --rm -it kcllang/kcl
```

- 更新镜像

```bash
docker pull kcllang/kcl
```

### 使用 Nix 安装

查看[这里](https://search.nixos.org/packages?channel=unstable&show=kcl-cli&from=0&size=50&sort=relevance&type=packages&query=kcl-cli)

### 注意

可以执行运行如下命令确保 KCL 已经正确安装

```bash
kcl --help
```

如果您无法成功安装并运行 KCL，可以参考[这里](/docs/user_docs/support/faq-install)

## 2. 安装 KCL IDE 插件

### 安装语言服务器

在我们启用 IDE 插件之前，首先我们安装 KCL Language Server 二进制并添加到 PATH 中。

#### MacOS

将 KCL language server darwin 最新版本安装到 /usr/local/bin

```bash
curl -fsSL https://kcl-lang.io/script/install-kcl-lsp.sh | /bin/bash
```

#### Linux

将 KCL language server linux 最新版本安装到 /usr/local/bin

```bash
wget -q https://kcl-lang.io/script/install-kcl-lsp.sh -O - | /bin/bash
```

#### Windows

将 KCL language server windows 最新版本安装到 $Env:SystemDrive\kclvm\bin，并将该目录添加到用户 PATH 环境变量中。

```bash
powershell -Command "iwr -useb https://kcl-lang.io/script/install-kcl-lsp.ps1 | iex"
```

### Homebrew (MacOS)

- 安装最新版本

```bash
# 安装最新版本
brew install kcl-lang/tap/kcl-lsp@0.7.0

# 安装固定版本
brew install kcl-lang/tap/kcl-lsp@x.y.z
```

- 升级

```bash
brew upgrade kcl-lang/tap/kcl-lsp
```

- 卸载

```bash
brew uninstall kcl-lang/tap/kcl-lsp
```

### Scoop (Windows)

首先安装 [Scoop](https://scoop.sh/), 然后通过如下命令安装 `kcl-language-server` 二进制:

```bash
scoop bucket add kcl-lang https://github.com/kcl-lang/scoop-bucket.git
scoop install kcl-lang/kcl-lsp
```

### 安装 IDE 插件客户端

#### VS Code

KCL 为 VS Code 本地版本提供了插件支持，并提供了高亮、自动补全、跳转、悬停、大纲等功能。您可以[点击这里](/docs/tools/Ide/vs-code)进行安装。

![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)

#### NeoVim

参见[此处](https://github.com/kcl-lang/kcl.nvim)配置 KCL 语言服务器并启用它。

![kcl.nvim](/img/docs/tools/Ide/neovim/overview.png)

#### IntelliJ IDEA

从[这里](https://github.com/kcl-lang/intellij-kcl/releases)下载发行版，在 IntelliJ IDEA 中，点击 Preference -> plugins -> install Plugin from Disk... -> 选择 kcl-idea-plugin zip -> 重启 IDE。此插件需要 IntelliJ IDEA 2020.2+

![intellij](/img/docs/tools/Ide/intellij/overview.png)
