# Installation

## Install `kpm`

Before installing and using kpm, ensure that KCLVM has been installed successfully.

[How to install KCLVM.](https://kcl-lang.io/docs/user_docs/getting-started/install)

You can get `kpm` from the [kpm github release](https://github.com/KusionStack/kpm/releases) and set the `kpm` binary path to the environment variable PATH.

```shell
# KPM_INSTALLATION_PATH is the path of the `kpm` binary.
export PATH=$KPM_INSTALLATION_PATH:$PATH  
```

Use the following command to ensure that you install `kpm` successfully.

```shell
kpm --help
```

If you get the following output, you have successfully installed `kpm` and you can proceed to the following steps.

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

## Set environment variables

You need to set an environment variable `KPM_HOME` to hold the KCL packages downloaded by `kpm`.

Note: `kpm` does not support downloading external packages into the current kcl package directory, so make sure that '$KPM_HOME' is not in the same directory as the current KCL package.

```shell
# The directory to save the packages downloaded by Kpm. 
export KPM_HOME="/user/xxx/xxx/path" 
```

To ensure that KCLVM can find the packages downloaded by `kpm`, you need to set the environment variables `$KCLVM_VENDOR_HOME` and point it to `$KPM_HOME` for KCLVM after downloading KCLVM.

```shell
export KCLVM_VENDOR_HOME=$KPM_HOME
```
