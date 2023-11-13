---
sidebar_position: 5
---

# 安装问题

## MacOS 提示无法打开 "kcl"，因为 Apple 无法检查其是否包含恶意软件

MacOS 提示无法打开 "kcl"，因为 Apple 无法检查其是否包含恶意软件。这个错误是因为 macOS 操作系统中的 Gatekeeper 安全功能阻止了应用程序的运行。要解决此问题，请按照以下步骤操作：

打开"系统偏好设置"并点击"安全性与隐私"。 在"通用"选项卡中，您将看到一个消息："kcl" 已被阻止。单击"仍要打开"。 或者，你可以单击"打开任何方式"以打开你的应用程序。（可能需要使用管理员权限来打开应用程序。）

如果不想在每次打开应用程序时都执行这些步骤，则可以的应用程序添加到白名单中，以便在不受阻止的情况下运行。要将您的应用程序添加到白名单中，请执行以下操作：

打开终端并输入以下命令：

```shell
xattr -rd com.apple.quarantine /path/to/kcl
```

其中，/path/to/kcl 是 kcl 应用程序的完整路径。运行命令后，应用程序将被添加到白名单中，Gatekeeper 将不再阻止其运行。

## 在 Windows/Linux/MacOS 平台上抱 program not found 或者 run linker failed 错误

请确保如下依赖在您的 PATH 中

- MacOS: `clang`
- Linux: `gcc`
- Windows: `cl.exe` (可以通过安装 MSVC 获得)
