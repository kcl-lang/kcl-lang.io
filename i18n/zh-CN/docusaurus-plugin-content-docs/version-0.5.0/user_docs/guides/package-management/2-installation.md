# 安装

## 安装 `kpm`

kpm 将调用 `KCL`编译器来编译 KCL 程序。在使用 `kpm` 之前，您需要确保 `KCL` 编译器已经成功安装，您可以参照[如何安装 KCL 编译器](https://kcl-lang.io/docs/user_docs/getting-started/install)。

### 使用 `go install` 安装 `kpm`

您可以使用 go install 命令安装 kpm。

```shell
go install kusionstack.io/kpm@latest
```

### 从 Github release 页面手动安装 `kpm`

您可以从 [kpm Github Release](https://github.com/KusionStack/kpm/releases) 中获取 `kpm` ，并将 `kpm` 的二进制文件路径设置到环境变量 PATH 中。

```shell
# KPM_INSTALLATION_PATH 是 `kpm` 二进制文件的所在目录.
export PATH=$KPM_INSTALLATION_PATH:$PATH  
```

请使用以下命令以确保您成功安装了`kpm`。

```shell
kpm --help
```

如果你看到以下输出信息，那么你已经成功安装了`kpm`，可以继续执行下一步操作。

```shell
NAME:
   kpm - kpm is a kcl package manager

USAGE:
   kpm  <command> [arguments]...

COMMANDS:
   init      initialize new module in current directory
   add       add new dependancy
   pkg       package a kcl package into tar
   metadata  output the resolved dependencies of a package
   run       compile kcl package.
   login     login to a registry
   logout    logout from a registry
   push      push kcl package to OCI registry.
   pull      pull kcl package from OCI registry.
   help, h   Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --help, -h  show help
```
