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

### Scoop (Windows)

Install [Scoop](https://scoop.sh/) first, then add this bucket and install `kcl` by running:

```bash
scoop bucket add kcl-lang https://github.com/kcl-lang/scoop-bucket.git
scoop install kcl-lang/kclvm
```

### From Go

Install `kcl` through the `Go` command (`Go` requires 1.17+).

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
docker run --rm -it kusionstack/kclvm
```

+ Update image

```bash
docker pull kusionstack/kclvm
```

### Note

> ⚠️ For all the above operating systems and installation methods, if you want to use [KCL Python plug-in](https://kcl-lang.io/docs/reference/plugin/overview), you need to ensure that Python 3.7+ is installed and add the python3 command to your PATH environment variable.

## 2. Install the KCL IDE Extension

### VS Code

The KCL Extension extension provides some coding assistance, e.g., highlight, goto definition, completion, hover, outline, and diagnostics. You can go [here](https://kcl-lang.io/docs/tools/Ide/vs-code) for more information。

![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)

### IntelliJ IDEA

Download the distribution from [here](https://github.com/KusionStack/intellij-kcl) and in IntelliJ IDEA, click Preference -> plugins -> install Plugin from Disk... -> select kcl-idea-plugin zip -> restart IDE. This plugin requires the IntelliJ IDEA 2020.2+

## Next Step

+ [KCL Quick Start](/docs/user_docs/getting-started/kcl-quick-start)
