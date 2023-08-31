---
sidebar_position: 2
---

# Installation

## 1. Install KCL

### From the Binary Releases

Each release of KCL includes various OSes and architectures. These binary versions can be manually downloaded and installed from [Github](https://github.com/kcl-lang/kcl/releases/) or [Gitee](https://gitee.com/kusionstack/kcl/releases) and add `{install-location}/kclvm/bin` to the environment PATH.

> ⚠️ If you cannot successfully access Github, you can also access Gitee to obtain binaries for installation.

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

Install or upgrade the latest darwin KCL to /usr/local/kclvm/bin

```bash
curl -fsSL https://kcl-lang.io/script/install.sh | /bin/bash
```

#### Linux

Install or upgrade the latest linux KCL to /usr/local/kclvm/bin

```bash
wget -q https://kcl-lang.io/script/install.sh -O - | /bin/bash
```

#### Windows

Install or upgrade the latest windows KCL to $Env:SystemDrive\kclvm\bin and add this directory to User PATH environment variable.

```bash
powershell -Command "iwr -useb https://kcl-lang.io/script/install.ps1 | iex"
```

### Homebrew (MacOS)

+ Install

```bash
brew install kcl-lang/tap/kcl
```

+ Upgrade

```bash
brew upgrade kcl-lang/tap/kcl
```

+ Uninstall

```bash
brew uninstall kcl-lang/tap/kcl
```

### Scoop (Windows)

Install [Scoop](https://scoop.sh/) first, then add this bucket and install `kcl` by running:

```bash
scoop bucket add kcl-lang https://github.com/kcl-lang/scoop-bucket.git
scoop install kcl-lang/kcl
```

### From Go

Install `kcl` through the `Go` command (`Go` requires 1.18+).

```bash
go install kcl-lang.io/kcl-go/cmds/kcl-go@main
```

Add an alias for the kcl command (optional).

```bash
alias kcl='kcl-go run'
```

> Note: `kcl-go` does not rely on the installation of `kcl`, but if `kcl` exists in PATH, it will be used by `kcl-go` first.

### From Docker

+ Command

```bash
docker run --rm -it kcllang/kcl
```

+ Update image

```bash
docker pull kcllang/kcl
```

### Note

We can execute the following command to ensure that KCL has been installed correctly.

```bash
kcl -V
```

The output may looks like this:

```bash
Version: {kcl version}
Platform: {your platform}
GitCommit: {git commit}
```

For all the above operating systems and installation methods, if you want to use [KCL Python Plugin](/docs/reference/plugin/overview), you need to ensure that Python 3.7+ is installed and add the python3 command to your PATH environment variable.

## 2. Install KCL IDE Extension

### VS Code

The KCL Extension extension provides some coding assistance, e.g., highlight, goto definition, completion, hover, outline, and diagnostics. You can go [here](/docs/tools/Ide/vs-code) for more information about the installation.

![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)

### IntelliJ IDEA

Download the distribution from [here](https://github.com/kcl-lang/intellij-kcl/releases) and in IntelliJ IDEA, click Preference -> plugins -> install Plugin from Disk... -> select kcl-idea-plugin zip -> restart IDE. This plugin requires the IntelliJ IDEA 2020.2+
