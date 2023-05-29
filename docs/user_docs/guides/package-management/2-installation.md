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
