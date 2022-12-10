---
sidebar_position: 2
---

# Installation

## 1. Install KCL

### From the Binary Releases

Each release of KCL includes various OSes and architectures. These binary versions can be manually downloaded and installed from [Github](https://github.com/KusionStack/KCLVM/releases/) and add `{install-location}/kclvm/bin` to the environment PATH.

```cmd
export PATH=$PATH:{install-location}/kclvm/bin
```

### From Python3

Install `kcl` through the `python3` and `pip` (`python3` requires 3.7.3+).

```cmd
python3 -m pip install kclvm && alias kcl='python3 -m kclvm'
```

### From Docker

+ Command

```cmd
docker run --rm -p 8080:8080 -it kusionstack/kclvm
```

+ Update image

```cmd
docker pull kusionstack/kclvm
```

## 2. Install the KCL VS Code Extension

To improve the KCL development on VS Code, there are VS Code
 extensions for both VS Code Web IDE and VS Code.

The [VS Code Web IDE](https://vscode.dev) can be reached through the browser, and you can search and install the [KCL for vscode.dev](https://marketplace.visualstudio.com/items?itemName=kcl.kcl-vscode-web-extension) in the VS Code Extension tab. And here's the syntax highlighting view you'll get:

![](/img/docs/user_docs/getting-started/install/ide-vscode.png)

The KCL extension for the local VS Code IDE provides more rich language support for the KCL language such as highlighting, auto-completion, quick info hover and code navigation, etc. Although the extension is not a must-required part of KCL, it is recommended to install it to improve coding efficiency.

## Next step

+ [KCL Quick Start](/docs/user_docs/getting-started/kcl-quick-start)
