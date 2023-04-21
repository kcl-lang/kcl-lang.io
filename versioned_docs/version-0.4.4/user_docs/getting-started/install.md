---
sidebar_position: 2
---

# Installation

## 1. Install KCL

### From the Binary Releases

Each release of KCL includes various OSes and architectures. These binary versions can be manually downloaded and installed from [Github](https://github.com/KusionStack/KCLVM/releases/) and add `{install-location}/kclvm/bin` to the environment PATH.

#### MacOS & Linux

```bash
export PATH=$PATH:{install-location}/kclvm/bin
```

#### Windows

```powershell
$env:PATH += ";{install-location}\kclvm\bin;"
```

### Using script to install the latest release

#### MacOS

Install the latest darwin KCL to /usr/local/kclvm/bin

```bash
curl -fsSL https://kcl-lang.io/script/install.sh | /bin/bash
```

#### Linux

Install the latest linux KCL to /usr/local/kclvm/bin

```bash
wget -q https://kcl-lang.io/script/install.sh -O - | /bin/bash
```

#### Windows

Install the latest windows KCL to $Env:SystemDrive\kclvm\bin and add this directory to User PATH environment variable.

```bash
powershell -Command "iwr -useb https://kcl-lang.io/script/install.ps1 | iex"
```

### Homebrew (MacOS)

```bash
brew install kcl-lang/tap/kclvm
```

### From Python3

Install `kcl` through the `python3` and `pip` (`python3` requires 3.7.3+).

```bash
python3 -m pip install kclvm --user
```

Add an alias for the kcl command (optional).

```bash
alias kcl='python3 -m kclvm'
```

### From Go

Install `kcl` through the `Go` command (`Go` requires 1.18+).

```bash
go install kusionstack.io/kclvm-go/cmds/kcl-go@main
```

Add an alias for the kcl command (optional).

```bash
alias kcl='kcl-go run'
```

### From Docker

+ Command

```bash
docker run --rm -p 8080:8080 -it kusionstack/kclvm
```

+ Update image

```bash
docker pull kusionstack/kclvm
```

### Note

> ⚠️ For all the above operating systems and installation methods, if you want to use [KCL Python plug-in](https://kcl-lang.io/docs/reference/plugin/overview), you need to ensure that Python 3.7+ is installed and add the python3 command to your PATH environment variable.

> To avoid the GLIBC version being too low, for lower versions of Linux such as Centos7, you can visit [Github](https://github.com/KusionStack/KCLVM/releases/) to find the release of kclvm-centos and download and install it.

## 2. Install the KCL IDE Extension

### VS Code

There are VS Code extensions for both VS Code and VS Code Web IDE.

The KCL extension for the local VS Code IDE can be download from [here](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-extension) and it provides more rich language support for the KCL language such as highlighting, auto-completion, quick info hover and code navigation, etc.

The [VS Code Web IDE](https://vscode.dev) can be reached through the browser, and you can search and install the [KCL for vscode.dev](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-web-extension) in the VS Code Extension tab. And here's the syntax highlighting view you'll get:

![](/img/docs/user_docs/getting-started/install/ide-vscode.png)

### IntelliJ IDEA

Download the distribution from [here](https://github.com/KusionStack/intellij-kcl) and in IntelliJ IDEA, click Preference -> plugins -> install Plugin from Disk... -> select kcl-idea-plugin zip -> restart IDE. This plugin requires the IntelliJ IDEA 2020.2+

## Next Step

+ [KCL Quick Start](/docs/user_docs/getting-started/kcl-quick-start)
