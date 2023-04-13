# 安装

## 安装 `kpm`

kpm 将调用 KCLVM 来编译 KCL 程序。在使用 kpm 之前，您需要确保 KCLVM 已经成功安装。

[如何安装 KCLVM.](https://kcl-lang.io/docs/user_docs/getting-started/install)

您可以从 [kpm github release](https://github.com/KusionStack/kpm/releases) 中获取 kpm ，并将 kpm 的二进制文件路径设置到环境变量 PATH 中。

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

VERSION:
   v0.0.1

COMMANDS:
   init     initialize new module in current directory
   add      add new dependancy
   pkg      package a kcl package into tar
   run      compile kcl package.
   help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --help, -h     show help
   --version, -v  print the version
```

### 设置环境变量

你需要设置一个环境变量 KPM_HOME 来声明 `kpm` 下载的 KCL 包的位置。

注意: 目前 `kpm` 不支持将外部的包下载到包的内部，所以请确保 `$KPM_HOME` 不要与当前 KCL 包为同一个目录。

```shell
# Kpm 下载的包将会保存在 /user/xxx/xxx/path 目录下. 
export KPM_HOME="/user/xxx/xxx/path" 
```

在成功安装 KCLVM 后，为了确保 KCLVM 可以找到 `kpm` 下载的包，你需要设置环境变量 $KCLVM_VENDOR_HOME 并将其指向 $KPM_HOME。

```shell
export KCLVM_VENDOR_HOME=$KPM_HOME
```
