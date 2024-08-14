# 发布 KCL 包到 docker.io

本文将指导您如何使用 kcl 包管理将您的 kcl 包推送到发布到 docker.io 中。

## 步骤 1：安装 KCL CLI

首先，您需要在您的计算机上安装 KCL CLI。您可以按照 [KCL CLI 安装文档](https://kcl-lang.io/zh-CN/docs/user_docs/getting-started/install)中的说明进行操作。

## 步骤 2：创建一个 docker.io 账户

您需要创建一个 docker.io 账户以支持您的 kcl 包的推送。

## 步骤 3：登录 docker.io

您可以直接使用 docker.io 的账户名和密码登录。

```shell
kcl registry login -u <USERNAME> -p <TOKEN> docker.io
```

其中 `<USERNAME>` 是您的 docker.io 用户名，`<PASSWORD>` 是您 docker.io 账户的密码。

关于如何使用 KCL CLI 登录 docker.io 的更多信息，请参阅 [kcl registry login](https://www.kcl-lang.io/zh-CN/docs/tools/cli/package-management/command-reference/login)。

## 步骤 4：推送您的 kcl 包

现在，您可以使用 KCL CLI 将您的 kcl 包推送到 docker.io。

### 1. 一个合法的 kcl 包

首先，您需要确保您推送的内容是符合一个 kcl 包的规范，即必须包含合法的 kcl.mod 和 kcl.mod.lock 文件。

如果您不知道如何得到一个合法的 `kcl.mod` 和 `kcl.mod.lock`。您可以使用 `kcl mod init` 命令。

例如：创建一个名为 my_package 的 kcl 包

```shell
# 创建一个名为 my_package 的 kcl 包
kcl mod init my_package
```

`kcl mod init my_package` 命令将会为您创建一个新的 kcl 包 `my_package`, 并为这个包创建 `kcl.mod` 和 `kcl.mod.lock` 文件。

如果您已经有了一个包含 kcl 文件的目录 `exist_kcl_package`，您可以使用以下命令将其转换为一个 kcl 包，并为其创建合法的 `kcl.mod` 和 `kcl.mod.lock`。

在 `exist_kcl_package` 目录下执行:

```shell
kcl mod init
```

关于如何使用 kcl mod init 的更多信息，请参阅 [kcl mod init](https://kcl-lang.io/zh-CN/docs/tools/cli/package-management/command-reference/init)。

### 2. 推送 kcl 包

您可以在 `kcl` 包的根目录下使用以下命令进行操作：

在 `exist_kcl_package` 包的根目录下, 执行

```shell
kcl mod push oci://docker.io/<USERNAME>/exist_kcl_package
```

完成上述步骤后，您就成功地将您的 kcl 包 `exist_kcl_package` 推送到了 docker.io 中。
关于如何使用 kcl mod push 的更多信息，请参阅 [kcl mod push](https://kcl-lang.io/zh-CN/docs/tools/cli/package-management/command-reference/push)。
